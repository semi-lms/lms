package com.example.lms.dto;

import lombok.Data;

@Data
public class ExamOptionDTO {
	private int questionId;
	private int optionId;
	private String optionText;
}
