package com.example.lms.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class QnaDTO {
	private int qnaId;					// qna_id
	private int studentNo;				// student_no
	private String title;				// title
	private String content;				// content
	private String createDate;			// create_date
	private String updateDate;			// update_date
	private String studentName;				// student_name
}
