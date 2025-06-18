package com.example.lms.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lms.dto.TeacherDTO;
import com.example.lms.mapper.TeacherMapper;
import com.example.lms.service.TeacherService;

@Service
public class TeacherServiceImpl implements TeacherService {

	@Autowired private TeacherMapper teacherMapper;
	
	@Override
	public List<TeacherDTO> getTeacherList(TeacherDTO teacherDto) {
		return teacherMapper.getTeacherList(teacherDto);
	}
	
	@Override
	public int insertTeacher(TeacherDTO teacherDto) {
		return teacherMapper.insertTeacher(teacherDto);
	}

	@Override
	public TeacherDTO getTeacherByNo(int teacherNo) {
		return teacherMapper.getTeacherByNo(teacherNo);
	}

	@Override
	public int updateTeacher(TeacherDTO teacherDto) {
		return teacherMapper.updateTeacher(teacherDto);
	}

	@Override
	public int deleteTeachers(List<Integer> teacherNos) {
		return teacherMapper.deleteTeachers(teacherNos);
	}
}
