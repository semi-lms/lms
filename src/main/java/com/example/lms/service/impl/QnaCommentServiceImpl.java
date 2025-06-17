package com.example.lms.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.lms.dto.QnaCommentDTO;
import com.example.lms.mapper.QnaCommentMapper;
import com.example.lms.service.QnaCommentService;

@Service
public class QnaCommentServiceImpl implements QnaCommentService {
	@Autowired
	private QnaCommentMapper qnaCommentMapper;

	@Override
	public List<QnaCommentDTO> selectQnaCommentList(Map<String, Object> param) {
		return qnaCommentMapper.selectQnaCommentList(param);
	}

	@Override
	public int insertQnaComment(QnaCommentDTO qndCommentDto) {
		return qnaCommentMapper.insertQnaComment(qndCommentDto);
	}

	@Override
	public int updateQnaComment(QnaCommentDTO qnaCommentDto) {
		return qnaCommentMapper.updateQnaComment(qnaCommentDto);
	}

	@Override
	@Transactional
	public int deleteQnaComment(int commentId) {
	    
		// 1. 대댓글 먼저 삭제
	    qnaCommentMapper.deleteRepliesByParentId(commentId);

	    // 2. 부모 댓글 삭제
	    return  qnaCommentMapper.deleteQnaComment(commentId);
	}
	
	// 댓글 1개조회
	@Override
	public QnaCommentDTO selectQnaCommentById(int commentId) {
		return qnaCommentMapper.selectQnaCommentById(commentId);
	}

	@Override
	public int deleteRepliesByParentId(int commentId) {
		return qnaCommentMapper.deleteRepliesByParentId(commentId);
	}

	// 해당 QnA에 달린 모든 댓글 삭제 (부모+대댓글 포함)
	@Override
	@Transactional
	public int deleteCommentsByQnaId(int qnaId) {
		qnaCommentMapper.deleteChildCommentsByQnaId(qnaId);  // 먼저 대댓글 삭제
		return qnaCommentMapper.deleteParentCommentsByQnaId(qnaId);
	}

	// QnA 글에 달린 모든 대댓글 삭제
	@Override
	public int deleteChildCommentsByQnaId(int qnaId) {
		return qnaCommentMapper.deleteChildCommentsByQnaId(qnaId);
	}

	// QnA 글에 달린 모든 부모 댓글 삭제
	@Override
	public int deleteParentCommentsByQnaId(int qnaId) {
		return qnaCommentMapper.deleteParentCommentsByQnaId(qnaId);
	}


}
