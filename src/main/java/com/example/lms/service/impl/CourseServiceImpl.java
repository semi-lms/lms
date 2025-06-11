package com.example.lms.service.impl;

import java.util.List;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lms.dto.CourseDTO;
import com.example.lms.mapper.CourseMapper;

@Service
public class CourseServiceImpl {

	@Autowired CourseMapper courseMapper;
	public List<CourseDTO> selectCourseList(CourseDTO courseDto) {
		
		return courseMapper.selectCourseList(courseDto);
	}


}
