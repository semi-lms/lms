package com.example.lms.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.lms.dto.QnaDTO;

@Mapper
public interface QnaMapper {
	
	// 푸터용 최신 qna n개 조회
	List<QnaDTO> selectLatestQna(@Param("count") int count);
}
