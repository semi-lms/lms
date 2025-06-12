package com.example.lms.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.lms.dto.StudentDTO;

@Mapper
public interface StudentMapper {
	// 강의별 학생 조회
	List<StudentDTO> selectStudentListByCourseId(Map<String, Object> params);
	// 페이징
	int getStudentCntByCourseId(int courseId);
	
	List<StudentDTO> selectAttendanceListByStudentId(int studentNo);
	
	// 개인정보 조회
	StudentDTO selectStudentById(String studentId);
}
