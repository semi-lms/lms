package com.example.lms.dto;

import java.sql.Date;
import java.sql.Timestamp;

import lombok.Data;

@Data
public class QnaCommentDTO {
	private int commentId;	// comment_id
	private int qnaId;		// qna_id
	private String writerId;	// writer_id
	private String writerRole;	// writer_role
	private String content;		// content
	private Integer parentCommentId;	// 대댓글인 경우 부모 ID (무결성 때문에 셀프외래키)
	private Timestamp createDate;	// create_date
	private Timestamp updateDate;	// update_date
}
