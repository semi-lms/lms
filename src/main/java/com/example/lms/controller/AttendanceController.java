package com.example.lms.controller;

import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.lms.dto.AttendanceDTO;
import com.example.lms.dto.StudentDTO;
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
        model.addAttribute("courseIds", courseIds);

	    return "/admin/attendanceStatistics";
	}
	
	@GetMapping("/admin/attendanceByClass")
	public String attendanceByClass(
	        @RequestParam int courseId, // 강의/반 ID, URL 파라미터로 받음
	        @RequestParam(required = false) Integer year,
	        @RequestParam(required = false) Integer month,
	        Model model) {

	    // 1. 기준 날짜 셋팅: 년/월 파라미터 없으면 오늘 기준으로
	    LocalDate today = LocalDate.now();
	    int y = (year != null) ? year : today.getYear(); // 연도 선택값 또는 현재 연도
	    int m = (month != null) ? month : today.getMonthValue(); // 월 선택값 또는 현재 월
	    LocalDate firstDay = LocalDate.of(y, m, 1); // 해당 월 1일
	    LocalDate lastDay = firstDay.withDayOfMonth(firstDay.lengthOfMonth()); // 해당 월 마지막 일

	    // 2. dayList: 해당 월의 날짜 리스트 생성 (ex. 2025-06-01, ... 2025-06-30)
	    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd"); // 날짜 포맷 패턴 선언
	    List<String> dayList = new ArrayList<>();
	    for (LocalDate d = firstDay; !d.isAfter(lastDay); d = d.plusDays(1)) {
	        dayList.add(d.format(dtf)); // yyyy-MM-dd 형태의 문자열로 dayList에 저장
	    }

	    // 3. DB에서 출석 데이터(AttendanceDTO), 학생명단(StudentDTO) 조회
	    // (출석 정보: 학생 번호, 날짜, 출결상태 등 포함)
	    List<AttendanceDTO> list = attendanceService.getAttendanceByClass(courseId);

	    // --- 디버깅: 출석 DTO 목록 로그로 찍어서 실제 데이터 확인---
	    System.out.println("AttendanceDTO 리스트 디버깅 ---------");
	    for (AttendanceDTO dto : list) {
	        System.out.println("학생번호: " + dto.getStudentNo() + ", 날짜: " + dto.getDate() + ", 상태: " + dto.getStatus());
	    }
	    System.out.println("----------------------------------");
	    // ---

	    // 학생 리스트 조회 (반/강의에 소속된 학생 목록)
	    List<StudentDTO> studentList = attendanceService.getStudentListByCourse(courseId);

	    // 4. 출석 map 생성
	    //    key: 학생번호(int), value: Map<"yyyy-MM-dd", 출석상태>
	    //    (출석 기록이 있을 때만 값을 채우는 구조, 없는 날은 null)
	    Map<Integer, Map<String, String>> attendanceMap = new HashMap<>();
	    for (AttendanceDTO dto : list) {
	        int studentNo = dto.getStudentNo(); // 학생번호
	        java.util.Date date = dto.getDate(); // 출석일 (Date 객체)
	        // Date → yyyy-MM-dd 문자열 변환 (DB와 dayList key 일치 보장)
	        String dateKey = new java.text.SimpleDateFormat("yyyy-MM-dd").format(date);
	        String status = dto.getStatus(); // "출석", "지각", "결석" 등
	        // 학생번호별로 날짜와 출결상태 map에 추가
	        attendanceMap
	            .computeIfAbsent(studentNo, k -> new HashMap<>()) // 학생 map이 없으면 새로 생성
	            .put(dateKey, status);
	    }

	    // 5. 공휴일/휴강일 정보 리스트 (DB에서 받아옴, yyyy-MM-dd 문자열로 변환)
	    List<String> holidays = attendanceService.getHolidayList()
	        .stream()
	        .map(date -> date.toLocalDate().format(dtf))
	        .collect(Collectors.toList());

	    // --- 디버깅: attendanceMap, dayList 값 실제로 확인 (매칭 문제 디버깅용) ---
	    System.out.println("attendanceMap 최종 확인 =======");
	    for (var stu : attendanceMap.entrySet()) {
	        System.out.println("학생번호: " + stu.getKey());
	        for (var ent : stu.getValue().entrySet()) {
	            System.out.println("   날짜: " + ent.getKey() + ", 상태: " + ent.getValue());
	        }
	    }
	    System.out.println("dayList 확인 =======");
	    for (String day : dayList) {
	        System.out.println(day);
	    }
	    // ---

	    // 6. JSP로 전달할 데이터 Model에 저장
	    model.addAttribute("studentList", studentList);    // 학생명단
	    model.addAttribute("dayList", dayList);            // 날짜 리스트
	    model.addAttribute("attendanceMap", attendanceMap);// 학생별-날짜별 출결 상태
	    model.addAttribute("holidays", holidays);          // 휴일 리스트
	    model.addAttribute("year", y);                     // 연도
	    model.addAttribute("month", m);                    // 월
	    model.addAttribute("courseId", courseId);          // 반/강의ID

	    // 7. 이전/다음 달 버튼 클릭 시 사용할 값 계산해서 전달
	    int prevYear = (m == 1) ? y - 1 : y;
	    int prevMonth = (m == 1) ? 12 : m - 1;
	    int nextYear = (m == 12) ? y + 1 : y;
	    int nextMonth = (m == 12) ? 1 : m + 1;
	    model.addAttribute("prevYear", prevYear);
	    model.addAttribute("prevMonth", prevMonth);
	    model.addAttribute("nextYear", nextYear);
	    model.addAttribute("nextMonth", nextMonth);

	    // 8. JSP로 이동 (WEB-INF/views/admin/attendanceByClass.jsp)
	    return "/admin/attendanceByClass";
	}


}
