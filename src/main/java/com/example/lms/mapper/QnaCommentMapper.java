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
	
	// 댓글 삭제
	int deleteQnaComment(QnaCommentDTO qnaCommentDto);
}
