package com.example.lms.dto;

import java.sql.Timestamp;
import java.time.LocalDateTime;

import lombok.Data;

@Data
public class QnaDTO {
	private int qnaId;					// qna_id
	private int studentNo;				// student_no
	private String title;				// title
	private String content;				// content
	private String answerStatus;			// answer_status 댓글달리면 답변완료
	private Timestamp createDate;			// create_date
	private Timestamp updateDate;			// update_date
	private String studentName;				// student_name
	private String isSecret;				// 'Y' 면 비밀글 'N' 이면 공개글
}