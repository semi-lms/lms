package com.example.lms.service;

import java.util.List;

import com.example.lms.dto.AttendanceDTO;

public interface AttendanceService {
	List<AttendanceDTO> getTodayAttendance();
}
