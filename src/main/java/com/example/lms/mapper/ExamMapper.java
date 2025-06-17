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

    // 시험 리스트 등록/수정/삭제
    int insertExam(ExamDTO examDto);
    int updateExam(ExamDTO examDto);
    int deleteExam(int examId);

    // 시험 제출 등록
    int insertSubmission(ExamSubmissionDTO dto);

    // 개별 응답 저장
    int insertAnswer(ExamAnswerDTO dto);

    // 전체 응답 일괄 저장
    int insertAnswers(List<ExamAnswerDTO> answers);
    //학생이 제출한답과 정답 가져오기
    List<ExamAnswerDTO> selectExamAnswersWithCorrect(int submissionId);
    // 자동 채점
    int calculateScore(int submissionId);
    
    // 점수 반영
    int updateScore(int submissionId, int score);

    // 응시 상태 확인
    Map<Integer, String> getSubmitStatusMap(int studentNo, List<Integer> examIdList);

    // 시험별 문제 출력 (10문제)
    List<ExamQuestionDTO> getQuestionsByExamId(int examId);

    // 문제별 보기 출력 (4개)
    List<ExamOptionDTO> getOptionsByQuestionId(int questionId);

    // 학생 시험 리스트
    List<ExamDTO> selectExamListByStudentNo(Map<String, Object> param);
    int countExamListByStudentNo(int studentNo);

    // 시험 제출 조회
    ExamSubmissionDTO selectSubmissionByExamIdAndStudentNo(int examId, int studentNo);

    // 제출 정보 조회
    ExamSubmissionDTO selectSubmissionById(int submissionId);

    // 답안 리스트 조회
    List<ExamAnswerDTO> selectAnswersBySubmissionId(int submissionId);

    // 시험 이름 가져오기
    String getExamTitle(int examId);

    // 시험 문제 수 가져오기
    int getQuestionCnt(int examId);

    // questionId로 문제 가져오기
    ExamQuestionDTO getQuestionByQuestionId(int questionId);

    // 문제 수정
    int updateQuestion(int questionId, String questionTitle, String questionText, int correctNo);

    // 보기 수정
    int updateOption(int questionId, int optionNo, String optionText);
    
    // 문제 등록
    int insertQuestion(ExamQuestionDTO examQuestionDto);
    // 보기 등록
    int insertOption(ExamOptionDTO examOptionDto);
    
    // 문제 삭제
    void deleteExamOptionByExamId(int examId);
    void deleteExamQuestionByExamId(int examId);
    void deleteExamByExamId(int examId);
}
