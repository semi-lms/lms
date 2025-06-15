package com.example.lms.service;

import java.util.List;
import java.util.Map;

import com.example.lms.dto.QnaCommentDTO;

public interface QnaCommentService {

	// 댓글 리스트
	List<QnaCommentDTO> selectQnaCommentList(Map<String, Object> param);
	
	// 댓글 작성
	int insertQnaComment(QnaCommentDTO qndCommentDto);
	
	// 댓글 수정
	int updateQnaComment(QnaCommentDTO qnaCommentDto);
	
	// 댓글 삭제
	int deleteQnaComment(QnaCommentDTO qnaCommentDto);
}
