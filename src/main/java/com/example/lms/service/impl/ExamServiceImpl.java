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
	public List<ExamDTO> getExamList(Map<String, Object> params) {
		return examMapper.selectExamList(params);
	}
	
	@Override
	public int getExamCnt(int courseId) {
		return examMapper.getExamCnt(courseId);
	}
	
	@Override
	public int modifyExam(ExamDTO examDto) {
		return examMapper.updateExam(examDto);
	}
	
	@Override
	public int removeExam(int examId) {
		return examMapper.deleteExam(examId);
	}
}
