package com.example.lms.service;

import java.util.List;
import java.util.Map;

import com.example.lms.dto.ExamAnswerDTO;
import com.example.lms.dto.ExamDTO;
import com.example.lms.dto.ExamQuestionDTO;
import com.example.lms.dto.ExamSubmissionDTO;

public interface ExamService {
	// 강사-시험성적리스트 조회
	List<ExamSubmissionDTO> getScoreList(Map<String, Object> params);
	
	// 시험 리스트 조회
	List<ExamDTO> getExamList(Map<String, Object> params);
	int getExamCnt(int courseId);
	// 시험 리스트 등록
	int addExam(ExamDTO examDto);
	// 시험 리스트 수정
	int modifyExam(ExamDTO examDto);
	// 시험 리스트 삭제
	int removeExam(int examId);

	int submitExam(ExamSubmissionDTO submission, List<ExamAnswerDTO> answers);

	boolean saveAnswerTemporary(ExamAnswerDTO answer);

	List<ExamQuestionDTO> getQuestionsByPage(int examId, int page);
	
	
}
