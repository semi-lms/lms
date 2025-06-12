package com.example.lms.dto;

import lombok.Data;

@Data
public class CourseDTO {
	private int courseId;
	private String courseName;
	private String description;
	private int classNo;
	private String startDate;
	private String endDate;
	private int teacherNo;
	private String teacherName;
	private String applyPerson;
	private String classroom;
	
	private String courseActive; // 진행중, 예정, 완료 로 구분
}
