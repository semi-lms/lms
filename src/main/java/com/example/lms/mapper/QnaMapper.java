package com.example.lms.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.lms.dto.QnaDTO;

@Mapper
public interface QnaMapper {
	
	// 푸터용 최신 qna n개 조회
	List<QnaDTO> selectLatestQna(@Param("count") int count);
	
	// 전체개수
	int totalCount(@Param("searchOption") String searchOption,
					@Param("keyword") String keyword);
	
	// 리스트
	List<QnaDTO> selectQnaList(Map<String, Object> param);
	
	// 작성
	int insertQna(QnaDTO qndDto);
	
	// 상세보기
	QnaDTO selectQnaOne(int qnaId);
	
	// 수정
	int updateQna(QnaDTO qnaDto);
	
	// 삭제
	int deleteQna(int qnaId);
}
