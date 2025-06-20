package com.example.lms.service;

import java.util.List;

import com.example.lms.dto.TeacherDTO;

public interface TeacherService {
	List<TeacherDTO> getTeacherList();
	
	int insertTeacher(TeacherDTO teacherDto);
	
	TeacherDTO getTeacherByNo(int teacherNo);
	
	int updateTeacher(TeacherDTO teacherDto);
	
	int deleteTeachers(List<Integer> teacherNos);
	
	boolean isCourseAssigned(int courseId);
	
	boolean isCourseAssignedForUpdate(int courseId, int teacherNo);
	
	List<TeacherDTO> getTeacherListByCourseStatus(String filter);
}
