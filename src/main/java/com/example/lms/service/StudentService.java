package com.example.lms.service;

import java.util.List;

import com.example.lms.dto.StudentDTO;

public interface StudentService {
	List<StudentDTO> getStudentListByCourseId(int courseId);
	
	// 개인정보 조회
	StudentDTO getStudentById(String studentId);
}
