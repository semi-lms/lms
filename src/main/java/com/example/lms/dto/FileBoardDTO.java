package com.example.lms.dto;

import lombok.Data;

@Data
public class FileBoardDTO {
	private int fileBoardNo;		// fil_board_no
	private String adminId;			// admin_id
	private String title;			// title
	private String content;			// content
	private String createDate;		// create_date
	private String updateDate;		// update_date
}
