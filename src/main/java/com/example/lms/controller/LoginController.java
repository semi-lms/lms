package com.example.lms.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.lms.dto.AdminDTO;
import com.example.lms.dto.LoginDTO;
import com.example.lms.dto.SessionUserDTO;
import com.example.lms.dto.StudentDTO;
import com.example.lms.dto.TeacherDTO;
import com.example.lms.service.LoginService;
import com.example.lms.service.MailService;

import jakarta.servlet.http.HttpSession;


@Controller
@RequestMapping
public class LoginController {
	@Autowired LoginService loginService;
	@Autowired PasswordEncoder passwordEncoder; // 암호화 필드 받기 // com.example.lms.config.SecurityConfig
	@Autowired MailService mailService;
	// 로그인
	@GetMapping("/login")
	public String loginForm() {
		return "login";
	}
	
	// 관리자
	@PostMapping("/login")
    public String login(@ModelAttribute LoginDTO loginDtO, HttpSession session, Model model) { // loginDto에 자동으로 바인딩 // 로그인 성공시 저장 // 로그인 실패시 에러메세지 사용
        String role = loginDtO.getRole();		// 로그인 대상 누군지 확인
        String id = loginDtO.getId();			// 입력한 id, pw 
        String pw = loginDtO.getPw();

        SessionUserDTO sessionUser = null;		// 로그인 성공시 세션에 저장할 사용자 정보 담을 객체 SessionUserDTO , 실패 시 null 상태

        if ("admin".equals(role)) {				// 로그인한 대상이 관리자일 경우 AdminDTO 객체를 만들어 로그인
            AdminDTO adminDto = new AdminDTO();
            adminDto.setAdminId(id);			// 입력값으로부터 id, pw 담음
            adminDto.setPassword(pw);
            AdminDTO admin = loginService.loginAdmin(adminDto);		// DB에 id/pw를 넘겨서 관리자 정보가 있는지 확인
            if (admin != null && passwordEncoder.matches(pw, admin.getPassword())) {	// 로그인 성공 - DB에서 조회한 관리자 정보가 존재 && 입력한 비밀번호가 암호화된 비밀번호와 일치할 경우
            	sessionUser = new SessionUserDTO(); // // 세션에 저장할 정보만 담는 DTO
                sessionUser.setRole("admin");
                sessionUser.setAdminId(admin.getAdminId());
            }
        } else if ("teacher".equals(role)) {			// 강사도 동일
            TeacherDTO teacherDto = new TeacherDTO();	
            teacherDto.setTeacherId(id);
            teacherDto.setPassword(pw);
            TeacherDTO teacher = loginService.loginTeacher(teacherDto); // 서비스에서 해당 아이디/비밀번호로 선생님 조회
            if (teacher != null && passwordEncoder.matches(pw, teacher.getPassword())) {	// 비밀번호, 주소, 주민번호는 보안상 저장 x	
                sessionUser = new SessionUserDTO();
                sessionUser.setRole("teacher");
                sessionUser.setTeacherId(teacher.getTeacherId());
                sessionUser.setTeacherNo(teacher.getTeacherNo());
                // null 방지 처리
                Integer courseId = teacher.getCourseId();
                sessionUser.setCourseId(courseId != null ? courseId : 0); // 기본값 0 또는 -1 설정
                sessionUser.setName(teacher.getName());
                sessionUser.setEmail(teacher.getEmail());
                sessionUser.setRegDate(teacher.getRegDate());
            }
        } else if ("student".equals(role)) {
            StudentDTO studentDto = new StudentDTO();
            studentDto.setStudentId(id);
            studentDto.setPassword(pw);
            StudentDTO student = loginService.loginStudent(studentDto);
            if (student != null && passwordEncoder.matches(pw, student.getPassword())) {
                sessionUser = new SessionUserDTO();
                sessionUser.setRole("student");
                sessionUser.setStudentId(student.getStudentId());
                sessionUser.setStudentNo(student.getStudentNo());
                sessionUser.setCourseId(student.getCourseId());
                sessionUser.setName(student.getName());
                sessionUser.setEmail(student.getEmail());
                sessionUser.setRegDate(student.getRegDate());
            }
        }

        if (sessionUser == null) {			// 로그인 성공하지 못하면 sessionUser는 null
            model.addAttribute("error", "아이디 또는 비밀번호가 일치하지 않습니다.");
            return "login";
        }

        session.setAttribute("loginUser", sessionUser);		// 로그인 성공시 메인페이지로 리다이렉트
        return "redirect:/main";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/main";
    }

    // 아이디 찾기
    @GetMapping("/findId")
    public String findId() {
    	
    	return "/findId";
    }
    
    @PostMapping("/findId")
    @ResponseBody
    public String findId(@RequestParam String name,
                         @RequestParam String email,
                         @RequestParam String role) {	// "student" or "teacher"
        String userId = null;
        
        // 역할에 따라 다른 서비스 메서드 호출
        if ("student".equals(role)) {
        	userId = loginService.findStudentId(name, email);
        } else if ("teacher".equals(role)) {
        	userId = loginService.findTeacherId(name, email);
        }
        
        if (userId != null) {
        	// 아이디가 존재할 경우 해당 이메일로 전송
        	mailService.sendIdMail(email, name, userId);
            return "SEND_SUCCESS";
        } else {
            return "NOT_FOUND";	// 아이디가 존재하지 않을 경우
        }
    }
    
    // 비밀번호 찾기
    @GetMapping("/findPw")
    public String findPw() {
    	
    	return "/findPw";
    }
    
    @PostMapping("/findPw")
    @ResponseBody
    public String findPw(@RequestParam String name,
				    	 @RequestParam String userId,
                         @RequestParam String email,
                         @RequestParam String role) { // role 추가: "student" 또는 "teacher")
        
        String pw = null;

        if ("student".equals(role)) {
            pw = loginService.findStudentPw(name, userId, email);
        } else if ("teacher".equals(role)) {
            pw = loginService.findTeacherPw(name, userId, email);
        }

        if (pw != null) {
            String tempCode = mailService.createTempPassword(10); // 임시코드 생성

            if ("student".equals(role)) {
                loginService.updateStudentTempCode(userId, tempCode);
            } else if ("teacher".equals(role)) {
                loginService.updateTeacherTempCode(userId, tempCode);
            }

            mailService.sendTempPasswordMail(email, name, tempCode); // 메일 전송
            return tempCode;
        } else {
            return "NOT_FOUND";
        }
    }

    // 비밀번호 변경 화면 폼
    @GetMapping("/changePw")
    public String changePw(@RequestParam String studentId,
            @RequestParam String role,
            @RequestParam String tempCode,
            Model model) {
    	
				model.addAttribute("studentId", studentId);
				model.addAttribute("role", role);
				model.addAttribute("tempCode", tempCode);
				return "/changePw";
    }
    
    @PostMapping("/changePw")
    public String changePw(@RequestParam String pw,
            @RequestParam String studentId,
            @RequestParam String role,
            @RequestParam String tempCode,
            Model model) {

		boolean success = false;
		
		if ("student".equals(role)) {
			success = loginService.updateStudentPwByTempCode(studentId, tempCode, pw);
		} else if ("teacher".equals(role)) {
			success = loginService.updateTeacherPwByTempCode(studentId, tempCode, pw);
		}
		System.out.println("비번 변경 시도 → studentId: " + studentId + ", tempCode: " + tempCode + ", newPw: " + pw);
		if (success) {
			return "redirect:/login";
		} else {
			model.addAttribute("error", "비밀번호 변경 실패");
			model.addAttribute("studentId", studentId);
			model.addAttribute("role", role);
			model.addAttribute("tempCode", tempCode);
		return "changePw";
		}
	}
    
    // 임시코드 유효성 검사
    @PostMapping("/checkTempCode")
    @ResponseBody
    public String checkTempCode(@RequestParam String userId,
                                @RequestParam String role,
                                @RequestParam String tempCode) {
        boolean valid = false;

        if ("student".equals(role)) {
            valid = loginService.countStudentTempCode(userId, tempCode);
        } else if ("teacher".equals(role)) {
            valid = loginService.countTeacherTempCode(userId, tempCode);
        }

        return valid ? "VALID" : "INVALID";
    }
}
    
