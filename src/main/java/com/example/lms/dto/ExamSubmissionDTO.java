package com.example.lms.dto;

import java.util.List;

import lombok.Data;

@Data
public class ExamSubmissionDTO {
	private int submissionId;
	private int examId;
	private int studentNo;
	private String submitDate;
	private Integer score;
	private String name;		// 학생 이름
	private List<ExamAnswerDTO> answers;

}
