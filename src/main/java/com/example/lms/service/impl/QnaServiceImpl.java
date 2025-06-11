package com.example.lms.service.impl;

import java.util.List;

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

}
