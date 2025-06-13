package com.example.lms.dto;

import lombok.Data;

@Data
public class Page {
	private int rowPerPage = 5;
    private int currentPage = 1;
	
	private int beginRow;
	private int totalCount;	
	private String keyword;					// 검색 공통
	private String searchOption;			// 검색 공통
	
	
	public Page(int rowPerPage, int currentPage, int totalCount,  String keyword, String searchOption) {
		this.rowPerPage = rowPerPage;
		this.currentPage = currentPage;
		this.totalCount = totalCount;
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