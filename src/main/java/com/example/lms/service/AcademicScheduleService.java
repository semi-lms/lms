package com.example.lms.service;

import java.util.List;

import com.example.lms.dto.AcademicScheduleDTO;

public interface AcademicScheduleService {
	// 관리자 달력 (개강, 종강, 휴강)
	List<AcademicScheduleDTO> getAcademicSchedules();
}
