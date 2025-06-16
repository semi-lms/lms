package com.example.lms.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.example.lms.dto.HolidaysDTO;

@Mapper
public interface HolidaysMapper {
	// 휴강 삭제
	int deleteHoliday(HolidaysDTO holidaysDTO);
	
	// 휴강 등록
	int insertHoliday(HolidaysDTO holidaysDTO);
	
	// 휴강 등록 시 날짜 유효성 검사
	String getHolidayNameByDate(String date);
	
	// 휴강 날짜 수정 시 날짜 유효성 검사
	boolean isDuplicateDateForUpdate(HolidaysDTO holidaysDTO);
}
