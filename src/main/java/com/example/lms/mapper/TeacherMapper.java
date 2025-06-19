package com.example.lms.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

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
	
	// 강사 상세 조회
	TeacherDTO getTeacherByNo(int teacherNo);
	
	// 강사 정보 수정
	int updateTeacher(TeacherDTO teacherDto);
	
	// 강사 삭제
	int deleteTeachers(List<Integer> teacherNos);
	
	// 강사 등록 시 해당 강의에 이미 배정된 강사가 있는지 확인
	int isCourseAssigned(@Param("courseId") int courseId);
	
	// 강사 수정 시 본인을 제외하고 해당 강의에 배정된 강사가 있는지 확인
	boolean isCourseAssignedForUpdate(@Param("courseId") int courseId, 
										@Param("teacherNo") int teacherNo);
}
