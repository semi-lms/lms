package com.example.lms.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lms.dto.AttendanceDTO;
import com.example.lms.mapper.AttendanceMapper;
import com.example.lms.service.AttendanceService;

@Service
public class AttendanceServiceImpl implements AttendanceService {
	@Autowired AttendanceMapper attendanceMapper;
	
	@Override
    public List<AttendanceDTO> getTodayAttendance() {
        return attendanceMapper.getTodayAttendance();
    }
	@Override
	public List<AttendanceDTO> getAttendanceListByStudentId(int studentId) {
		return attendanceMapper.selectAttendanceListByStudentId(studentId);
	}
	
}
