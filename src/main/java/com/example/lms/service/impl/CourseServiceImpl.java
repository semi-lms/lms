package com.example.lms.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lms.dto.ClassDTO;
import com.example.lms.dto.CourseDTO;
import com.example.lms.dto.TeacherDTO;
import com.example.lms.mapper.CourseMapper;

@Service
public class CourseServiceImpl {

	@Autowired CourseMapper courseMapper;
	public List<CourseDTO> selectCourseList(Map<String, Object> param) {
		
		return courseMapper.selectCourseList(param);
	}
	public int insertCourse(CourseDTO courseDto) {
		
		return courseMapper.insertCourse(courseDto);
	}
	public List<TeacherDTO> selectTeacherList() {

		return courseMapper.selectTeacherList();
	}
	public List<ClassDTO> selectClassList() {

		return courseMapper.selectClassList();
	}


}
