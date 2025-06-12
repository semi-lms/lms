package com.example.lms.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.lms.dto.AttendanceDTO;

@Mapper
public interface AttendanceMapper {
    List<AttendanceDTO> getTodayAttendance();

    List<AttendanceDTO> selectAttendanceListByStudentId(String studentId);

    int getAttendanceCount(@Param("courseId") int courseId);

    int getStudentCount(@Param("courseId") int courseId);

    int getAttendanceTotalCount(Map<String, Object> param);

    int getActualAttendance(Map<String, Object> param);

    List<AttendanceDTO> getAttendanceByClass(int courseId);
}
