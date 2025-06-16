package com.example.lms.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.lms.dto.CourseDTO;
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
	
	// 아이디 중복확인
	int isStudentIdExist(String studentId);
	
	// 비밀번호 확인 및 개인정보 수정
	String selectPasswordById(String studentId);
	
	int updateStudentInfo(StudentDTO studentDto);

	List<StudentDTO> getStudentList(Map<String, Object> map);
	
	int getTotalCount(String searchOption, String keyword);
	
	int insertStudentList(List<StudentDTO> studentList);
	
	List<CourseDTO> selectCourse();
	
	boolean checkId(@Param("studentId") String studentId);
	
	void insertCourseApply(String studentId, int courseId);

}
