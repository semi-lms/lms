package com.example.lms.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lms.dto.StudentDTO;
import com.example.lms.mapper.StudentMapper;
import com.example.lms.service.StudentService;

@Service
public class StudentServiceImpl implements StudentService {
	
	@Autowired
	private StudentMapper studentMapper;
	
	@Override
	public List<StudentDTO> getStudentListByCourseId(int courseId) {
		return studentMapper.selectStudentListByCourseId(courseId);
	}

	

	
	
}
