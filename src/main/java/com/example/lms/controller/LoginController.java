package com.example.lms.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
@RequestMapping("/")
public class LoginController {

   

   // 게시글 목록
    @GetMapping("/")
    public String boardList() {
 
        return "main";
    }


}
    
