package com.example.lms.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.lms.dto.AcademicScheduleDTO;

@Mapper
public interface AcademicScheduleMapper {
	List<AcademicScheduleDTO> getAcademicSchedules();
	int countByDate(String date);
}
