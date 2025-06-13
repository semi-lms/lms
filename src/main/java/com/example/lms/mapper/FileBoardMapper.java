package com.example.lms.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.lms.dto.FileBoardDTO;

@Mapper
public interface FileBoardMapper {
	// 푸터용 최신 자료실 n개 조회
	List<FileBoardDTO> selectLatestFileBoard(@Param("count") int count);
	
	// 전체 개수
	int totalCount(@Param("searchOption") String searchOption,
					@Param("keyword") String keyword); 
		
	// 자료실 리스트
	List<FileBoardDTO> selectFileBoardList(Map<String, Object> param);
	
	// 작성
	int insertFileBoard(FileBoardDTO fileBoardDto);
	
	// 상세보기
	FileBoardDTO selectFileBoardOne(int fileBoardNo);
	
	// 수정
	int updateFileBoard(FileBoardDTO fileBoardDto);
	
	// 삭제
	int deleteFileBoard(int fileBoardNo);
}
