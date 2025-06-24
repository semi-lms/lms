package com.example.lms.service;

import java.util.List;
import java.util.Map;

import com.example.lms.dto.ClassDTO;
import com.example.lms.dto.CourseDTO;
import com.example.lms.dto.TeacherDTO;

public interface CourseService {

	public List<CourseDTO> selectCourseList(Map<String, Object> param);
	
	public int insertCourse(CourseDTO courseDto);
	
	public List<TeacherDTO> selectTeacherList();
	
	public List<ClassDTO> selectClassList();
	
	public ClassDTO selectClassByNo(int classNo);
	
	public int getTotalCount(String searchOption, String keyword);
	
	// 강사별 강의리스트
	public List<CourseDTO> getCourseListByTeacherNo(Map<String, Object> params);
	//페이징
	public int getCountCourseListByTeacherNo(int teacherNo, String filter);

	List<CourseDTO> selectCourseListNotEnded(String now);

	CourseDTO getCourseOne(int courseId);

	int updateCourse(CourseDTO dto);

	int deleteCourses(List<Integer> courseIds);

	int getOverlapCount(int classNo, String startDate, String endDate);

	int getOverlapCount(int classNo, String startDate, String endDate, Integer courseId);
	
	List<CourseDTO> getCourseNameNotEnded();
	
	int updateTeacherCourseId(int teacherNo, Integer courseId);
	
	void unassignTeacherFromCourse(int teacherNo);
	
	void assignTeacherToCourse(int courseId, int teacherNo);
	
	List<ClassDTO> selectClassListForUpdate(Map<String, Object> param);

}
