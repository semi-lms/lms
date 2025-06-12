package com.example.lms.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lms.dto.TeacherDTO;
import com.example.lms.mapper.TeacherMapper;
import com.example.lms.service.MypageService;

@Service
public class MypageServiceImpl implements MypageService {
	@Autowired
	private TeacherMapper teacherMapper;
	
	@Override
	public TeacherDTO getTeacherById(String teacherId) {
		return teacherMapper.selectTeacherById(teacherId);
	}

	@Override
	public int isTeacherIdExist(String teacherId) {
		return teacherMapper.isTeacherIdExist(teacherId);
	}

	@Override
	public String getPasswordById(String teacherId) {
		return teacherMapper.selectPasswordById(teacherId);
	}


	@Override
	public void updateTeacherInfo(TeacherDTO teacherDto) {
		teacherMapper.updateTeacherInfo(teacherDto);
	}
}
