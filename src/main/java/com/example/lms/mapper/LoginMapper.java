package com.example.lms.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

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
		
		
	    // 학생 아이디 찾기 (param으로 해야 변수 바인딩 #{} 정확히 매핑이 됨)
	    String findStudentId(@Param("name") String name,
	                         @Param("email") String email);

	    // 강사 아이디 찾기
	    String findTeacherId(@Param("name") String name,
	                         @Param("email") String email);

	    // 학생 비밀번호 조회 (비밀번호 찾기)
	    String findStudentPw(@Param("name") String name,
	                         @Param("userId") String userId,
	                         @Param("email") String email);

	    // 강사 비밀번호 조회 (비밀번호 찾기)
	    String findTeacherPw(@Param("name") String name,
	                         @Param("userId") String userId,
	                         @Param("email") String email);

	    // 학생 임시코드 저장
	    int updateStudentTempCode(@Param("studentId") String studentId,
	                               @Param("tempCode") String tempCode);

	    // 강사 임시코드 저장
	    int updateTeacherTempCode(@Param("teacherId") String teacherId,
	                               @Param("tempCode") String tempCode);

	    // 학생 임시코드로 비밀번호 변경
	    int updateStudentPwByTempCode(@Param("studentId") String studentId,
	                                   @Param("tempCode") String tempCode,
	                                   @Param("newPassword") String newPassword);

	    // 강사 임시코드로 비밀번호 변경
	    int updateTeacherPwByTempCode(@Param("teacherId") String teacherId,
	                                   @Param("tempCode") String tempCode,
	                                   @Param("newPassword") String newPassword);
	    
	    // 임시코드 유효성 검사
	    int countStudentTempCode(@Param("studentId") String studentId,
	    						 @Param("tempCode") String tempCode);
	    int countTeacherTempCode(@Param("teacherId") String teacherId,
	    						 @Param("tempCode") String tempCode);
	    
	}
