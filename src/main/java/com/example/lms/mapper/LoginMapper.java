package com.example.lms.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.example.lms.dto.AdminDTO;
import com.example.lms.dto.StudentDTO;
import com.example.lms.dto.TeacherDTO;

@Mapper
public interface LoginMapper {
		
		// 관리자 로그인	
		AdminDTO loginAdmin(AdminDTO adminDto); 		
		
		// 강사 로그인
		TeacherDTO loginTeacher(TeacherDTO teacherDto);	
		
		// 학생 로그인
		StudentDTO loginStudent(StudentDTO studentDto); 
		
		// 
		String findIdByNameEmail(String findIdByName, String findIdByEmail);
		
		String findPwByNameIdEmail(String findPwByName, String findPwById, String findPwByEmail);
		
		void updatePassword(String findPwById, String tempPw);
		
		int updatePwByTempPw(String encodedPw, String tempPw);
		
	}
