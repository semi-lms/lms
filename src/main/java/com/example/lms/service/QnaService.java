package com.example.lms.service;

import java.util.List;
import java.util.Map;

import com.example.lms.dto.QnaDTO;

public interface QnaService {

	// 푸터용 최신 qna n개 조회
	List<QnaDTO> selectLatestQna(int count);
	
	// 전체개수
	int totalCount(String searchOption, String keyword);
	
	// 리스트
	List<QnaDTO> selectQnaList(Map<String, Object> param);
	
	// 작성
	int insertQna(QnaDTO qnaDto);
	
	// 상세보기
	QnaDTO selectQnaOne(int qnaId);
	
	// 수정
	int updateQna(QnaDTO qnaDto);
	
	// 삭제
	int deleteQna(QnaDTO qnaDto);
	
	// 답변완료,미답변 표시
	int updateAnswerStatus(int qnaId, String status);
	
	
}
