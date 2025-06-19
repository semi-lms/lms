package com.example.lms.dto;

import java.util.Date;

import lombok.Data;

@Data
public class TeacherDTO {
	private int teacherNo;		 // teacher_no
	private Integer courseId;	 // course_id	
	private String teacherId;	 // teacher_id
	private String password;	 // password
	private String name;		 // name
	private String sn;			 // sn 주민번호
	private String address;		 // adress
	private String email;		 // email
	private String phone;		 // phone
	private Date regDate;		 // reg_date
	private String tempCode;	 // temp_code
	private String courseName;	 // course_name 조인한테이블 결과 넣을 값
	private String oldTeacherId; // 변경 전 아이디
	private String newPw;		 // 새 비밀번호
	private String currentPassword;
}
