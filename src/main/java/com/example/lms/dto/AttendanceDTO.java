package com.example.lms.dto;

import lombok.Data;

@Data
public class AttendanceDTO {
	private int attendanceNo;
	private int studentNo;
	private int courseId;
	private String date;
	private String status;
}
