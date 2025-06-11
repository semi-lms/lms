package com.example.lms.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.lms.dto.AttendanceDTO;

@Mapper
public interface AttendanceMapper {
	List<AttendanceDTO> getTodayAttendance();

	List<AttendanceDTO> selectAttendanceListByStudentId(int studentId);
	
	int getAttendanceCount();

	int getActualAttendance(Map<String, Object> param);

	int getAttendanceTotalCount(Map<String, Object> param);

	int getStudentCount();
}
