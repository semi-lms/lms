package com.example.lms.controller;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

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
	@Autowired PasswordEncoder passwordEncoder; // 암호화 필드 받기
	
	// 로그인
	@GetMapping("/login")
	public String loginForm() {
		return "login";
	}
	
	// 관리자
	@PostMapping("/login")
    public String login(@ModelAttribute LoginDTO loginDTO, HttpSession session, Model model) {
        String role = loginDTO.getRole();
        String id = loginDTO.getId();
        String pw = loginDTO.getPw();

        SessionUserDTO sessionUser = null;

        if ("admin".equals(role)) {
            AdminDTO adminDto = new AdminDTO();
            adminDto.setAdminId(id);
            adminDto.setPassword(pw);
            AdminDTO admin = loginService.loginAdmin(adminDto);
            if (admin != null && passwordEncoder.matches(pw, admin.getPassword())) {
            	sessionUser = new SessionUserDTO(); // 최소한의 역할만 유지
                sessionUser.setRole("admin");
                sessionUser.setAdminId(admin.getAdminId());
            }
        } else if ("teacher".equals(role)) {
            TeacherDTO teacherDto = new TeacherDTO();
            teacherDto.setTeacherId(id);
            teacherDto.setPassword(pw);
            TeacherDTO teacher = loginService.loginTeacher(teacherDto);
            if (teacher != null) {
                sessionUser = new SessionUserDTO();
                sessionUser.setRole("teacher");
                sessionUser.setTeacherId(teacher.getTeacherId());
                sessionUser.setCourseId(teacher.getCourseId());
                sessionUser.setName(teacher.getName());
                sessionUser.setEmail(teacher.getEmail());
                sessionUser.setRegDate(teacher.getRegDate());
            }
        } else if ("student".equals(role)) {
            StudentDTO studentDto = new StudentDTO();
            studentDto.setStudentId(id);
            studentDto.setPassword(pw);
            StudentDTO student = loginService.loginStudent(studentDto);
            if (student != null) {
                sessionUser = new SessionUserDTO();
                sessionUser.setRole("student");
                sessionUser.setStudentId(student.getStudentId());
                sessionUser.setCourseId(student.getCourseId());
                sessionUser.setName(student.getName());
                sessionUser.setEmail(student.getEmail());
                sessionUser.setRegDate(student.getRegDate());
            }
        }

        if (sessionUser == null) {
            model.addAttribute("error", "아이디 또는 비밀번호가 일치하지 않습니다.");
            return "login";
        }

        session.setAttribute("loginUser", sessionUser);
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


}
    
