package com.example.lms.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.lms.dto.ClassDTO;
import com.example.lms.dto.CourseDTO;
import com.example.lms.dto.TeacherDTO;

@Mapper
public interface CourseMapper {
	List<CourseDTO> selectCourseList(Map<String, Object> param);

	int insertCourse(CourseDTO courseDto);

	List<TeacherDTO> selectTeacherList();
	
	List<ClassDTO> selectClassList();

	ClassDTO selectClassByNo(int classNo);

	int getTotalCount(String searchCourseOption, String searchCourse);
}
