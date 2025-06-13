package com.example.lms.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lms.dto.FileBoardDTO;
import com.example.lms.mapper.FileBoardMapper;
import com.example.lms.service.FileBoardService;

@Service
public class FileBoardServiceImpl implements FileBoardService {

	@Autowired
	private FileBoardMapper fileBoardMapper;
	
	@Override
	public List<FileBoardDTO> selectLatestFileBoard(int count) {
		return fileBoardMapper.selectLatestFileBoard(count);
	}

	@Override
	public int totalCount(String searchOption, String keyword) {
		return fileBoardMapper.totalCount(searchOption, keyword);
	}

	@Override
	public List<FileBoardDTO> selectFileBoardList(Map<String, Object> param) {
		return fileBoardMapper.selectFileBoardList(param);
	}

	@Override
	public int insertFileBoard(FileBoardDTO fileBoardDto) {
		return fileBoardMapper.insertFileBoard(fileBoardDto);
	}

	@Override
	public FileBoardDTO selectFileBoardOne(int fileBoardNo) {
		return fileBoardMapper.selectFileBoardOne(fileBoardNo);
	}

	@Override
	public int updateFileBoard(FileBoardDTO fileBoardDto) {
		return fileBoardMapper.updateFileBoard(fileBoardDto);
	}

	@Override
	public int deleteFileBoard(int fileBoardNo) {
		return fileBoardMapper.deleteFileBoard(fileBoardNo);
	}

}
