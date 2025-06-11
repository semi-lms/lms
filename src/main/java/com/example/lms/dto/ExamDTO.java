package com.example.lms.dto;

import lombok.Data;

@Data
public class ExamDTO {
	private int examId;
	private int courseId;
	private String title;
	private String examStartDate;
	private String examEndDate;
}
