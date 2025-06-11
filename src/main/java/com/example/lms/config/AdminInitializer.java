package com.example.lms.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import com.example.lms.dto.AdminDTO;
import com.example.lms.mapper.AdminMapper;

import jakarta.annotation.PostConstruct;

// 이 클래스를 spring이 자동으로 객체로 만들어주게 함
// 이 클래스는 "자동 실행용 초기 설정 클래스"
@Component
public class AdminInitializer {
	
	// 관리자 DB 작업을 하기 위한 매퍼 주입(자동 연결)
	@Autowired
	private AdminMapper adminMapper;
	
	// 비밀번호를 암호화해주는 도구 (예: BCrypt)
	@Autowired
	private PasswordEncoder passwordEncoder;

	// 서버가 시작되면 이 메서드가 자동으로 1번 실행됨
	@PostConstruct
	public void createInitialAdmin() {
		//관리자 기본 계정 정보 설정
		String adminId = "admin";		// 아이디
		String rawPw = "1234";			// 비밀번호 (암호화 전)
		String encPw = passwordEncoder.encode(rawPw); // 비밀번호 암호화
		
		try {
		// DB에 이미 관리자 아이디가 있는지 조회
		AdminDTO existingAdmin = adminMapper.findById(adminId);
		
		// 없으면 새로 생성
		if(existingAdmin == null) {
			AdminDTO admin = new AdminDTO();		// 관리자 객체 생성
			admin.setAdminId(adminId);		// 아이디 설정
			admin.setPassword(encPw);		// 암호화된 비밀번호 설정
			
			adminMapper.insertAdmin(admin);	// DB 에 관리자 추가
			
			System.out.println("최초 관리자 계정 생성완료(아이디:admin / 비밀번호: 1234");
			
		} else {
			// 이미 admin 계정이 있을 경우
			System.out.println("관리자 계정 이미 존재함.(아이디:admin)");
		}
		
	} catch(Exception e) {
		// 에러가 발생했을 경우 출력(예: DB 연결 오류 등)
		System.out.println("관리자 초기화 중 오류 발생: " + e.getMessage());
		e.printStackTrace();
	}
  }
}
