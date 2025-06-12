package com.example.lms.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lms.dto.ExamAnswerDTO;
import com.example.lms.dto.ExamDTO;
import com.example.lms.dto.ExamQuestionDTO;
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
	public int addExam(ExamDTO examDto) {
		return examMapper.insertExam(examDto);
	}

	@Override
	public int modifyExam(ExamDTO examDto) {
		return examMapper.updateExam(examDto);
	}

	@Override
	public int removeExam(int examId) {
		return examMapper.deleteExam(examId);
	}
	@Override
	public int submitExam(ExamSubmissionDTO submission, List<ExamAnswerDTO> answers) {
	    // 1. 시험 제출 등록
	    examMapper.insertSubmission(submission);  // examMapper 인스턴스로 호출해야 함

	    // 2. 제출 ID를 응답 DTO들에 세팅
	    int submissionId = submission.getSubmissionId();
	    for (ExamAnswerDTO answer : answers) {
	        answer.setSubmissionId(submissionId);
	    }

	    // 3. 응답 일괄 저장
	    examMapper.insertAnswers(answers);

	    // 4. 자동 채점
	    int score = examMapper.calculateScore(submissionId);

	    // 5. 점수 업데이트
	    examMapper.updateScore(submissionId, score);

	    return score; 
	}
	public List<ExamQuestionDTO> getQuestionsByPage(int examId, int page) {
	    int rowPerPage = 5; // 한 페이지에 5문제씩
	    int beginRow = (page - 1) * rowPerPage;
	    return examMapper.selectQuestionsByPage(examId, beginRow, rowPerPage);
	}
	@Override
    public boolean saveAnswerTemporary(ExamAnswerDTO answer) {
        //  세션이나 DB 임시 테이블에 저장 처리
        return examMapper.insertAnswer(answer) > 0;
    }
}
