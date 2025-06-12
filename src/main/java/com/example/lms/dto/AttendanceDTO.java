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
    private int total;          // 총 학생수
    private int attended;       // 출석 학생수 
    
    // 아래 DTO는 출결 상세 페이지를 위해 만듬
    private String classroom;        // 반 이름
    private String name;             // 학생 이름
    private int attendanceCount;     // 출석 카운트
}
