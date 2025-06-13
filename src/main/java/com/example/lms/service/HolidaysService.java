package com.example.lms.service;

import com.example.lms.dto.HolidaysDTO;

public interface HolidaysService {
	
	public int deleteHoliday(HolidaysDTO holidaysDTO);
	
	public int insertHoliday(HolidaysDTO holidaysDTO);

	void updateHolidayDate(HolidaysDTO holidaysDTO);  // 휴강 날짜 수정
}
