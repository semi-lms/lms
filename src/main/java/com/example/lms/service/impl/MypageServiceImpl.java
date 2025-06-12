package com.example.lms.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lms.dto.StudentDTO;
import com.example.lms.dto.TeacherDTO;
import com.example.lms.mapper.StudentMapper;
import com.example.lms.mapper.TeacherMapper;
import com.example.lms.service.MypageService;

@Service
public class MypageServiceImpl implements MypageService {
	@Autowired
	private TeacherMapper teacherMapper;
	@Autowired
	private StudentMapper studentMapper;
	
	// 강사
	// 개인정보 조회
	@Override
	public TeacherDTO getTeacherById(String teacherId) {
		return teacherMapper.selectTeacherById(teacherId);
	}
	
	// 아이디 중복확인
	@Override
	public int isTeacherIdExist(String teacherId) {
		return teacherMapper.isTeacherIdExist(teacherId);
	}
	
	// 비밀번호 확인
	@Override
	public String getTeacherPasswordById(String teacherId) {
		return teacherMapper.selectPasswordById(teacherId);
	}
	
	// 개인정보 수정
	@Override
	public void updateTeacherInfo(TeacherDTO teacherDto) {
		teacherMapper.updateTeacherInfo(teacherDto);
	}


	// 학생
	// 개인정보 조회
	@Override
	public StudentDTO getStudentById(String studentId) {
		return studentMapper.selectStudentById(studentId);
	}

	// 아이디 중복확인
	@Override
	public int isStudentIdExist(String studentId) {
		return studentMapper.isStudentIdExist(studentId);
	}

	// 비밀번호 확인
	@Override
	public String getStudentPasswordById(String studentId) {
		return studentMapper.selectPasswordById(studentId);
	}

	// 개인정보 수정
	@Override
	public void updateStudentInfo(StudentDTO studentDto) {
		studentMapper.updateStudentInfo(studentDto);
	}
}
