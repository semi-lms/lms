package com.example.lms.service;

import com.example.lms.dto.LectureScheduleDTO;

import java.util.List;
import java.util.Map;

public interface LectureScheduleService {

    List<LectureScheduleDTO> getLectureSchedules(Map<String, Object> params);

    LectureScheduleDTO getLectureScheduleById(int dateNo);

    int addLectureSchedule(LectureScheduleDTO dto);

    int modifyLectureSchedule(LectureScheduleDTO dto);

    int removeLectureSchedule(int dateNo);
}
