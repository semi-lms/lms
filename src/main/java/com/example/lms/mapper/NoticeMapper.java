package com.example.lms.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.lms.dto.NoticeDTO;

@Mapper
public interface NoticeMapper {
	
	// 푸터용 최신 공지사항 n개 조회
	List<NoticeDTO> selectLatestNotices(@Param("count") int count);
	
	// 공지사항 전체 개수
	int totalCount(@Param("searchOption") String searchOption,
					@Param("keyword") String keyword); 
		
	// 공지사항 리스트
	List<NoticeDTO> selectNoticeList(Map<String, Object> param);
	
	// 작성
	int insertNotice(NoticeDTO noticeDto);

}
