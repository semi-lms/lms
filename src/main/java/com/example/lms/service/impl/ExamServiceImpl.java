package com.example.lms.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lms.dto.ExamDTO;
import com.example.lms.dto.ExamSubmissionDTO;
import com.example.lms.mapper.ExamMapper;
import com.example.lms.service.ExamService;

@Service
public class ExamServiceImpl implements ExamService{
	@Autowired
	private ExamMapper examMapper;
	
	@Override
	public List<ExamSubmissionDTO> getScoreList(Map<String, Object> params) {
		return examMapper.selectScoreList(params);
	}
	
	@Override
	public List<ExamDTO> getExamList(int courseId) {
		return examMapper.selectExamList(courseId);
	}
}
