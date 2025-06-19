package com.example.lms.dto;

import java.util.Date;

import lombok.Data;

@Data
public class AttendanceFileDTO {
	private int fileId;
	private int teacherNo;
	private int attendanceNo;
	private String fileName;
	private String base64Data;
	private String uploadDate;
	
	// 조회 시에만 사용
    private int studentNo;
    private Date date;
}
