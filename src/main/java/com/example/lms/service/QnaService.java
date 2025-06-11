package com.example.lms.service;

import java.util.List;

import com.example.lms.dto.QnaDTO;

public interface QnaService {

	// 푸터용 최신 qna n개 조회
	List<QnaDTO> selectLatestQna(int count);
}
