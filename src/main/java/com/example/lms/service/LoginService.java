package com.example.lms.service;

import com.example.lms.dto.AdminDTO;
import com.example.lms.dto.StudentDTO;
import com.example.lms.dto.TeacherDTO;

public interface LoginService {
	// 로그인
	AdminDTO loginAdmin(AdminDTO adminDto);
	TeacherDTO loginTeacher(TeacherDTO teacherDto);
	StudentDTO loginStudent(StudentDTO studentDto);
	String findIdByNameEmail(String findIdByName, String findIdByEmail);
	String findPwByNameIdEmail(String findPwByName, String findPwById, String findPwByEmail);
	void updatePassword(String findPwById, String tempPw);
	int updatePwByTempPw(String encodedPw, String tempPw);
	
}
