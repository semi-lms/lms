package com.example.lms.dto;

import java.time.LocalDate;

import lombok.Data;

@Data
public class ExamDTO {
	private int examId;
	private int courseId;
	private String title;
	private LocalDate examStartDate;
	private LocalDate examEndDate;
	private String submitStatus; //응시 여부
	private String status; // 진행도
	 private Integer score; 
	private Integer submissionId;
	 private int correctNo;
}
