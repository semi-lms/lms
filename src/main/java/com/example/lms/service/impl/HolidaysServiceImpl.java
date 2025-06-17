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
	public int deleteHoliday(HolidaysDTO holidaysDto) {
		return holidaysMapper.deleteHoliday(holidaysDto);
	}
	
	@Override
	public int insertHoliday(HolidaysDTO holidaysDto) {
		return holidaysMapper.insertHoliday(holidaysDto);
	}
	
	@Override
	@Transactional
	public void updateHolidayDate(HolidaysDTO holidaysDto) {
		holidaysMapper.deleteHoliday(holidaysDto);  // 기존 날짜 삭제
		holidaysMapper.insertHoliday(holidaysDto);  // 새 날짜로 재등록
	}
	
	@Override
	public String getDateType(String date) {
		String name = holidaysMapper.getHolidayNameByDate(date);
		
		if(name == null) {
			return "일정 없음";
		} else if(name.contains("휴강")) {
			return "휴강";
		} else {
			return "공휴일";
		}		
	}

	@Override
	public boolean isDuplicateDateForUpdate(HolidaysDTO holidaysDto) {
		return holidaysMapper.isDuplicateDateForUpdate(holidaysDto);
	}
}
