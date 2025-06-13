package com.example.lms.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class NoticeDTO {
		private int noticeId;
		private String adminId;
		private String title;
		private String content;
		private String createDate;	// create_date 
		private String updateDate;	// update_date
}
