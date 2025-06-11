package com.example.lms.dto;

import java.util.Date;

import lombok.Data;

@Data
public class StudentDTO {	
	private int studentNo;		// student_no
	private int courseId;		// course_id
	private int studentId;		// student_id
	private String password;	// password
	private String name;		// name
	private String sn;			// sn 주민번호
	private String address;		// adress
	private String email;		// email
	private String phone;		// phone
	private Date regDate;		// reg_date
	private String tempCode;	// temp_code
	private String gender;		// 성별
	private String birth;		// 생년월일
}
