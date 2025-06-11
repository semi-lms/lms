package com.example.lms.dto;

import lombok.Data;

@Data
public class AttendanceDTO {
	public String attendanceNo;
	public String studentNo;
	public String courseId;
	public String date;
	public String status;
}
