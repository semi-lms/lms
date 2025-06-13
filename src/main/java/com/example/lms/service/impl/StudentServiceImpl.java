package com.example.lms.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lms.dto.StudentDTO;
import com.example.lms.mapper.StudentMapper;
import com.example.lms.service.StudentService;

@Service
public class StudentServiceImpl implements StudentService {
	
	@Autowired
	private StudentMapper studentMapper;
	
	// 강의별 학생조회
	@Override
	public List<StudentDTO> getStudentListByCourseId(Map<String, Object> params) {
		return studentMapper.selectStudentListByCourseId(params);
	}
	// 페이징
	@Override
	public int getStudentCntByCourseId(int courseId) {
		return studentMapper.getStudentCntByCourseId(courseId);
	}
	
	@Override
	public List<StudentDTO> getStudentList() {

		return studentMapper.getStudentList();
	}
	
	@Override
	public int getTotalCount(String searchStudentOption, String searchStudent) {
		// TODO Auto-generated method stub
		return studentMapper.getTotalCount(searchStudentOption, searchStudent);
	}
	


	

	
	
}
