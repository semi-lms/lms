package com.example.lms.service.impl;

import java.util.ArrayList;
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
	public int submitExam(ExamSubmissionDTO submission, List<ExamAnswerDTO> answers ) {
		/*
		 * if (answers == null || answers.isEmpty()) { throw new
		 * IllegalArgumentException("답안이 제출되지 않았습니다."); }
		 */
		// 1. 시험 제출 등록
		examMapper.insertSubmission(submission);  // examMapper 인스턴스로 호출해야 함

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
	public List<ExamQuestionDTO> getQuestionsByPage(int examId, int page) {
		List<ExamQuestionDTO> allQuestions = examMapper.getQuestionsByExamId(examId);

		int pageSize = 1; // 페이지당 문제 수
		int fromIndex = (page - 1) * pageSize;
		int toIndex = Math.min(fromIndex + pageSize, allQuestions.size());

		if (fromIndex >= allQuestions.size()) {
			return new ArrayList<>();
		}

		List<ExamQuestionDTO> pagedQuestions = allQuestions.subList(fromIndex, toIndex);


		for (ExamQuestionDTO question : pagedQuestions) {
			List<ExamOptionDTO> options = examMapper.getOptionsByQuestionId(question.getQuestionId());
			question.setOptions(options);
		}


		return pagedQuestions;
	}

	@Override
	public boolean saveAnswerTemporary(ExamAnswerDTO answer) {
		//  세션이나 DB 임시 테이블에 저장 처리
		return examMapper.insertAnswer(answer) > 0;
	}
	//한 한생의 시험들 응시상태 확인
	@Override
	public Map<Integer, String> getSubmitStatusMap(int studentNo, List<Integer> examIdList) {
		return examMapper.getSubmitStatusMap(studentNo, examIdList);
	}
	//학생별 시험별 점수 확인
	@Override
	public List<ExamDTO> getExamListByStudent(int studentNo, int startRow, int rowPerPage) {
		Map<String, Object> param = new HashMap<>();
		param.put("studentNo", studentNo);
		param.put("startRow", startRow);
		param.put("rowPerPage", rowPerPage);
		return examMapper.selectExamListByStudentNo(param);
	}

	@Override
	public int getExamListCountByStudent(int studentNo) {
		return examMapper.countExamListByStudentNo(studentNo);
	}

}



