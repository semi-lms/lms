package com.example.lms.service;

import java.util.List;
import java.util.Map;

import com.example.lms.dto.ClassDTO;
import com.example.lms.dto.CourseDTO;
import com.example.lms.dto.TeacherDTO;

public interface CourseService {

	public List<CourseDTO> selectCourseList(Map<String, Object> param);
	
	public int insertCourse(CourseDTO courseDto);
	
	public List<TeacherDTO> selectTeacherList();
	
	public List<ClassDTO> selectClassList();
	
	public ClassDTO selectClassByNo(int classNo);
	
	public int getTotalCount(String searchCourseOption, String searchCourse);
	
	// 강사별 강의리스트
	public List<CourseDTO> getCourseListByTeacherNo(Map<String, Object> params);
	//페이징
	public int getCountCourseListByTeacherNo(int teacherNo, String filter);
}
