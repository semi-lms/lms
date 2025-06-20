package com.example.lms.service;

import java.util.List;
import java.util.Map;

import com.example.lms.dto.NoticeDTO;

public interface NoticeService {
	
	// 푸터용 최신 공지사항 n개 조회
	List<NoticeDTO> selectLatestNotices(int count);
	
	// 공지사항 전체 개수
	int totalCount(String searchOption, String keyword);
	
	// 공지사항 리스트
	List<NoticeDTO> selectNoticeList(Map<String, Object> param);
	
	// 작성
	int insertNotice(NoticeDTO noticeDto);
	
	// 상세보기
	NoticeDTO selectNoticeOne(int noticeId);
	
	// 수정
	int updateNotice(NoticeDTO noticeDto);
	
	// 삭제
	int deleteNotice(int noticeDto);
}
