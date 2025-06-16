package com.example.lms.service;

import java.util.List;

import com.example.lms.dto.FileDTO;

public interface FileService {

	// 파일 등록
	int insertFile(FileDTO fileDto);
	
	// 게시글 번호로 파일 목록
	List<FileDTO> selectFileListByBoardNo(int fileBoardNo);
	
	// 파일 단건 조회
	int selectFileListById(int fileDto);
	
	// 게시글 삭제 시, 관련된 모든 파일 삭제
	int deleteFilesByBoardNo(int fileBoardNo);
	
	// 특정 파일(save_name)으로 1개 삭제
	int deleteFileBySaveName(String savaName);
	
	// 파일 이름으로 조회
	FileDTO selectFileBySaveName(String saveName);
	
}
