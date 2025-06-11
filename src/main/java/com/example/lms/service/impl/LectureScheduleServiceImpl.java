package com.example.lms.service.impl;

import com.example.lms.dto.LectureScheduleDTO;
import com.example.lms.service.LectureScheduleService;
import com.example.lms.mapper.LectureScheduleMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import java.util.List;
import java.util.Map;

@Service
public class LectureScheduleServiceImpl implements LectureScheduleService {

    @Autowired
    private LectureScheduleMapper lectureScheduleMapper;

    @Override
    public List<LectureScheduleDTO> getLectureSchedules(Map<String, Object> params) {
        return lectureScheduleMapper.selectLectureScheduleList(params);
    }

    @Override
    public LectureScheduleDTO getLectureScheduleById(int dateNo) {
        return lectureScheduleMapper.selectLectureScheduleById(dateNo);
    }

    @Override
    public int addLectureSchedule(LectureScheduleDTO LectureScheduleDto) {
        return lectureScheduleMapper.insertLectureSchedule(LectureScheduleDto);
    }

    @Override
    public int modifyLectureSchedule(LectureScheduleDTO LectureScheduleDto) {
        return lectureScheduleMapper.updateLectureSchedule(LectureScheduleDto);
    }

    @Override
    public int removeLectureSchedule(int dateNo) {
        return lectureScheduleMapper.deleteLectureSchedule(dateNo);
    }
    @Override
    public LectureScheduleDTO getScheduleByDateNo(int dateNo) {
        return lectureScheduleMapper.selectLectureScheduleById(dateNo);
    }
    
}
