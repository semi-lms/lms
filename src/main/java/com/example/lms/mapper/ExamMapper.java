package com.example.lms.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.lms.dto.ExamDTO;
import com.example.lms.dto.ExamSubmissionDTO;

@Mapper
public interface ExamMapper {
	// 성적 리스트
	List<ExamSubmissionDTO> selectScoreList(Map<String, Object> params);
	// 시험 리스트
	List<ExamDTO> selectExamList(int courseId);
}
