package com.example.lms.service;

import java.util.List;

import com.example.lms.dto.FileDTO;

public interface FileService {

	 // 파일 등록
    int saveFile(FileDTO fileDto);

    // 게시글 번호로 파일 목록 조회
    List<FileDTO> getFilesByBoardNo(int fileBoardNo);

    // 파일 ID로 단건 조회
    FileDTO getFileById(int fileId);

    // 게시글 번호로 전체 파일 삭제
    int deleteFilesByBoardNo(int fileBoardNo);

    // 파일 ID로 단일 삭제
    int deleteFileById(int fileId);
	
}
