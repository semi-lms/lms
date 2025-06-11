package com.example.lms.dto;

import lombok.Data;

@Data
public class ExamAnswerDTO {
	private int answerId;
	private int submissionId;
	private int questionId;
	private int answerNo;
}
