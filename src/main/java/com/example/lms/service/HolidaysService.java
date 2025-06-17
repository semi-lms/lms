package com.example.lms.service;

import com.example.lms.dto.HolidaysDTO;

public interface HolidaysService {
	
	public int deleteHoliday(HolidaysDTO holidaysDto);
	
	public int insertHoliday(HolidaysDTO holidaysDto);

	void updateHolidayDate(HolidaysDTO holidaysDto);  // 휴강 날짜 수정

	String getDateType(String date);
	
	boolean isDuplicateDateForUpdate(HolidaysDTO holidaysDto);
}
