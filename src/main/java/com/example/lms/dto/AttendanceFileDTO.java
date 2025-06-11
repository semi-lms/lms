package com.example.lms.dto;

import lombok.Data;

@Data
public class AttendanceFileDTO {
	private int fileId;
	private int teacherNo;
	private int attendanceNo;
	private String fileName;
	private String filePath;
	private String uploadDate;
}
