package com.example.lms.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.lms.dto.StudentDTO;

@Mapper
public interface StudentMapper {
	List<StudentDTO> selectStudentListByCourseId(int courseId);
	
	List<StudentDTO> selectAttendanceListByStudentId(int studentNo);
	
	// 개인정보 조회
	StudentDTO selectStudentById(String studentId);
}
