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

}
