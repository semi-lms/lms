package com.example.lms.dto;

import lombok.Data;

@Data
public class Page {
	private int rowPerPage = 5;
    private int currentPage = 1;
	
	private int beginRow;
	private int totalCount;	
	private String searchCourse;
	private String searchCourseOption;
	private String keyword;					// 공지사항, qna, 자료실 검색 공통
	private String searchOption;			// 공지사항, qna, 자료실 검색 공통
	
	public void setSearchOption(String searchCourseOption, String searchOption) {
	    this.searchCourseOption = searchCourseOption;
	    this.searchOption = searchOption;
	}
	
	public Page(int rowPerPage, int currentPage, int totalCount, String searchCourse, String searchCourseOption, String keyword, String searchOption) {
		this.rowPerPage = rowPerPage;
		this.currentPage = currentPage;
		this.totalCount = totalCount;
		this.searchCourse = searchCourse;
		this.searchCourseOption = searchCourseOption;
		this.keyword = keyword;
		this.searchOption = searchOption;
		this.beginRow = (currentPage - 1) * rowPerPage;
	}
	
	public int getLastPage() {
		int lastPage = this.totalCount / this.rowPerPage;
		if(this.totalCount % this.rowPerPage != 0) {
			lastPage += 1;
		}
		return lastPage;
	}

}