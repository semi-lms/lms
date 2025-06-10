package com.example.lms.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.lms.dto.LectureScheduleDTO;



@Mapper
public interface LectureScheduleMapper {

    List<LectureScheduleDTO> selectLectureScheduleList(Map<String, Object> params);

    LectureScheduleDTO selectLectureScheduleById(int dateNo);

    int insertLectureSchedule(LectureScheduleDTO dto);

    int updateLectureSchedule(LectureScheduleDTO dto);

    int deleteLectureSchedule(int dateNo);
}
