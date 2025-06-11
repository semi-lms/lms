package com.example.lms.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.example.lms.dto.AdminDTO;
import com.example.lms.dto.StudentDTO;
import com.example.lms.dto.TeacherDTO;

@Mapper
public interface LoginMapper {
		AdminDTO loginAdmin(AdminDTO adminDto); 		// 관리자 로그인
		TeacherDTO loginTeacher(TeacherDTO teacherDto);	// 강사 로그인
		StudentDTO loginStudent(StudentDTO studentDto); // 학생 로그인
	}
