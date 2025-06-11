package com.example.lms.service;

import java.util.List;

import com.example.lms.dto.NoticeDTO;

public interface NoticeService {
	
	// 푸터용 최신 공지사항 n개 조회
	List<NoticeDTO> selectLatestNotices(int count);
}
