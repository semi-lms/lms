package com.example.lms.dto;

import lombok.Data;

@Data
public class CourseDTO {
	public int courseId;
	public String courseName;
	public String description;
	public int classNo;
	public String startDate;
	public String endDate;
	public int teacherNo;
	public String teacherName;
	public String applyPerson;
	public String classroom;
}
