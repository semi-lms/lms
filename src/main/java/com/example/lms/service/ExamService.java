package com.example.lms.service;

import java.util.List;
import java.util.Map;

import com.example.lms.dto.ExamAnswerDTO;
import com.example.lms.dto.ExamDTO;
import com.example.lms.dto.ExamSubmissionDTO;

public interface ExamService {
	// 강사-시험성적리스트 조회
	List<ExamSubmissionDTO> getScoreList(Map<String, Object> params);
	// 페이징
	int getScoreCnt(int courseId, int examId, String filter);
		
	// 시험 리스트 조회
	List<ExamDTO> getExamList(Map<String, Object> params);
	int getExamCnt(int courseId);
	// 시험 리스트 등록
	int addExam(ExamDTO examDto);
	// 시험 리스트 수정
	int modifyExam(ExamDTO examDto);
	// 시험 리스트 삭제
	int removeExam(int examId);
	// 시험 제출
	int submitExam(ExamSubmissionDTO submission, List<ExamAnswerDTO> answers);;
	// 페이지별 문제 출력	
	List<ExamDTO> getExamListByStudent(int studentNo, int startRow, int rowPerPage);
	
	int getExamListCountByStudent(int studentNo);
	
}
