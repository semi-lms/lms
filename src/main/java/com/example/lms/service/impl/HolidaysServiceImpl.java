package com.example.lms.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.lms.dto.HolidaysDTO;
import com.example.lms.mapper.HolidaysMapper;
import com.example.lms.service.HolidaysService;

@Service
public class HolidaysServiceImpl implements HolidaysService {

	@Autowired 
	private HolidaysMapper holidaysMapper;
	
	@Override
	public int deleteHoliday(HolidaysDTO holidaysDTO) {
		return holidaysMapper.deleteHoliday(holidaysDTO);
	}
	
	@Override
	public int insertHoliday(HolidaysDTO holidaysDTO) {
		return holidaysMapper.insertHoliday(holidaysDTO);
	}
	
	@Override
	@Transactional
	public void updateHolidayDate(HolidaysDTO holidaysDTO) {
		holidaysMapper.deleteHoliday(holidaysDTO);  // 기존 날짜 삭제
		holidaysMapper.insertHoliday(holidaysDTO);  // 새 날짜로 재등록
	}
}
