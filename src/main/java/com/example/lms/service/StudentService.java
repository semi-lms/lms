package com.example.lms.service;

import java.util.List;

import com.example.lms.dto.StudentDTO;

public interface StudentService {
	List<StudentDTO> getStudentListByCourseId(int courseId);
	
}
