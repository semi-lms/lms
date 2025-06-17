package com.example.lms.service;

import java.util.List;
import java.util.Map;

import com.example.lms.dto.ExamAnswerDTO;
import com.example.lms.dto.ExamDTO;
import com.example.lms.dto.ExamOptionDTO;
import com.example.lms.dto.ExamQuestionDTO;
import com.example.lms.dto.ExamSubmissionDTO;

public interface ExamService {
    // 강사 - 시험 성적 리스트 조회
    List<ExamSubmissionDTO> getScoreList(Map<String, Object> params);

    // 성적 리스트 페이징
    int getScoreCnt(int courseId, int examId, String filter);

    // 시험 리스트 조회
    List<ExamDTO> getExamList(Map<String, Object> params);
    int getExamCnt(int courseId);

    // 시험 등록 / 수정 / 삭제
    int addExam(ExamDTO examDto);
    int modifyExam(ExamDTO examDto);
    int removeExam(int examId);

    // 시험 제출
    int submitExam(ExamSubmissionDTO submission, List<ExamAnswerDTO> answers);
    
    //학생이 제출한 답, 정답 불러오기
    List<ExamAnswerDTO> getExamAnswersWithCorrect(int submissionId);
    
    // 학생용 시험 리스트 (페이징)
    List<ExamDTO> getExamListByStudent(int studentNo, int startRow, int rowPerPage);
    int getExamListCountByStudent(int studentNo);

    // 시험 문제 리스트
    List<ExamQuestionDTO> getQuestionList(int examId);

    // 시험 제목 가져오기
    String getExamTitle(int examId);

    // 시험 문제 수 가져오기
    int getQuestionCnt(int examId);

    // 문제 ID로 문제 정보 가져오기
    ExamQuestionDTO getQuestionByQuestionId(int questionId);

    // 보기 리스트 가져오기
    List<ExamOptionDTO> getOptionsByQuestionId(int questionId);

    // 문제 수정
    int updateQuestion(int questionId, String questionTitle, String questionText, int correctNo);

    // 보기 수정
    int updateOption(int questionId, int optionNo, String optionText);

    // 시험 제출 조회 (examId, studentNo로)
    ExamSubmissionDTO getSubmissionByExamAndStudent(int examId, int studentNo);

    // 제출 ID로 제출 정보 조회
    ExamSubmissionDTO getSubmissionById(int submissionId);

    // 제출 ID로 답안 리스트 조회
    List<ExamAnswerDTO> getAnswersBySubmissionId(int submissionId);

	List<ExamQuestionDTO> getAllQuestions(int examId);
	
	// 문제 등록
	int insertQuestion(ExamQuestionDTO examQuestionDto);
	// 보기 등록
	int insertOption(ExamOptionDTO examOptionDto);
	
	// 문제, 보기 등록
	void insertQuestionAndOptions(ExamQuestionDTO question);
}
