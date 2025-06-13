package com.example.lms.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lms.dto.AdminDTO;
import com.example.lms.mapper.AdminMapper;
import com.example.lms.service.AdminService;

@Service
public class AdminServiceImpl implements AdminService {
	@Autowired
	private AdminMapper adminMapper;
	
	@Override
	public AdminDTO getAdminById(String adminId) {
		return adminMapper.findById(adminId);
	}

}
