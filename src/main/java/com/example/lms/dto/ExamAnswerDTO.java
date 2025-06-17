package com.example.lms.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class ExamAnswerDTO {
	private Integer answerId;
	private Integer submissionId;
	private int questionId;
	private int answerNo;
}
