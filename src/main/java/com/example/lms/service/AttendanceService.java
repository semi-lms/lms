package com.example.lms.service;

import java.util.List;

import com.example.lms.dto.AttendanceDTO;

public interface AttendanceService {
    List<AttendanceDTO> getTodayAttendance();
    List<AttendanceDTO> getAttendanceListByStudentId(String studentId);
    int getAttendanceCount(int courseId);
    int getStudentCount(int courseId);
    int getAttendanceTotalCount(String startDate, String endDate, int studentCount, int courseId);
    int getActualAttendance(String startDate, String endDate, int courseId);
}
