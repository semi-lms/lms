package com.example.lms.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class ExamAnswerDTO {
	private Integer answerId;
	private Integer submissionId;
	private int questionId;
	private int answerNo;   //학생이 제출한 답
	 private int correctNo; //정답
}
