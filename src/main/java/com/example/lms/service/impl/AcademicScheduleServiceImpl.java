package com.example.lms.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lms.dto.AcademicScheduleDTO;
import com.example.lms.mapper.AcademicScheduleMapper;
import com.example.lms.service.AcademicScheduleService;

@Service
public class AcademicScheduleServiceImpl implements AcademicScheduleService {
	@Autowired AcademicScheduleMapper academicScheduleMapper;
	
	@Override
	public List<AcademicScheduleDTO> getAcademicSchedules() {
		return academicScheduleMapper.getAcademicSchedules();
	}

	@Override
	public boolean existsByDate(String date) {
		return academicScheduleMapper.countByDate(date) > 0;
	}
}
