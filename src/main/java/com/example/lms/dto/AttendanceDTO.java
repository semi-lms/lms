package com.example.lms.dto;

import lombok.Data;

@Data
public class AttendanceDTO {
	private int attendanceNo;
	private int studentNo;
	private int courseId;
	private String date;
	private String status;
	private String courseName;  // 과정명
    private int total;          // 총 인원
    private int attended;       // 출석 인원
}
