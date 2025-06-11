package com.example.lms.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.lms.dto.SessionUserDTO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/mypage")
public class MypageController {

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
	@GetMapping("/info")
	public String showInfo(HttpSession session, Model model) {
		SessionUserDTO loginUser = (SessionUserDTO) session.getAttribute("loginUser");
		if(loginUser == null) {
			return "redirect:/login";
		}
		
		model.addAttribute("loginUser", loginUser);
		return "ajax/mypageInfo";
	}
}
