package com.example.lms.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class FileBoardDTO {
	private int fileBoardNo;		// fil_board_no
	private String adminId;			// admin_id
	private String title;			// title
	private String content;			// content
	private Timestamp createDate;		// create_date
	private Timestamp updateDate;		// update_date
}
