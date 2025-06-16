package com.example.lms.service;

import java.util.List;
import java.util.Map;

import com.example.lms.dto.CourseDTO;
import com.example.lms.dto.StudentDTO;

public interface StudentService {
	// 강의별 학생조회
	List<StudentDTO> getStudentListByCourseId(Map<String, Object> params);
	// 페이징
	int getStudentCntByCourseId(int courseId);
	
	List<StudentDTO> getStudentList(Map<String, Object> map);
	
	int getTotalCount(String searchOption, String keyword);
	
	int insertStudentList(List<StudentDTO> studentList);
	
	List<CourseDTO> selectCourse();
	
	int checkId(List<StudentDTO> validList);
	
	void insertStudentAndCourseApply(List<StudentDTO> validList);
	
}
