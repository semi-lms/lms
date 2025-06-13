package com.example.lms.dto;

import java.util.List;

import lombok.Data;

@Data
public class ExamQuestionDTO {
	private int questionId;
	private int examId;
	private int questionNo;
	private String questionTitle;
	private String questionText;
	private int correctNo;
	private List<ExamOptionDTO> options;  //option 4개 리스트로 받아올거양
}
