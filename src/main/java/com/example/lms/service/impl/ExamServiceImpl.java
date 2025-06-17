package com.example.lms.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.lms.dto.ExamAnswerDTO;
import com.example.lms.dto.ExamDTO;
import com.example.lms.dto.ExamOptionDTO;
import com.example.lms.dto.ExamQuestionDTO;
import com.example.lms.dto.ExamSubmissionDTO;
import com.example.lms.dto.SessionUserDTO;
import com.example.lms.mapper.ExamMapper;
import com.example.lms.service.ExamService;

import jakarta.servlet.http.HttpSession;

@Service
public class ExamServiceImpl implements ExamService {
    @Autowired
    private ExamMapper examMapper;

    @Override
    public List<ExamSubmissionDTO> getScoreList(Map<String, Object> params) {
        return examMapper.selectScoreList(params);
    }

    @Override
    public int getScoreCnt(int courseId, int examId, String filter) {
        return examMapper.getScoreCnt(courseId, examId, filter);
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

    @Transactional
    @Override
    public int submitExam(ExamSubmissionDTO submission, List<ExamAnswerDTO> answers) {
        // 1. 시험 제출 등록
        examMapper.insertSubmission(submission);

        // 2. 제출 ID를 응답 DTO들에 세팅
        int submissionId = submission.getSubmissionId();
        for (ExamAnswerDTO answer : answers) {
            answer.setSubmissionId(submissionId);
        }

        // 3. 응답 일괄 저장
        examMapper.insertAnswers(answers);
        for (ExamAnswerDTO answer : answers) {
            System.out.println("문제 ID: " + answer.getQuestionId() + ", 선택한 답: " + answer.getAnswerNo());
        }

        // 4. 자동 채점
        int score = examMapper.calculateScore(submissionId);

        // 5. 점수 업데이트
        examMapper.updateScore(submissionId, score);
        System.out.println("===== 제출된 답안 목록 =====");

        return score;
    }

    // 전체 문제 + 보기 조회
    @Override
    public List<ExamQuestionDTO> getAllQuestions(int examId) {
        List<ExamQuestionDTO> allQuestions = examMapper.getQuestionsByExamId(examId);
        for (ExamQuestionDTO question : allQuestions) {
            List<ExamOptionDTO> options = examMapper.getOptionsByQuestionId(question.getQuestionId());
            question.setOptions(options);
        }
        return allQuestions;
    }

    // 학생별 시험 목록 조회
    @Override
    public List<ExamDTO> getExamListByStudent(int studentNo ,int startRow, int rowPerPage) {
    	Map<String, Object> param = new HashMap<>();

    	param.put("studentNo", studentNo);
    	param.put("startRow", startRow);
    	param.put("rowPerPage", rowPerPage);
    	List<ExamDTO> examList = examMapper.selectExamListByStudentNo(param);

    	// submissionId도 세팅
    	for (ExamDTO exam : examList) {
    		ExamSubmissionDTO submission = examMapper.selectSubmissionByExamIdAndStudentNo(exam.getExamId(), studentNo);
    		if (submission != null) {
    			exam.setSubmissionId(submission.getSubmissionId());
    		}
    	}

    	return examList;
    }


    @Override
    public int getExamListCountByStudent(int studentNo) {
        return examMapper.countExamListByStudentNo(studentNo);
    }

    // 시험 제목 가져오기
    @Override
    public String getExamTitle(int examId) {
        return examMapper.getExamTitle(examId);
    }

    // 문제 수 가져오기
    @Override
    public int getQuestionCnt(int examId) {
        return examMapper.getQuestionCnt(examId);
    }

    // 시험 문제만 가져오기
    @Override
    public List<ExamQuestionDTO> getQuestionList(int examId) {
        return examMapper.getQuestionsByExamId(examId);
    }

    // 특정 문제 가져오기
    @Override
    public ExamQuestionDTO getQuestionByQuestionId(int questionId) {
        return examMapper.getQuestionByQuestionId(questionId);
    }

    // 보기 목록 가져오기
    @Override
    public List<ExamOptionDTO> getOptionsByQuestionId(int questionId) {
        return examMapper.getOptionsByQuestionId(questionId);
    }

    // 문제 수정
    @Override
    public int updateQuestion(int questionId, String questionTitle, String questionText, int correctNo) {
        return examMapper.updateQuestion(questionId, questionTitle, questionText, correctNo);
    }

    // 보기 수정
    @Override
    public int updateOption(int questionId, int optionNo, String optionText) {
        return examMapper.updateOption(questionId, optionNo, optionText);
    }

    // 시험 제출 정보 (examId, studentNo로)
    @Override
    public ExamSubmissionDTO getSubmissionByExamAndStudent(int examId, int studentNo) {
        return examMapper.selectSubmissionByExamIdAndStudentNo(examId, studentNo);
    }

    // 시험 제출 정보 (submissionId로)
    @Override
    public ExamSubmissionDTO getSubmissionById(int submissionId) {
        return examMapper.selectSubmissionById(submissionId);
    }

    // 제출 답안 조회
    @Override
    public List<ExamAnswerDTO> getAnswersBySubmissionId(int submissionId) {
        return examMapper.selectAnswersBySubmissionId(submissionId);
    }

	@Override
	public List<ExamAnswerDTO> getExamAnswersWithCorrect(int submissionId) {
		  return examMapper.selectExamAnswersWithCorrect(submissionId);
	}
}
