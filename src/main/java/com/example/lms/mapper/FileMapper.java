package com.example.lms.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.beans.factory.annotation.Autowired;

import com.example.lms.dto.FileDTO;

@Mapper
public interface FileMapper {
		
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
		
		// 파일이름으로 조회
		FileDTO selectFileBySaveName(String saveName);
		
}
