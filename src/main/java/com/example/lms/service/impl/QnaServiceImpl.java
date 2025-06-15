package com.example.lms.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lms.dto.QnaDTO;
import com.example.lms.mapper.QnaMapper;
import com.example.lms.service.QnaService;

@Service
public class QnaServiceImpl implements QnaService {
	@Autowired
	private QnaMapper qnaMapper;
	
	@Override
	public List<QnaDTO> selectLatestQna(int count) {
		
		return qnaMapper.selectLatestQna(count);
	}
	
	// 전체개수
	@Override
	public int totalCount(String searchOption, String keyword) {
		return qnaMapper.totalCount(searchOption, keyword);
	}
	
	// 리스트
	@Override
	public List<QnaDTO> selectQnaList(Map<String, Object> param) {
		return qnaMapper.selectQnaList(param);
	}

	// 작성
	@Override
	public int insertQna(QnaDTO qnaDto) {
		return qnaMapper.insertQna(qnaDto);
	}

	// 상세보기
	@Override
	public QnaDTO selectQnaOne(int qnaId) {
		return qnaMapper.selectQnaOne(qnaId);
	}

	// 수정
	@Override
	public int updateQna(QnaDTO qnaDto) {
		return qnaMapper.updateQna(qnaDto);
	}

	// 삭제
	@Override
	public int deleteQna(QnaDTO qnaDto) {
		return qnaMapper.deleteQna(qnaDto);
	}

}
