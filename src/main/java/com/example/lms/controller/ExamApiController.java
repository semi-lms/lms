package com.example.lms.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.lms.dto.ExamAnswerDTO;
import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/exam/api")
public class ExamApiController {


    @Autowired
    private HttpSession session;

    // 임시 저장 
    @PostMapping("/saveTemp")
    public Map<String, Object> saveAnswer(@RequestBody ExamAnswerDTO answer) {
        @SuppressWarnings("unchecked")
		Map<Integer, Integer> temp = (Map<Integer, Integer>) session.getAttribute("tempAnswers");
        if (temp == null) {
            temp = new HashMap<>();
        }
        temp.put(answer.getQuestionId(), answer.getAnswerNo());
        session.setAttribute("tempAnswers", temp);
        return Map.of("success", true);
    }
}
