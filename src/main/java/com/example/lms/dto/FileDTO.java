package com.example.lms.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class FileDTO {
	private int fileId;					// file_id
	private int fileBoardNo;			// file_board_no
	private String adminId;				// admin_id
	private String fileName;			// file_name
	private String filePath;			// file_path
	private LocalDateTime uploadDate;	// upload_date Spring Boot는 기본적으로 LocalDateTime을 ISO-8601 형식 ("2025-06-11T08:30:00")으로 직렬화/역직렬화 함.
}
