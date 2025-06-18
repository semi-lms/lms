package com.example.lms.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.beans.factory.annotation.Autowired;

import com.example.lms.dto.FileDTO;

@Mapper
public interface FileMapper {
		
	 // 파일 등록
    int insertFile(FileDTO fileDto);

    // 게시글 번호로 파일 목록 조회
    List<FileDTO> selectFilesByBoardNo(int fileBoardNo);

    // 파일 ID로 단건 조회
    FileDTO selectFileById(int fileId);

    // 게시글 삭제 시, 해당 게시글의 모든 파일 삭제
    int deleteFilesByBoardNo(int fileBoardNo);

    // 파일 ID로 삭제 (Base64 방식에 적합)
    int deleteFileById(int fileId);
		
}
