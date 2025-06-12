package com.example.lms.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.lms.dto.SessionUserDTO;
import com.example.lms.dto.StudentDTO;
import com.example.lms.dto.TeacherDTO;
import com.example.lms.service.MypageService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/mypage")
public class MypageController {
	@Autowired
	private MypageService mypageService;
	@Autowired
	private PasswordEncoder passwordEncoder;	// 비밀번호를 암호화해주는 도구 (예: BCrypt)
	
	@GetMapping
	public String mypage(HttpSession session, Model model) {
		// 세션에서 사용자 정보 꺼내서 model에 담기
		SessionUserDTO loginUser = (SessionUserDTO) session.getAttribute("loginUser");
		if(loginUser == null) {
			return "redirect:/login"; // 로그인 안 된 상태면 로그인 페이지로
		}
	
		model.addAttribute("loginUser", loginUser);
		return "mypage";
	}
	
	// AJAX 요청: 개인정보 영역
	@GetMapping("/info")	// GET 방식으로 "/mypage/info" 요청이 오면 이 메서드 실행
	public String showInfo(HttpSession session, Model model) {
		SessionUserDTO loginUser = (SessionUserDTO) session.getAttribute("loginUser");		// 세션에서 로그인한 사용자 정보 꺼냄
		if(loginUser == null) {			// 로그인 안되어있으면 로그인 페이지로 리다이렉트
			return "redirect:/login";
		}
		// 세션에 저장된 간단한 로그인 정보 (이름, role, id 등)
		model.addAttribute("loginUser", loginUser);		
		
		// 강사일 경우
		if ("teacher".equals(loginUser.getRole())) {
			model.addAttribute("fullUser", mypageService.getTeacherById(loginUser.getTeacherId()));
		   // System.out.println("📞 phone: " + t.getPhone()); // 이게 null인지 체크
		    //System.out.println("courseName: " + t.getCourseName()); // 과목 이름 체크
		    
			// 학생일 경우
		} else if ("student".equals(loginUser.getRole())) {
			// 세션에 저장된 studentId로 학생 정보 전체를 DB에서 조회
			model.addAttribute("fullUser", mypageService.getStudentById(loginUser.getStudentId()));
		}

		// jsp에서 사용할 데이터 전달
		return "mypage/info";
	}
	
	// 아이디 중복확인
	// json 데이터를 반환하는 의미
	@PostMapping("/check-id")
	@ResponseBody
	public Map<String, Boolean> checkTeacherId(@RequestBody Map<String, String> body) {
		Map<String, Boolean> result = new HashMap<>();
		
		// loginService를 통해 해당 teacherId가 DB에 존재하는지 확인
		// 내부적으로는 SELECT COUNT(*) 쿼리를 실행(0 또는 1 이상 반환)
		if (body.containsKey("teacherId")) {
		int count = mypageService.isTeacherIdExist(body.get("teacherId"));
		
		// count > 0 이면 이미 존재하는 아이디 -> true (중복)
		// count == 0 이면 사용 가능 -> false(중복 아님)
		boolean exists = count > 0;
		
		} else if (body.containsKey("studentId")) {
			int count = mypageService.isStudentIdExist(body.get("studentId"));
	        result.put("exists", count > 0);
	 	} else {
	        result.put("exists", true); // key가 없으면 무조건 중복 처리
	    }
		return result;
		
		//Map을 반환하면 json 형식으로 자동 변환되어 응답됨
	}
	
	// 개인정보 수정
	// 강사
	@PostMapping("/updateTeacherInfo")
	@ResponseBody
	public Map<String, Object> updateInfo(TeacherDTO teacherDto, HttpSession session) {
	    Map<String, Object> result = new HashMap<>();

	    // 세션 체크
	    SessionUserDTO loginUser = (SessionUserDTO) session.getAttribute("loginUser");
	    if (loginUser == null) {
	        result.put("success", false);
	        result.put("message", "로그인이 필요합니다.");
	        return result;
	    }
	 // 1. 기존 아이디 보관
	    String oldTeacherId = ((SessionUserDTO) session.getAttribute("loginUser")).getTeacherId();
	    

	    // 2. 기존 정보 가져오기
	    TeacherDTO current = mypageService.getTeacherById(oldTeacherId);
	    // System.out.println("teacherNo: " + teacherDto.getTeacherNo());
	    if (current == null) {
	        result.put("success", false);
	        result.put("message", "기존 사용자 정보를 찾을 수 없습니다.");
	        return result;
	    }
	    
	    
	    // PK인 teacherNo는 고정
	    teacherDto.setTeacherNo(current.getTeacherNo());

	    // 입력 안 한 값은 기존 값 유지
	    if (teacherDto.getTeacherId() == null || teacherDto.getTeacherId().isBlank()) {
	        teacherDto.setTeacherId(oldTeacherId);
	    }
	    
	    if (teacherDto.getEmail() == null || teacherDto.getEmail().isBlank()) {
	        teacherDto.setEmail(current.getEmail());
	    }
	    if (teacherDto.getPhone() == null || teacherDto.getPhone().isBlank()) {
	        teacherDto.setPhone(current.getPhone());
	    }
	    
	    // 현재 비밀번호 확인
	    if (!teacherDto.getCurrentPassword().equals(current.getPassword())) {
	        result.put("success", false);
	        result.put("message", "현재 비밀번호가 일치하지 않습니다.");
	        return result;
	    }
	 // 평문 비교
	    if (teacherDto.getPassword() != null && !teacherDto.getPassword().isBlank()) {
	        if (teacherDto.getPassword().equals(current.getPassword())) {
	            result.put("success", false);
	            result.put("message", "기존 비밀번호와 동일합니다.");
	           // System.out.println("입력된 비밀번호: " + teacherDto.getPassword());
	           // System.out.println("현재 DB 비밀번호: " + current.getPassword());
	           // System.out.println("같은가? " + teacherDto.getPassword().equals(current.getPassword()));
	            return result;
	        }
	        teacherDto.setPassword(teacherDto.getPassword()); // 그대로 저장
	    } else {
	        teacherDto.setPassword(current.getPassword()); // 변경 없으면 기존 유지
	    }
	    // 비밀번호 변경 여부 확인 및 암호화
	   /* 지금 db에 암호화된 비밀번호가 아니라서 추후에 회원가입할때 암호화 하게되면 이 코드로 변경
	   if (teacherDto.getPassword() != null && !teacherDto.getPassword().isBlank()) {
	        if (passwordEncoder.matches(teacherDto.getPassword(), current.getPassword())) {
	            result.put("success", false);
	            result.put("message", "기존 비밀번호와 동일합니다.");
	            return result;
	        }
	        teacherDto.setPassword(passwordEncoder.encode(teacherDto.getPassword()));
	    } else {
	        teacherDto.setPassword(current.getPassword()); // 비밀번호 변경 안 하면 기존 값 유지
	    }
	    */

	    // DB 업데이트
	    mypageService.updateTeacherInfo(teacherDto);
	    // System.out.println("전달받은 수정 정보: " + teacherDto);
	 // 세션 무효화
	    session.invalidate();

	    // 클라이언트에게 로그인 페이지로 리다이렉트 하라고 안내
	    result.put("success", true);
	    result.put("redirect", "/login");  // JS로 리다이렉트 처리
	    result.put("message", "정보가 수정되었습니다. 다시 로그인해주세요.");
	    return result;
	}
	
	// 학생
	@PostMapping("/updateStudentInfo")	// 요청이 들어오면 실행
	@ResponseBody	// 응답을 json 형태로 돌려줌 (Map -> json 자동 변환)
	public Map<String, Object> updateStudentInfo(StudentDTO studentDto, HttpSession session) {
		Map<String, Object> result = new HashMap<>(); // 클라이언트에게 보낼 응답 데이터 (성공/실패 여부)
		
		// 보안상 세션이 만료되었을경우 확인
		// 세션에서 로그인한 사용자 정보 꺼내기
		SessionUserDTO loginUser = (SessionUserDTO) session.getAttribute("loginUser");
		if (loginUser == null) {
			// 로그인하지 않은 경우
			result.put("success", false);
			result.put("message", "로그인이 필요합니다.");
			return result;
		}
		
		// 세션에서 로그인한 학생의 ID 가져오기
		String oldStudentId = loginUser.getStudentId();
		
		// 기존 학생 정보 조회 (DB에서)
		StudentDTO current = mypageService.getStudentById(oldStudentId);
		if(current == null) {
			//기존 정보를 못 찾은 경우
			result.put("success", false);
			result.put("message", "기존 사용자 정보를 찾을 수 없습니다.");
			return result;
		}
		
		// 기본키는 변경되면 안되므로 DB값 고정
		studentDto.setStudentNo(current.getStudentNo());
		
		// 입력하지 않은 값은 기존 값으로 유지
		if (studentDto.getStudentId() == null || studentDto.getStudentId().isBlank()) {
			studentDto.setStudentId(oldStudentId);
		}
		if (studentDto.getEmail() == null || studentDto.getEmail().isBlank()) {
			studentDto.setEmail(current.getEmail());
		}
		if (studentDto.getPhone() == null || studentDto.getPhone().isBlank()) {
			studentDto.setPhone(current.getPhone());
		}
		
		// 비밀번호 비교 (새 비밀번호가 입력된 경우)
		if (studentDto.getPassword() != null && !studentDto.getPassword().isBlank()) {
			// 기존 비밀번호와 새 비밀번호가 같으면 변경 거부
			if (studentDto.getPassword().equals(current.getPassword())) {
				result.put("success", false);
				result.put("message", "기존 비밀번호와 동일합니다.");
				return result;
			}
			
			// 새 비밀번호 사용 (그대로)
		} else {
			// 새 비밀번호가 입력되지 않았다면 기존 비밀번호 유지
			studentDto.setPassword(current.getPassword());
		}
		
		// 최종적으로 DB에 업데이트 실행
		mypageService.updateStudentInfo(studentDto);
		
		// 세션 초기화 (로그아웃 처리와 비슷함. 다시 로그인 필요)
		session.invalidate();
		
		// 성공 응답 구성
		result.put("success", true);
		result.put("redirect", "/login"); // js에서 이 경로로 리다이렉트할 수 있음
		result.put("message", "정보가 수정되었습니다. 다시 로그인해주세요.");
		
		return result;	// 클라이언트에게 결과 반환
	}
	
	
}



















