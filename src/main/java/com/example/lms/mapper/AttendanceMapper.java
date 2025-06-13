package com.example.lms.mapper;

import java.sql.Date;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.lms.dto.AttendanceDTO;
import com.example.lms.dto.StudentDTO;

@Mapper
public interface AttendanceMapper {
    List<AttendanceDTO> getTodayAttendance();

    List<AttendanceDTO> selectAttendanceListByStudentId(String studentId);

    int getAttendanceCount(@Param("courseId") int courseId);

    int getStudentCount(@Param("courseId") int courseId);

    int getAttendanceTotalCount(Map<String, Object> param);

    int getActualAttendance(Map<String, Object> param);

    List<AttendanceDTO> getAttendanceByClass(int courseId);

	List<StudentDTO> getStudentListByCourse(int courseId);

	List<Date> getHolidayList();
	
	// 출결 관리
	// 데이터 있는지 확인
	int isAttendance(AttendanceDTO attendanceDto);
	// 있으면 수정
	int updateAttendance(AttendanceDTO attendanceDto);
	// 없으면 입력
	int insertAttendance(AttendanceDTO attendanceDto);
}
