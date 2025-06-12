package com.example.lms.service;

import com.example.lms.dto.TeacherDTO;

public interface MypageService {
	
	// 강사 
	TeacherDTO getTeacherById(String teacherId);		// 개인정보 조회
	int isTeacherIdExist(String teacherId);				// 아이디 중복확인
	String getPasswordById(String teacherId);			// 비밀번호 조회
	void updateTeacherInfo(TeacherDTO teacherDto);		// 개인정보 수정
	
}
