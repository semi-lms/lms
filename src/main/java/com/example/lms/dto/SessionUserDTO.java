package com.example.lms.dto;

import java.util.Date;

import lombok.Data;

@Data
public class SessionUserDTO {
	private String role;		// admin, teacher, student
	private int courseId;		// course_id
	private String name;		// name
	private String email;		// email
	private Date regDate;		// reg_date
}
