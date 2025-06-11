package com.example.lms.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.lms.dto.CourseDTO;

@Mapper
public interface CourseMapper {
	List<CourseDTO> selectCourseList(CourseDTO courseDto);
}
