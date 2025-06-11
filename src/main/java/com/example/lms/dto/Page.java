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
	
	public void setSearchOption(String searchCourseOption) {
	    this.searchCourseOption = searchCourseOption;
	}
	
	public Page(int rowPerPage, int currentPage, int totalCount, String searchCourse, String searchCourseOption) {
		this.rowPerPage = rowPerPage;
		this.currentPage = currentPage;
		this.totalCount = totalCount;
		this.searchCourse = searchCourse;
		this.searchCourseOption = searchCourseOption;
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