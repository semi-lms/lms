package com.example.lms.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.example.lms.dto.AdminDTO;

@Mapper
public interface AdminMapper {
    
	// 관리자 한 명 조회 (id 기준)
    AdminDTO findById(String adminId);

    // 관리자 추가
    int insertAdmin(AdminDTO admin);
    
}