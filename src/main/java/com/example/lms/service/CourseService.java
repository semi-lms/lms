package com.example.lms.service;

import java.util.List;
import java.util.Map;

import com.example.lms.dto.CourseDTO;

public interface CourseService {

	public List<CourseDTO> selectCourseList(Map<String, Object> param);
	
	public int insertCourse(CourseDTO courseDto);
}
