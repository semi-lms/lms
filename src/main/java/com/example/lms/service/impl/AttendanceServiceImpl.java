package com.example.lms.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
	public List<AttendanceDTO> getAttendanceListByStudentId(String studentId) {
		return attendanceMapper.selectAttendanceListByStudentId(studentId);
	}
	
	public int getAttendanceCount() {

		return attendanceMapper.getAttendanceCount();
	}

	public int getAttendanceTotalCount(String startDate, String endDate, int studentCount) {
	    Map<String, Object> param = new HashMap<>();
	    param.put("startDate", startDate);
	    param.put("endDate", endDate);
	    param.put("studentCount", studentCount);
	    return attendanceMapper.getAttendanceTotalCount(param);
	}

	public int getActualAttendance(String startDate, String endDate) {
        Map<String, Object> param = new HashMap<>();
        param.put("startDate", startDate);
        param.put("endDate", endDate);
        return attendanceMapper.getActualAttendance(param);
	}
	public int getStudentCount() {
		
		return attendanceMapper.getStudentCount();
	}
	
}
