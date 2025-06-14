package com.example.lms.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lms.dto.NoticeDTO;
import com.example.lms.mapper.NoticeMapper;
import com.example.lms.service.NoticeService;


@Service
public class NoticeServiceImpl implements NoticeService {
	
	@Autowired
	private NoticeMapper noticeMapper;
	
	// 메인페이지 공지사항 n개 미리보기
    @Override
    public List<NoticeDTO> selectLatestNotices(int count) {
        return noticeMapper.selectLatestNotices(count);
	}
    // 전체개수
	@Override
	public int totalCount(String searchOption, String keyword) {
		return noticeMapper.totalCount(searchOption, keyword);
	}
	// 리스트
	@Override
	public List<NoticeDTO> selectNoticeList(Map<String, Object> param) {
		return noticeMapper.selectNoticeList(param);
	}
	
	// 작성
	@Override
	public int insertNotice(NoticeDTO noticeDto) {
		return noticeMapper.insertNotice(noticeDto);
		
	}
	// 상세보기
	@Override
	public NoticeDTO selectNoticeOne(int noticeId) {
		return noticeMapper.selectNoticeOne(noticeId);
	}

	// 수정
	@Override
	public int updateNotice(NoticeDTO noticeDto) {
		return noticeMapper.updateNotice(noticeDto);
	}
	// 삭제
	@Override
	public int deleteNotice(int noticeDto) {
		return noticeMapper.deleteNotice(noticeDto);
	}
	

	

    
    
	
}
