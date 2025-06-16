package com.example.lms.service;

import java.util.List;

import com.example.lms.dto.AcademicScheduleDTO;

public interface AcademicScheduleService {
	// 관리자 달력 (개강, 종강, 휴강)
	List<AcademicScheduleDTO> getAcademicSchedules();
	
	// 휴강 등록 시 날짜 중복 유효성 검사
	boolean existsByDate(String date);
}
