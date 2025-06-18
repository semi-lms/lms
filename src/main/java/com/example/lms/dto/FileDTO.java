package com.example.lms.dto;

import java.sql.Timestamp;
import java.time.LocalDateTime;

import lombok.Data;

@Data
public class FileDTO {
	private int fileId;					// file_id
	private int fileBoardNo;			// file_board_no
	private String adminId;				// admin_id
	private String fileName;			// file_name	원본 파일명
//	private String saveName;   // 실제 저장된 UUID 기반 이름 (ex. "a123f2e9.pdf")
//	private String filePath;			// file_path 서버저장 경로 + UUID 파일명
	private Timestamp uploadDate;		// upload_date
    private String base64Data;
    private String fileType;
    private long fileSize;
}