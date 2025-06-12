package com.example.lms.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.lms.dto.ExamAnswerDTO;
import com.example.lms.service.ExamService;

@RestController
@RequestMapping("/exam/api")
public class ExamApiController {

    @Autowired
    private ExamService examService;

    // 임시 저장 예시 (DB 또는 세션에 저장 가능)
    @PostMapping("/saveAnswer")
    public Map<String, Object> saveAnswer(@RequestBody ExamAnswerDTO answer) {
        boolean success = examService.saveAnswerTemporary(answer);
        return Map.of("success", success);
    }
}
