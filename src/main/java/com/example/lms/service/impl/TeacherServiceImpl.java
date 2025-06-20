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
	public List<TeacherDTO> getTeacherList() {
		return teacherMapper.getTeacherList();
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

	@Override
	public boolean isCourseAssigned(int courseId) {
		int count = teacherMapper.isCourseAssigned(courseId);
	    return count > 0;
	}

	@Override
	public boolean isCourseAssignedForUpdate(int courseId, int teacherNo) {
		return teacherMapper.isCourseAssignedForUpdate(courseId, teacherNo);
	}

	@Override
	public List<TeacherDTO> getTeacherListByCourseStatus(String filter) {
		return teacherMapper.getTeacherListByCourseStatus(filter);
	}
}
