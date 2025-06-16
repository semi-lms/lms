package com.example.lms.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lms.dto.FileDTO;
import com.example.lms.mapper.FileMapper;
import com.example.lms.service.FileService;

@Service
public class FileServiceImpl implements FileService {

	@Autowired
	private FileMapper fileMapper;
	
	// 파일 첨부
	@Override
	public int insertFile(FileDTO fileDto) {
		return fileMapper.insertFile(fileDto);
	}

	// 게시글번호로 파일목록
	@Override
	public List<FileDTO> selectFileListByBoardNo(int fileBoardNo) {
		return fileMapper.selectFileListByBoardNo(fileBoardNo);
	}

	// 파일 상세보기(다운로드)
	@Override
	public int selectFileListById(int fileDto) {
		return fileMapper.selectFileListById(fileDto);
	}

	// 게시글 삭제시 파일도 같이 삭제
	@Override
	public int deleteFilesByBoardNo(int fileBoardNo) {
		return fileMapper.deleteFilesByBoardNo(fileBoardNo);
	}


	// 파일 이름으로 조회
	@Override
	public FileDTO selectFileBySaveName(String saveName) {
		return fileMapper.selectFileBySaveName(saveName);
	}

	// 특정 파일(save_name)으로 1개 삭제
	@Override
	public int deleteFileBySaveName(String savaName) {
		return fileMapper.deleteFileBySaveName(savaName);
	}

}
