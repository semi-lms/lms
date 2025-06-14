package com.example.lms.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.lms.dto.AttendanceDTO;
import com.example.lms.dto.CourseDTO;
import com.example.lms.dto.ExamDTO;
import com.example.lms.dto.ExamSubmissionDTO;
import com.example.lms.dto.StudentDTO;
import com.example.lms.service.AttendanceService;
import com.example.lms.service.CourseService;
import com.example.lms.service.ExamService;
import com.example.lms.service.StudentService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class TeacherController {
	@Autowired
	private StudentService studentService;
	@Autowired
	private ExamService examService;
	@Autowired
	private CourseService courseService;
	@Autowired
	private AttendanceService	attendanceService;
	
	// 강의 리스트
	@GetMapping("/courseListFromTeacher")
	public String courseListFromTeacher(@RequestParam(name = "teacherNo", required = false, defaultValue = "7") int teacherNo
										, @RequestParam(defaultValue = "1") int currentPage
										, @RequestParam(defaultValue = "10") int rowPerPage
										, @RequestParam(value = "filter", required = false, defaultValue = "전체") String filter
										, Model model) {
		// 페이징
		int totalCnt = courseService.getCountCourseListByTeacherNo(teacherNo, filter);
		int lastPage = totalCnt / rowPerPage;
		if(totalCnt % rowPerPage != 0) {
			lastPage += 1;
		};
		int startRow = (currentPage - 1) * rowPerPage;
		int startPage = ((currentPage-1) / rowPerPage) * rowPerPage + 1;
		int endPage = startPage + rowPerPage -1;
		if(endPage >lastPage) {
			endPage = lastPage;
		};
		
		// 조회
		Map<String, Object> courseMap = new HashMap<>();
	    courseMap.put("teacherNo", teacherNo);
	    courseMap.put("filter", filter);
	    courseMap.put("startRow", startRow);
	    courseMap.put("rowPerPage", rowPerPage);
		
	    List<CourseDTO> courses = courseService.getCourseListByTeacherNo(courseMap);
	    
	    model.addAttribute("courses", courses);
	    model.addAttribute("teacherNo", teacherNo);
	    model.addAttribute("filter", filter);
	    model.addAttribute("currentPage", currentPage);
	    model.addAttribute("startPage", startPage);
		model.addAttribute("lastPage", lastPage);
		model.addAttribute("endPage", endPage);
	    
		return "teacher/courseListFromTeacher";
	}
	
	// 학생 리스트
	@GetMapping("/studentListFromTeacher")
	public String studentListFromTeacher(@RequestParam(name = "courseId", required = false, defaultValue = "1") int courseId
										, @RequestParam(defaultValue = "1") int currentPage
										, @RequestParam(defaultValue = "10") int rowPerPage
										, Model model) {
		// 페이징
		int totalCnt = studentService.getStudentCntByCourseId(courseId);
		int lastPage = totalCnt / rowPerPage;
		if(totalCnt % rowPerPage != 0) {
			lastPage += 1;
		};
		int startRow = (currentPage - 1) * rowPerPage;
		int startPage = ((currentPage-1) / rowPerPage) * rowPerPage + 1;
		int endPage = startPage + rowPerPage -1;
		if(endPage >lastPage) {
			endPage = lastPage;
		};
		
		// 조회
		Map<String, Object> studentMap = new HashMap<>();
		studentMap.put("courseId", courseId);
		studentMap.put("startRow", startRow);
		studentMap.put("rowPerPage", rowPerPage);
		
		List<StudentDTO> students = studentService.getStudentListByCourseId(studentMap);
		
		model.addAttribute("students", students);
		model.addAttribute("startPage", startPage);
		model.addAttribute("lastPage", lastPage);
		model.addAttribute("endPage", endPage);
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("courseId", courseId);
		
		return "teacher/studentListFromTeacher";
	}
	
	// 성적 리스트
	@GetMapping("/scoreList")
	public String scoreList(@RequestParam(name = "courseId", required = false, defaultValue = "1") int courseId
							, @RequestParam(name = "examId", required = false, defaultValue = "1") int examId
							, @RequestParam(defaultValue = "1") int currentPage
							, @RequestParam(defaultValue = "10") int rowPerPage
							, @RequestParam(value = "filter", required = false, defaultValue = "전체") String filter
							, Model model) {
		// 페이징
		int totalCnt = examService.getScoreCnt(courseId, examId, filter);
		int lastPage = totalCnt / rowPerPage;
		if(totalCnt % rowPerPage != 0) {
			lastPage += 1;
		};
		int startRow = (currentPage - 1) * rowPerPage;
		int startPage = ((currentPage-1) / rowPerPage) * rowPerPage + 1;
		int endPage = startPage + rowPerPage -1;
		if(endPage >lastPage) {
			endPage = lastPage;
		};
		
		Map<String, Object> scoreMap = new HashMap<>();
		scoreMap.put("courseId", courseId);
		scoreMap.put("examId", examId);
		scoreMap.put("filter", filter);
		scoreMap.put("startRow", startRow);
		scoreMap.put("rowPerPage", rowPerPage);
		
		log.info("map" + scoreMap.toString());
		List<ExamSubmissionDTO> scores = examService.getScoreList(scoreMap);
		model.addAttribute("scores", scores);
		model.addAttribute("courseId", courseId);
		model.addAttribute("examId", examId);
		model.addAttribute("filter", filter);
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("startPage", startPage);
		model.addAttribute("lastPage", lastPage);
		model.addAttribute("endPage", endPage);
		
		return "teacher/scoreList";
	}
	
	// 시험 리스트
	@GetMapping("/examList")
	public String examList(@RequestParam(name = "courseId", required = false, defaultValue = "1") int courseId
							, @RequestParam(defaultValue = "1") int currentPage
							, @RequestParam(defaultValue = "10") int rowPerPage
							, Model model) {
		
		// 페이징
		int totalCnt = examService.getExamCnt(courseId);
		int lastPage = totalCnt / rowPerPage;
		if(totalCnt % rowPerPage != 0) {
			lastPage += 1;
		};
		int startRow = (currentPage - 1) * rowPerPage;
		int startPage = ((currentPage-1) / rowPerPage) * rowPerPage + 1;
		int endPage = startPage + rowPerPage -1;
		if(endPage >lastPage) {
			endPage = lastPage;
		};
		
		Map<String, Object> examMap = new HashMap<>();
		examMap.put("courseId", courseId);
		examMap.put("startRow", startRow);
		examMap.put("rowPerPage", rowPerPage);
		
		// 리스트 조회
		List<ExamDTO> exams = examService.getExamList(examMap);
		
		// 진행도 표시
		LocalDate today = LocalDate.now();
		
		for (ExamDTO exam : exams) {
		    if (today.isBefore(exam.getExamStartDate())) {
		        exam.setStatus("예정");
		    } else if (today.isAfter(exam.getExamEndDate())) {
		        exam.setStatus("완료");
		    } else {
		        exam.setStatus("진행중");
		    }
		}
		
		model.addAttribute("exams", exams);
		model.addAttribute("startPage", startPage);
		model.addAttribute("lastPage", lastPage);
		model.addAttribute("endPage", endPage);
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("courseId", courseId);
		
		return "teacher/examList";
		}
	
	@PostMapping("/updateExam")
	public String updateExam(@ModelAttribute ExamDTO examDto) {
		examService.modifyExam(examDto);
		return "redirect:/examList";
	}
	
	@PostMapping("/removeExam")
	public String removeExam(@RequestParam("examId") int examId) {
		examService.removeExam(examId);
		return "redirect:/examList";
	}
	
	@PostMapping("/insertExam")
	public String insertExam(@ModelAttribute ExamDTO examDto) {
		examService.addExam(examDto);
		return "redirect:/examList";
	}
	
	// 출결 관리
	@GetMapping("/attendanceList")
	public String attendanceByClass(
		@RequestParam(required = false, defaultValue = "1") int courseId, // 강의/반 ID, URL 파라미터로 받음
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
		
		// 8. JSP로 이동 (WEB-INF/views/teacher/attendanceList.jsp)
		return "/teacher/attendanceList";
	}
	
	@PostMapping("/manageAttendance")
	public String manageAttendance(@ModelAttribute AttendanceDTO attendanceDto) {
		// 데이터 값이 있으면 수정 없으면 입력
		int hasAttendance = attendanceService.isAttendance(attendanceDto);
		if(hasAttendance == 0) {
			attendanceService.insertAttendance(attendanceDto);
		} else {
			attendanceService.updateAttendance(attendanceDto);
		};
		
		return "redirect:/attendanceList";
	}
	
}
