package com.example.lms.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lms.dto.NoticeDTO;
import com.example.lms.mapper.NoticeMapper;
import com.example.lms.service.NoticeService;


@Service
public class NoticeServiceImpl implements NoticeService {
	
	@Autowired
	private NoticeMapper noticeMapper;
	
    @Override
    public List<NoticeDTO> selectLatestNotices(int count) {
        return noticeMapper.selectLatestNotices(count);
	}
	
}
