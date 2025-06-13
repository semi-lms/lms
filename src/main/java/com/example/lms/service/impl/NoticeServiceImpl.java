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

	@Override
	public int totalCount(String searchOption, String keyword) {
		return noticeMapper.totalCount(searchOption, keyword);
	}

	@Override
	public List<NoticeDTO> selectNoticeList(Map<String, Object> param) {
		return noticeMapper.selectNoticeList(param);
	}
	
	// 작성
	@Override
	public int insertNotice(NoticeDTO noticeDto) {
		return noticeMapper.insertNotice(noticeDto);
		
	}


    
    
	
}
