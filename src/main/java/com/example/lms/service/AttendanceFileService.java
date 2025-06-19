package com.example.lms.service;

import java.util.List;

import com.example.lms.dto.AttendanceFileDTO;

public interface AttendanceFileService {
	int saveProofFile(AttendanceFileDTO attendanceFileDto);
	List<AttendanceFileDTO> getAttendanceFileByCourse(int courseId);
}
