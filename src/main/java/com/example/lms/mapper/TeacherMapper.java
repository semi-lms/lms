package com.example.lms.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.lms.dto.TeacherDTO;

@Mapper
public interface TeacherMapper {
	// 개인정보 조회
	TeacherDTO selectTeacherById(String teacherId);
	
	// 아이디 중복확인
	int isTeacherIdExist(String teacherId);
	
	// 비밀번호 확인 및 개인정보 수정
	String selectPasswordById(String teacherId);
	int updateTeacherInfo(TeacherDTO teacherDto);
	
	// 강사 리스트
	List<TeacherDTO> getTeacherList(TeacherDTO teacherDto);
	
	// 강사 등록
	int insertTeacher(TeacherDTO teacherDto);
}
