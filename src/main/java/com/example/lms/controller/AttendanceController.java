package com.example.lms.controller;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.lms.service.impl.AttendanceServiceImpl;

@Controller
public class AttendanceController {
	@Autowired AttendanceServiceImpl attendanceService;
	
	@GetMapping("/admin/attendanceStatistics")
	public String getAttendanceStatistics(Model model) {
		LocalDate now = LocalDate.now();
		String startDate = now.withDayOfMonth(1).toString();
	    String endDate = java.time.LocalDate.now().plusDays(1).toString(); // 오늘 + 1일
	    
        // 강의(course_id)는 1~5번, 각 반이름은 A~E반
        List<Integer> courseIds = Arrays.asList(1, 2, 3, 4, 5);
        List<String> classNames = Arrays.asList("A반", "B반", "C반", "D반", "E반");

        List<Integer> studentCounts = new ArrayList<>();
        List<Integer> attendanceTotalCounts = new ArrayList<>();
        List<Integer> actuals = new ArrayList<>();

        for (Integer courseId : courseIds) {
            int studentCount = attendanceService.getStudentCount(courseId);
            int attendanceTotalCount = attendanceService.getAttendanceTotalCount(startDate, endDate, studentCount, courseId);
            int actual = attendanceService.getActualAttendance(startDate, endDate, courseId);

            studentCounts.add(studentCount);
            attendanceTotalCounts.add(attendanceTotalCount);
            actuals.add(actual);
        }

        model.addAttribute("classNames", classNames);
        model.addAttribute("studentCounts", studentCounts);
        model.addAttribute("attendanceTotalCounts", attendanceTotalCounts);
        model.addAttribute("actuals", actuals);

	    return "/admin/attendanceStatistics";
	}

}
