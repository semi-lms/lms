package com.example.lms.dto;

import java.time.LocalDate;

import lombok.Data;

@Data
public class CourseDTO {
	private int courseId;
	private String courseName;
	private String description;
	private int classNo;
	private LocalDate startDate;
	private LocalDate endDate;
	private int teacherNo;
	private String teacherName;
	private String applyPerson;
	private String classroom;
	private int maxPerson;
	
	private String courseActive; // 진행중, 예정, 완료 로 구분
}
