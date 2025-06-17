package com.example.lms.service;

import java.util.List;

import com.example.lms.dto.TeacherDTO;

public interface TeacherService {
	List<TeacherDTO> getTeacherList(TeacherDTO teacherDto);
}
