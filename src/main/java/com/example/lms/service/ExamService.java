package com.example.lms.service;

import java.util.List;
import java.util.Map;

import com.example.lms.dto.ExamDTO;
import com.example.lms.dto.ExamSubmissionDTO;

public interface ExamService {
	// 강사-시험성적리스트
	List<ExamSubmissionDTO> getScoreList(Map<String, Object> params);
	
	// 시험 리스트
	List<ExamDTO> getExamList(int courseId);
}
