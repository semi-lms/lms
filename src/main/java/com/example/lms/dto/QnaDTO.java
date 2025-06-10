package com.example.lms.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class QnaDTO {
	private int qnaId;					// qna_id
	private int studentNo;				// student_no
	private String title;				// title
	private String content;				// content
	private LocalDateTime createDate;	// create_date Spring Boot는 기본적으로 LocalDateTime을 ISO-8601 형식 ("2025-06-11T08:30:00")으로 직렬화/역직렬화 함.
	private LocalDateTime updateDate;	// update_date
}
