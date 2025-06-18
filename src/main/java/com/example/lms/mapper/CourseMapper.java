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

	int getTotalCount(String searchOption, String keyword);
	
	// 강사별 강의리스트
	List<CourseDTO> selectCourseListByTeacherNo(Map<String, Object> params);
	// 페이징
	int getCountCourseListByTeacherNo(int teacherNo, String filter);

	List<CourseDTO> selectCourseListNotEnded(String now);

	CourseDTO getCourseOne(int courseId);

	int updateCourse(CourseDTO dto);

	int deleteCourses(List<Integer> courseIds);

	int getOverlapCount(int classNo, String startDate, String endDate);
}
