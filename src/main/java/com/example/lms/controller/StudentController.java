package com.example.lms.controller;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.lms.dto.AttendanceDTO;
import com.example.lms.dto.CourseDTO;
import com.example.lms.dto.ExamAnswerDTO;
import com.example.lms.dto.ExamDTO;
import com.example.lms.dto.ExamQuestionDTO;
import com.example.lms.dto.ExamSubmissionDTO;
import com.example.lms.dto.Page;
import com.example.lms.dto.SessionUserDTO;
import com.example.lms.dto.StudentDTO;
import com.example.lms.dto.StudentListForm;
import com.example.lms.service.impl.AttendanceServiceImpl;
import com.example.lms.service.impl.ExamServiceImpl;
import com.example.lms.service.impl.QnaServiceImpl;
import com.example.lms.service.impl.StudentServiceImpl;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class StudentController {

	private final QnaServiceImpl qnaServiceImpl;

	@Autowired 
	private StudentServiceImpl studentService;
	@Autowired
	private AttendanceServiceImpl attendanceService;
	@Autowired
	private ExamServiceImpl examService;
	@Autowired
	private PasswordEncoder passwordEncoder;

	StudentController(QnaServiceImpl qnaServiceImpl) {
		this.qnaServiceImpl = qnaServiceImpl;
	}
	@InitBinder
	public void initBinder(WebDataBinder binder) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		sdf.setLenient(false);
		binder.registerCustomEditor(Date.class, new CustomDateEditor(sdf, true));
	}

	@GetMapping("/student/myAttendance")
	public String getMyAttendance(@RequestParam int studentNo,
			@RequestParam(required = false) Integer year,
			@RequestParam(required = false) Integer month,
			HttpSession session,
			Model model) {

		Calendar cal = Calendar.getInstance();
		int displayYear = (year != null) ? year : cal.get(Calendar.YEAR);
		int displayMonth = (month != null) ? month : cal.get(Calendar.MONTH) + 1;

		cal.set(displayYear, displayMonth - 1, 1);
		int firstDayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
		int startOffset = (firstDayOfWeek == Calendar.SUNDAY) ? 0 : firstDayOfWeek - 2;
		if (startOffset < 0) startOffset = 6;
		cal.add(Calendar.DATE, -startOffset);

		List<Map<String, Object>> weeks = new ArrayList<>();

		for (int w = 0; w < 6; w++) {
			List<Map<String, Object>> days = new ArrayList<>();
			boolean hasCurrentMonthDate = false;

			for (int d = 0; d < 7; d++) {
				Date date = cal.getTime();
				Calendar tmpCal = Calendar.getInstance();
				tmpCal.setTime(date);

				int y = tmpCal.get(Calendar.YEAR);
				int m = tmpCal.get(Calendar.MONTH) + 1;
				int day = tmpCal.get(Calendar.DAY_OF_MONTH);

				boolean isCurrentMonth = (m == displayMonth);
				if (isCurrentMonth) hasCurrentMonthDate = true;

				String dateStr = String.format("%04d-%02d-%02d", y, m, day);

				Map<String, Object> dayMap = new HashMap<>();
				dayMap.put("dateStr", dateStr);
				dayMap.put("day", day);
				dayMap.put("isCurrentMonth", isCurrentMonth);
				dayMap.put("dayOfWeek", d + 1);
				days.add(dayMap);

				cal.add(Calendar.DATE, 1);
			}

			if (hasCurrentMonthDate) {
				weeks.add(Map.of("days", days));
			}
		}

		// 출석 정보 조회 후 날짜별로 매핑
		List<AttendanceDTO> attendanceList = attendanceService.getAttendanceListByStudentNo(studentNo);
		Map<String, String> attendanceMap = new HashMap<>();

		for (AttendanceDTO dto : attendanceList) {
			if (dto.getDate() != null && dto.getStatus() != null) {
				String dateStr = new java.text.SimpleDateFormat("yyyy-MM-dd").format(dto.getDate());
				attendanceMap.put(dateStr, dto.getStatus());
			}
		}

		model.addAttribute("year", displayYear);
		model.addAttribute("month", displayMonth);
		model.addAttribute("weeks", weeks);
		model.addAttribute("attendanceMap", attendanceMap);

		return "student/myAttendance";
	}
	// 문제 페이지 보여주기
	@GetMapping("/student/takeExam")
	public String takeExam(@RequestParam int examId, @RequestParam int page, Model model, HttpSession session) {
		//문제 페이지 갯수 
		List<ExamQuestionDTO> questions = examService.getQuestionsByPage(examId, page); 
		@SuppressWarnings("unchecked")
		//정답 임시 저장 
		Map<Integer, Integer> temp = (Map<Integer, Integer>) session.getAttribute("tempAnswers"); 
		if (temp == null) temp = new HashMap<>();

		model.addAttribute("questions", questions);
		model.addAttribute("examId", examId);
		model.addAttribute("page", page);
		model.addAttribute("isLastPage", page == 10); //10페이지가 마지막 (고정)
		model.addAttribute("tempAnswers", temp); //정답 임시 저장 (페이지 넘어갔다가 다시 돌아와도 남아있음)
		return "student/takeExam"; 
	}
	@GetMapping("/student/examList")
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

		return "student/examList";
	}

	// 최종 제출 처리
	@PostMapping("/student/submitExam")
	public String submitExam(@ModelAttribute ExamSubmissionDTO submission, HttpSession session, Model model) {
		SessionUserDTO loginUser = (SessionUserDTO) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/login";
		}

		submission.setStudentNo(loginUser.getStudentNo());
		List<ExamAnswerDTO> answers = submission.getAnswers();
		int score = examService.submitExam(submission, answers);
		model.addAttribute("score", score);
		return "redirect:/examList";
	}


	// 학생 리스트 페이지
	@GetMapping("/admin/studentList")
	public String studentList(Model model
			,@RequestParam(defaultValue = "1") int currentPage   // 현재 페이지 번호
			,@RequestParam(defaultValue = "5") int rowPerPage     // 한 페이지에 보여줄 행 수
			,@RequestParam(value="searchOption", required=false, defaultValue="all") String searchOption // 검색 조건
			,@RequestParam(value="keyword", required=false, defaultValue="") String keyword) {           // 검색어
		// 전체 학생 수(검색 포함)
		int totalCount = studentService.getTotalCount(searchOption, keyword);
		Page page = new Page(rowPerPage, currentPage, totalCount, keyword, searchOption);

		int pageSize = 5; // 하단 페이지네이션에 보여줄 최대 페이지 수
		int startPage = ((currentPage - 1) / pageSize) * pageSize + 1; // 시작 페이지 번호
		int endPage = startPage + pageSize - 1;                        // 끝 페이지 번호
		if(endPage > page.getLastPage()) {
			endPage = page.getLastPage(); // 전체 페이지 넘어가지 않도록 보정
		}
		int startRow = (currentPage - 1) * rowPerPage; // DB 쿼리용 시작 row 번호

		// 검색, 페이징에 사용할 파라미터들을 Map에 넣기
		Map<String, Object> map = new HashMap<>();
		map.put("searchOption", searchOption); // 검색 옵션(이름/전체 등)
		map.put("keyword", keyword);           // 검색 키워드
		map.put("startRow", startRow);         // 페이징 시작 행 번호
		map.put("rowPerPage", rowPerPage);     // 한 페이지에 보여줄 행 개수

		// 학생 리스트 조회 (Map에 담은 조건으로 조회)
		List<StudentDTO> list = studentService.getStudentList(map);

		// 조회 결과와 페이징 정보, 검색 옵션 등을 뷰로 전달
		model.addAttribute("studentList", list);     // 학생 목록 데이터
		model.addAttribute("page", page);            // 페이징 객체
		model.addAttribute("searchOption", searchOption); // 검색 옵션 값
		model.addAttribute("keyword", keyword);           // 검색 키워드 값
		model.addAttribute("startPage", startPage);       // 페이지 네비 시작 번호
		model.addAttribute("endPage", endPage);           // 페이지 네비 끝 번호


		return "/admin/studentList";
	}

	// 학생 등록 페이지 진입
	@GetMapping("/admin/insertStudent")
	public String insertStudent(Model model) {
		List<CourseDTO> course = studentService.selectCourse();
		// 강의 선택에 등록된 강의만 나오도록 뷰에 값 전달
		model.addAttribute("course", course);
		return "/admin/insertStudent";
	}

	// 학생 등록 처리
	@PostMapping("/admin/insertStudent")
	public String insertStudent(@ModelAttribute StudentListForm form
			,@RequestParam("courseId") int courseId) {
		List<StudentDTO> studentList = form.getStudentList();

		// stream 처리 순서:
		// 1. filter: 모든 필수 칸에 값이 있는 학생만 추림(공백/미입력 행은 제외)
		// 2. peek: 남은 학생 객체에 선택된 courseId를 세팅하고, 비밀번호를 암호화해서 다시 세팅
		//    (peek은 중간처리 - 값을 바꿀 때 주로 사용, 실제 객체 값 변경)
		// 3. collect: 최종적으로 남은 학생들을 새 리스트로 반환(List<StudentDTO>)
		List<StudentDTO> validList = studentList.stream()
				// 1. 필수 칸(이름, 폰, 주민번호, 주소, 이메일) 모두 채워진 행만 남김
				.filter(s -> s.getName() != null && !s.getName().trim().isEmpty() 
				&& s.getPhone() != null && !s.getPhone().trim().isEmpty() 
				&& s.getSn() != null && !s.getSn().trim().isEmpty()
				&& s.getAddress() != null && !s.getAddress().trim().isEmpty() 
				&& s.getEmail() != null	&& !s.getEmail().trim().isEmpty())
				// 2. peek: 남은 학생마다 courseId 주입 + 비번 암호화
				.peek(s -> {
					s.setCourseId(courseId); // 선택한 강의로 매핑
					s.setPassword(passwordEncoder.encode(s.getPassword())); // 비번 암호화
				})
				// 3. collect: 결과를 리스트로 만듦
				.collect(Collectors.toList());

		int row = studentService.checkId(validList);

		if(row == 0) {
			studentService.insertStudentList(validList);
			return "redirect:/admin/studentList?searchOption=all&keyword=";
		} else {
			return "/admin/insertStudent";
		}

	}
}
