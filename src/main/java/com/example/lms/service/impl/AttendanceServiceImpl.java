package com.example.lms.service.impl;

import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lms.dto.AttendanceDTO;
import com.example.lms.dto.StudentDTO;
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
    public List<AttendanceDTO> getAttendanceListByStudentNo(int studentNo) {
        return attendanceMapper.selectAttendanceListByStudentNo(studentNo);
    }

    public int getAttendanceCount(int courseId) {
        return attendanceMapper.getAttendanceCount(courseId);
    }

    public int getStudentCount(int courseId) {
        return attendanceMapper.getStudentCount(courseId);
    }

    public int getAttendanceTotalCount(String startDate, String endDate, int studentCount, int courseId) {
        Map<String, Object> param = new HashMap<>();
        param.put("startDate", startDate);
        param.put("endDate", endDate);
        param.put("studentCount", studentCount);
        param.put("courseId", courseId);
        return attendanceMapper.getAttendanceTotalCount(param);
    }

    public int getActualAttendance(String startDate, String endDate, int courseId) {
        Map<String, Object> param = new HashMap<>();
        param.put("startDate", startDate);
        param.put("endDate", endDate);
        param.put("courseId", courseId);
        return attendanceMapper.getActualAttendance(param);
    }

    public List<AttendanceDTO> getAttendanceByClass(int courseId) {
    	
        return attendanceMapper.getAttendanceByClass(courseId);
    }

	public List<StudentDTO> getStudentListByCourse(int courseId) {

		return attendanceMapper.getStudentListByCourse(courseId);
	}

	public List<Date> getHolidayList() {

		return attendanceMapper.getHolidayList();
	}
	
	// 출결 관리
	public int isAttendance(AttendanceDTO attendanceDto) {
		return attendanceMapper.isAttendance(attendanceDto);
	}
	public int insertAttendance(AttendanceDTO attendanceDto) {
		return attendanceMapper.insertAttendance(attendanceDto);
	}
	public int updateAttendance(AttendanceDTO attendanceDto) {
		return attendanceMapper.updateAttendance(attendanceDto);
	}
	// 오늘날짜 한번에 업데이트(이미 오늘날짜 데이터 존재하면 예외)
	public void insertAttendanceAll(String status, int courseId) {
		attendanceMapper.insertAttendanceAll(status, courseId);
	}
}
