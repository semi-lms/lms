package com.example.lms.dto;

import lombok.Data;

@Data
public class ExamSubmissionDTO {
	private int submissionId;
	private int examId;
	private int studentNo;
	private String submitDate;
	private int score;
}
