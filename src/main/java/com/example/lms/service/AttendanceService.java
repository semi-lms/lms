package com.example.lms.service;

import java.util.List;

import com.example.lms.dto.AttendanceDTO;
import com.example.lms.dto.StudentDTO;

public interface AttendanceService {
	List<AttendanceDTO> getTodayAttendance();
	List<AttendanceDTO> getAttendanceListByStudentId(int studentId); // 학생 본인의 출석 현황 리스트
}
