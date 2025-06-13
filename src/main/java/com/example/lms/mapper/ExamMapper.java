package com.example.lms.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.lms.dto.ExamAnswerDTO;
import com.example.lms.dto.ExamDTO;
import com.example.lms.dto.ExamOptionDTO;
import com.example.lms.dto.ExamQuestionDTO;
import com.example.lms.dto.ExamSubmissionDTO;

@Mapper
public interface ExamMapper {
	// 성적 리스트 조회
	List<ExamSubmissionDTO> selectScoreList(Map<String, Object> params);
	// 페이징
	int getScoreCnt(int courseId, int examId, String filter);
	
	// 시험 리스트 조회
	List<ExamDTO> selectExamList(Map<String, Object> params);
	int getExamCnt(int courseId);
	// 시험 리스트 등록
	int insertExam(ExamDTO examDto);
	// 시험 리스트 수정
	int updateExam(ExamDTO examDto);
	// 시험 리스트 삭제
	int deleteExam(int examId);
	// 시험 제출 등록
	int insertSubmission(ExamSubmissionDTO dto);
	//개별 응답 저장 저장
	int insertAnswer(ExamAnswerDTO dto);
	//전체 등답 일괄 저장
	int insertAnswers(List<ExamAnswerDTO> answers);
	//자동 채점
	int calculateScore(int submissionId);
	// 점수 반영 
	int updateScore(@Param("submissionId") int submissionId, @Param("score") int score);
	

	List<ExamQuestionDTO> getQuestionsByExamId(int examId);
   
	List<ExamOptionDTO> getOptionsByQuestionId(int qeustionId);
}
