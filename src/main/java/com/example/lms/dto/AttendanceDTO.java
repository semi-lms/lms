package com.example.lms.dto;

import java.util.Date;

import lombok.Data;

@Data
public class AttendanceDTO {
	private int attendanceNo;
	private int studentNo;
	private int courseId;
	private Date date;
	private String status;
	private String courseName;  // 과정명
    private int total;          // 총 학생수
    private int attended;       // 출석 학생수 
}
