package com.example.lms.service;

import java.util.List;

import com.example.lms.dto.CourseDTO;

public interface CourseService {

	public List<CourseDTO> selectCourseList(CourseDTO courseDto);
}
