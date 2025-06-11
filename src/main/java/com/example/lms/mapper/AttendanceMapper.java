package com.example.lms.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.lms.dto.AttendanceDTO;

@Mapper
public interface AttendanceMapper {
	List<AttendanceDTO> getTodayAttendance();
}
