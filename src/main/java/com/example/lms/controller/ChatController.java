package com.example.lms.controller;


import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ChatController {

	@GetMapping("/index.do")
	public String index(Model model) {
		return "index";
	}
	
	@GetMapping("/socket/chat.do")
	public String chat(Model model) {
		return "chat";
	}
}