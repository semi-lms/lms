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
	
    // 파일 저장
    @Override
    public int saveFile(FileDTO fileDto) {
       return fileMapper.insertFile(fileDto);
    }

    // 게시글 번호로 파일 목록 조회
    @Override
    public List<FileDTO> getFilesByBoardNo(int fileBoardNo) {
        return fileMapper.selectFilesByBoardNo(fileBoardNo);
    }

    // 파일 ID로 단건 조회
    @Override
    public FileDTO getFileById(int fileId) {
        return fileMapper.selectFileById(fileId);
    }

    // 게시글 번호로 전체 파일 삭제
    @Override
    public int deleteFilesByBoardNo(int fileBoardNo) {
       return fileMapper.deleteFilesByBoardNo(fileBoardNo);
    }

    // 파일 ID로 단일 삭제
    @Override
    public int deleteFileById(int fileId) {
      return  fileMapper.deleteFileById(fileId);
    }

}
