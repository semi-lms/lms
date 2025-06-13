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

import jakarta.servlet.http.HttpSession;


@Controller
@RequestMapping
public class LoginController {
	@Autowired LoginService loginService;
	@Autowired PasswordEncoder passwordEncoder; // 암호화 필드 받기 // com.example.lms.config.SecurityConfig
	
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
            TeacherDTO teacher = loginService.loginTeacher(teacherDto);		// 서비스에서 해당 아이디/비밀번호로 선생님 조회
            if (teacher != null) {											// 비밀번호, 주소, 주민번호는 보안상 저장 x
                sessionUser = new SessionUserDTO();
                sessionUser.setRole("teacher");
                sessionUser.setTeacherId(teacher.getTeacherId());
                sessionUser.setTeacherNo(teacher.getTeacherNo());
                sessionUser.setCourseId(teacher.getCourseId());
                sessionUser.setName(teacher.getName());
                sessionUser.setEmail(teacher.getEmail());
                sessionUser.setRegDate(teacher.getRegDate());
            }
        } else if ("student".equals(role)) {				// 학생 동일
            StudentDTO studentDto = new StudentDTO();
            studentDto.setStudentId(id);
            studentDto.setPassword(pw);
            StudentDTO student = loginService.loginStudent(studentDto);
            if (student != null) {
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
   // 게시글 목록
    @GetMapping("/board")
    public String boardList() {
 
        return "main";
    }

    @GetMapping("/findId")
    public String findId() {
    	
    	return "/findId";
    }
    
    @PostMapping("/findId")
    @ResponseBody
    public String findId(@RequestParam String findIdByName
    					,@RequestParam String findIdByEmail) {
    	
    	String studentId = loginService.findIdByNameEmail(findIdByName, findIdByEmail);
        if (studentId != null) {
            return studentId; // 아이디 그대로 리턴 (JSON 아니라면 이렇게)
        } else {
            return "NOT_FOUND"; // 실패 시 구분
        }
    }
}
    
