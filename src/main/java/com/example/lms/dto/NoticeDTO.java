package com.example.lms.dto;

import java.sql.Timestamp;
import java.time.LocalDateTime;

import lombok.Data;

@Data
public class NoticeDTO {
		private int noticeId;
		private String adminId;
		private String title;
		private String content;
		private Timestamp createDate;	// create_date 
		private Timestamp updateDate;	// update_date
}
