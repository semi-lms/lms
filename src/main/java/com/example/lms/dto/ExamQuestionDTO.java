package com.example.lms.dto;

import lombok.Data;

@Data
public class ExamQuestionDTO {
	private int questionId;
	private int examId;
	private int questionNo;
	private String questionTitle;
	private String questionText;
	private int correctNo;
}
