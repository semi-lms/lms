package com.example.lms.dto;

import lombok.Data;
// 3개의 테이블이므로 각자 받는것보다 입력값을 하나로 받아서 role로 처리하는데 효과적
@Data
public class LoginDTO {
	private String id;
	private String pw;
	private String role;	// "admin", "teacher", "student"
}
