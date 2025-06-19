package com.example.lms.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.lms.dto.AdminDTO;
import com.example.lms.dto.StudentDTO;
import com.example.lms.dto.TeacherDTO;
import com.example.lms.mapper.LoginMapper;
import com.example.lms.service.LoginService;

@Service
public class LoginServiceImpl implements LoginService {
	
	@Autowired
	private LoginMapper loginMapper;
    @Autowired
    private PasswordEncoder passwordEncoder;

	// 로그인
	// 관리자
	@Override
	public AdminDTO loginAdmin(AdminDTO adminDto) {
		return loginMapper.loginAdmin(adminDto);
	}
	// 강사
	@Override
	public TeacherDTO loginTeacher(TeacherDTO teacherDto) {
		return loginMapper.loginTeacher(teacherDto);
	}
	// 학생
	@Override
	public StudentDTO loginStudent(StudentDTO studentDto) {
		return loginMapper.loginStudent(studentDto);
	}

    // 학생 아이디 찾기
    @Override
    public String findStudentId(String name, String email) {
        return loginMapper.findStudentId(name, email);
    }

    // 학생 비밀번호 찾기
    @Override
    public String findStudentPw(String name, String userId, String email) {
        return loginMapper.findStudentPw(name, userId, email);
    }

    // 학생 임시코드 발송
    @Override
    public boolean updateStudentTempCode(String studentId, String tempCode) {
        return loginMapper.updateStudentTempCode(studentId, tempCode) > 0;
    }

    // 학생 임시코드로 비밀번호 변경
    @Override
    public boolean updateStudentPwByTempCode(String studentId, String tempCode, String newPassword) {
        String encoded = passwordEncoder.encode(newPassword);
        return loginMapper.updateStudentPwByTempCode(studentId, tempCode, encoded) > 0;
    }

    // 강사 아이디 찾기
    @Override
    public String findTeacherId(String name, String email) {
        return loginMapper.findTeacherId(name, email);
    }

    // 강사 비밀번호 찾기
    @Override
    public String findTeacherPw(String name, String userId, String email) {
        return loginMapper.findTeacherPw(name, userId, email);
    }

    // 강사 임시코드 발송
    @Override
    public boolean updateTeacherTempCode(String teacherId, String tempCode) {
        return loginMapper.updateTeacherTempCode(teacherId, tempCode) > 0;
    }

    // 강사 임시코드로 비밀번호 변경
    @Override
    public boolean updateTeacherPwByTempCode(String teacherId, String tempCode, String newPassword) {
        String encoded = passwordEncoder.encode(newPassword);
        return loginMapper.updateTeacherPwByTempCode(teacherId, tempCode, encoded) > 0;
    }
    
    // 임시코드 유효성 검사
	@Override
	public boolean countStudentTempCode(String studentId, String tempCode) {
	    return loginMapper.countStudentTempCode(studentId, tempCode) > 0;
	}
	@Override
	public boolean countTeacherTempCode(String teacherId, String tempCode) {
	    return loginMapper.countTeacherTempCode(teacherId, tempCode) > 0;
	}

	
}
