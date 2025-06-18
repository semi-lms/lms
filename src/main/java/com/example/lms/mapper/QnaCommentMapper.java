package com.example.lms.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.beans.factory.annotation.Autowired;

import com.example.lms.dto.QnaCommentDTO;

@Mapper
public interface QnaCommentMapper {
	
	// 댓글 리스트
	List<QnaCommentDTO> selectQnaCommentList(Map<String, Object> param);
	
	// 댓글 작성
	int insertQnaComment(QnaCommentDTO qndCommentDto);
	
	// 댓글 수정
	int updateQnaComment(QnaCommentDTO qnaCommentDto);
	
	// 댓글 삭제 (QnA 글 하나에 달린 모든 댓글)
    int deleteCommentsByQnaId(int qnaId);
	
	// 특정댓글 삭제
	int deleteQnaComment(int qnaCommentDto);
	
	// 대댓글 삭제
	int deleteRepliesByParentId(int commentId);
	
	// 댓글 1개조회
	QnaCommentDTO selectQnaCommentById(int commentId);
	
	// qna 글에 달린 모든 대댓글 삭제
	int deleteChildCommentsByQnaId(int qnaId);
	
	//qna 글에 달린 모든 부모 댓글 삭제
	int deleteParentCommentsByQnaId(int qnaId);
	
	// 댓글이 달리면 수정 삭제 못하기
	int countComments(int qnaId);
	
}
