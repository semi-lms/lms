package com.example.lms.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
	public int deleteQnaComment(int commentId) {
		return qnaCommentMapper.deleteQnaComment(commentId);
	}
	
	// 댓글 1개조회
	@Override
	public QnaCommentDTO selectQnaCommentById(int commentId) {
		return qnaCommentMapper.selectQnaCommentById(commentId);
	}

}
