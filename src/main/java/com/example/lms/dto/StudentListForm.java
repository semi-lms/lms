package com.example.lms.dto;

import java.util.List;

public class StudentListForm {
	private List<StudentDTO> studentList;

    public List<StudentDTO> getStudentList() { return studentList; }
    public void setStudentList(List<StudentDTO> studentList) { this.studentList = studentList; }
}
