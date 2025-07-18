package com.example.lms.service.impl;

import java.io.File;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.lms.dto.FileBoardDTO;
import com.example.lms.dto.FileDTO;
import com.example.lms.mapper.FileBoardMapper;
import com.example.lms.mapper.FileMapper;
import com.example.lms.service.FileBoardService;

@Service
public class FileBoardServiceImpl implements FileBoardService {

	@Autowired
	private FileBoardMapper fileBoardMapper;
	@Autowired
	private FileMapper fileMapper;
	
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
	@Transactional
    public int deleteFileBoard(int fileBoardNo) {

		// 게시글에 첨부된 파일(Base64 데이터) DB에서 삭제
	    fileMapper.deleteFilesByBoardNo(fileBoardNo);	// 자식 먼저 삭제
		  // 2. 게시글 본문 삭제
	    return fileBoardMapper.deleteFileBoard(fileBoardNo);	//부모 삭제
	}

}
