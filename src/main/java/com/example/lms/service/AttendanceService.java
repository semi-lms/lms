package com.example.lms.service;

import java.sql.Date;
import java.util.List;

import com.example.lms.dto.AttendanceDTO;
import com.example.lms.dto.StudentDTO;

public interface AttendanceService {
    List<AttendanceDTO> getTodayAttendance();
    List<AttendanceDTO> getAttendanceListByStudentId(String studentId);
    int getAttendanceCount(int courseId);
    int getStudentCount(int courseId);
    int getAttendanceTotalCount(String startDate, String endDate, int studentCount, int courseId);
    int getActualAttendance(String startDate, String endDate, int courseId);
    List<AttendanceDTO> getAttendanceByClass(int courseId);
    List<StudentDTO> getStudentListByCourse(int courseId);
    List<Date> getHolidayList();
    
    // 출결 관리
    int isAttendance(AttendanceDTO attendanceDto);
    int updateAttendance(AttendanceDTO attendanceDto);
    int insertAttendance(AttendanceDTO attendanceDto);
}
