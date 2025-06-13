package com.example.lms.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
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

	@Override
	public AdminDTO loginAdmin(AdminDTO adminDto) {
		return loginMapper.loginAdmin(adminDto);
	}

	@Override
	public TeacherDTO loginTeacher(TeacherDTO teacherDto) {
		return loginMapper.loginTeacher(teacherDto);
	}

	@Override
	public StudentDTO loginStudent(StudentDTO studentDto) {
		return loginMapper.loginStudent(studentDto);
	}

	@Override
	public String findIdByNameEmail(String findIdByName, String findIdByEmail) {
		
		return loginMapper.findIdByNameEmail(findIdByName, findIdByEmail);
	}

	@Override
	public String findPwByNameIdEmail(String findPwByName, String findPwById, String findPwByEmail) {

		return loginMapper.findPwByNameIdEmail(findPwByName, findPwById, findPwByEmail);
	}

	@Override
	public void updatePassword(String findPwById, String tempPw) {
		loginMapper.updatePassword(findPwById, tempPw);
	}

	@Override
	public int updatePwByTempPw(String pw, String tempPw) {
		
		return loginMapper.updatePwByTempPw(pw, tempPw);
	}
}
