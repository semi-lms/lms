package com.example.lms.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.lms.dto.ExamDTO;
import com.example.lms.dto.ExamSubmissionDTO;

@Mapper
public interface ExamMapper {
	// 성적 리스트 조회
	List<ExamSubmissionDTO> selectScoreList(Map<String, Object> params);
	
	// 시험 리스트 조회
	List<ExamDTO> selectExamList(int courseId);
	// 시험 리스트 수정
	int updateExam(ExamDTO examDto);
	// 시험 리스트 삭제
	int deleteExam(int examId);
}
