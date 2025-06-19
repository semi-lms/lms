package com.example.lms.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lms.dto.AttendanceFileDTO;
import com.example.lms.mapper.AttendanceFileMapper;
import com.example.lms.service.AttendanceFileService;

@Service
public class AttendanceFileServiceImpl implements AttendanceFileService{
	
	@Autowired
	private AttendanceFileMapper attendanceFileMapper;
	
	@Override
	public int saveProofFile(AttendanceFileDTO attendanceFileDto) {
		// 기존 파일이 있으면 먼저 삭제 후 등록
		attendanceFileMapper.deleteAttendanceFile(attendanceFileDto);
		attendanceFileMapper.insertAttendanceFile(attendanceFileDto);
		return 1;
	}
	
	@Override
	public List<AttendanceFileDTO> getAttendanceFileByCourse(int courseId) {
		return attendanceFileMapper.getAttendanceFileByCourse(courseId);
	}
}
