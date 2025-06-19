package com.example.lms.service;

import com.example.lms.dto.AdminDTO;
import com.example.lms.dto.StudentDTO;
import com.example.lms.dto.TeacherDTO;

public interface LoginService {
	// 로그인
	AdminDTO loginAdmin(AdminDTO adminDto);
	TeacherDTO loginTeacher(TeacherDTO teacherDto);
	StudentDTO loginStudent(StudentDTO studentDto);
	
    // 학생 ID/PW 찾기
    String findStudentId(String name, String email);
    String findStudentPw(String name, String userId, String email);
    boolean updateStudentTempCode(String studentId, String tempCode); // 임시코드 저장
    boolean updateStudentPwByTempCode(String studentId, String tempCode, String newPassword); // 임시코드로 비번 변경

    // 강사 ID/PW 찾기
    String findTeacherId(String name, String email);
    String findTeacherPw(String name, String userId, String email);
    boolean updateTeacherTempCode(String teacherId, String tempCode);
    boolean updateTeacherPwByTempCode(String teacherId, String tempCode, String newPassword);
    
    // 임시코드 유효성 검사
    boolean countStudentTempCode(String studentId, String tempCode);
    boolean countTeacherTempCode(String teacherId, String tempCode);
}
