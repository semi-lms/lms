package com.example.lms.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.lms.dto.ExamSubmissionDTO;

@Mapper
public interface ExamMapper {
	List<ExamSubmissionDTO> selectScoreList(Map<String, Object> params);
}
