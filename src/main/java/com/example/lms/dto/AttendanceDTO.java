package com.example.lms.dto;

import lombok.Data;

@Data
public class AttendanceDTO {
	public int attendanceNo;
	public int studentNo;
	public int courseId;
	public String date;
	public String status;
}
