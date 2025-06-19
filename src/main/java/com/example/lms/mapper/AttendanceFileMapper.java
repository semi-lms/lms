package com.example.lms.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.lms.dto.AttendanceFileDTO;

@Mapper
public interface AttendanceFileMapper {
	void insertAttendanceFile(AttendanceFileDTO attendanceFileDto);
	void deleteAttendanceFile(AttendanceFileDTO attendanceFileDto);
	List<AttendanceFileDTO> getAttendanceFileByCourse(int courseId);
	AttendanceFileDTO getFileById(int fileId);
}
