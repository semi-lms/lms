package com.example.lms.controller;

import java.io.IOException;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.lms.dto.AttendanceDTO;
import com.example.lms.dto.AttendanceFileDTO;
import com.example.lms.dto.CourseDTO;
import com.example.lms.dto.ExamAnswerDTO;
import com.example.lms.dto.ExamDTO;
import com.example.lms.dto.ExamOptionDTO;
import com.example.lms.dto.ExamQuestionDTO;
import com.example.lms.dto.ExamSubmissionDTO;
import com.example.lms.dto.SessionUserDTO;
import com.example.lms.dto.StudentDTO;
import com.example.lms.dto.TeacherDTO;
import com.example.lms.service.AttendanceFileService;
import com.example.lms.service.AttendanceService;
import com.example.lms.service.CourseService;
import com.example.lms.service.ExamService;
import com.example.lms.service.StudentService;
import com.example.lms.service.TeacherService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class TeacherController {
	@Autowired private StudentService studentService;
	@Autowired private ExamService examService;
	@Autowired private CourseService courseService;
	@Autowired private AttendanceService attendanceService;
	@Autowired private TeacherService teacherService;
	@Autowired private PasswordEncoder passwordEncoder;
	@Autowired private AttendanceFileService attendanceFileService;
	
	// 강사 리스트
	@GetMapping("/admin/teacherList")
	public String getTeacherList(@ModelAttribute TeacherDTO teacherDto, Model model) {
		List<TeacherDTO> teacherList = teacherService.getTeacherList(teacherDto);
		List<CourseDTO> courseList = courseService.getCourseNameNotEnded();
		model.addAttribute("teacherList", teacherList);
		model.addAttribute("courseList", courseList);
		return "admin/teacherList";
	}
	
	
	// 강사 등록
	@GetMapping("/admin/insertTeacher")
	public String insertTeacher(Model model) {
		// 진행 중인 강의 목록 넘기기
		List<CourseDTO> courseList = courseService.getCourseNameNotEnded();
		model.addAttribute("courseList", courseList);
		return "admin/insertTeacher";
	}
	
	@PostMapping("/admin/insertTeacher")
	@ResponseBody
	public Map<String, Object> insertTeacher(@ModelAttribute TeacherDTO teacherDto) {
		Map<String, Object> result = new HashMap<>();
		
		// 아이디/비밀번호 null 또는 빈 문자열 확인
	    if (teacherDto.getTeacherId() == null || teacherDto.getTeacherId().trim().isEmpty() ||
	    		teacherDto.getPassword() == null || teacherDto.getPassword().trim().isEmpty()) {
	        result.put("success", false);
	        result.put("message", "아이디 또는 비밀번호가 누락되었습니다.");
	        return result;
	    }
		
		// 강의 중복 배정 검사
	    Integer courseId = teacherDto.getCourseId();
	    if (courseId != null && courseId > 0 && teacherService.isCourseAssigned(courseId)) {
	        result.put("success", false);
	        result.put("message", "해당 강의에는 이미 강사가 배정되어 있습니다.");
	        return result;
	    }
		
		// 비밀번호 암호화
		String encodedPassword = passwordEncoder.encode(teacherDto.getPassword());
		teacherDto.setPassword(encodedPassword);
		
		teacherService.insertTeacher(teacherDto);
		result.put("success", true);
		return result;
	}
	
	
	// 강사 정보 수정
	@GetMapping("/admin/updateTeacher")
	public String updateTeacher(@RequestParam("teacherNo") int teacherNo, Model model) {
		TeacherDTO teacherDto = teacherService.getTeacherByNo(teacherNo);
		model.addAttribute("teacherDto", teacherDto);
		model.addAttribute("courseList", courseService.getCourseNameNotEnded());
		return "admin/updateTeacher";
	}
	
	@PostMapping("/admin/updateTeacher")
	@ResponseBody
	public Map<String, Object> updateTeacher(@ModelAttribute TeacherDTO teacherDto) {
		Map<String, Object> result = new HashMap<>();
		
		// 수정 시 본인을 제외한 중복 배정 검사
		Integer courseId = teacherDto.getCourseId();
		if (courseId != null && teacherDto.getCourseId() > 0 
				&& teacherService.isCourseAssignedForUpdate(teacherDto.getCourseId(), teacherDto.getTeacherNo())) {
			result.put("success", false);
			result.put("message", "해당 강의에는 이미 다른 강사가 배정되어 있습니다.");
			return result;
		}
		
		teacherService.updateTeacher(teacherDto);
		result.put("success", true);
		return result;
	}
	
	
	// 강사 상세 조회 (수정 모달용)
	@GetMapping("/admin/getTeacherDetail")
	@ResponseBody
	public TeacherDTO getTeacherDetail(@RequestParam("teacherNo") int teacherNo) {
		TeacherDTO teacherDto = teacherService.getTeacherByNo(teacherNo);
		
		// 포맷 적용 후 모달로 전달
		teacherDto.setPhone(formatPhone(teacherDto.getPhone()));
		teacherDto.setSn(formatSn(teacherDto.getSn()));
		
		return teacherDto;
	}
	
	// 포맷 메서드 (전화번호)
	private String formatPhone(String phone) {
		if (phone != null && phone.length() == 11) {
			return phone.substring(0, 3) + "-" + phone.substring(3, 7) + "-" + phone.substring(7);
		}
		return phone;
	}
	
	// 포맷 메서드 (주민번호)
	private String formatSn(String sn) {
		if (sn != null && sn.length() == 13) {
			return sn.substring(0, 6) + "-" + sn.substring(6);
		}
		return sn;
	}
	
	
	// 강사 삭제 (여러 명 삭제 가능)
	@PostMapping("/admin/deleteTeachers")
	public String deleteTeachers(@RequestParam("teacherNos") List<Integer> teacherNos) {
		teacherService.deleteTeachers(teacherNos);
		return "redirect:/admin/teacherList";
	}
		
	
	// 강의 리스트
	@GetMapping("/courseListFromTeacher")
	public String courseListFromTeacher(@RequestParam(defaultValue = "1") int currentPage
										, @RequestParam(defaultValue = "10") int rowPerPage
										, @RequestParam(value = "filter", required = false, defaultValue = "전체") String filter
										, Model model
										, HttpSession session) {
		// 로그인한 사용자 정보에서 courseId 가져오기
		SessionUserDTO loginUser = (SessionUserDTO) session.getAttribute("loginUser");
		if (loginUser == null || loginUser.getCourseId() == 0) {
			return "redirect:/login"; // 로그인 안 되어있거나 courseId 없으면 로그인 페이지로 리다이렉트
		}
		int teacherNo = loginUser.getTeacherNo();
		
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
	public String scoreList(@RequestParam(name = "examId", required = false, defaultValue = "1") int examId
							, @RequestParam(defaultValue = "1") int currentPage
							, @RequestParam(defaultValue = "10") int rowPerPage
							, @RequestParam(value = "filter", required = false, defaultValue = "전체") String filter
							, Model model) {
		
		int courseId = examService.getCourseIdByExamId(examId);
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
	
	// 성적 상세 페이지
		@GetMapping("/scoreOne")
		public String scoreOne(@RequestParam(name = "submissionId", required = false, defaultValue = "1") int submissionId
									, Model model) {
			
			List<ExamAnswerDTO> questions = examService.getExamAnswersWithCorrect(submissionId);
			model.addAttribute("questions", questions);
			
			
			
			return "/teacher/scoreOne";
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
		return "redirect:/examList?courseId="+examDto.getCourseId();
	}
	
	@PostMapping("/removeExam")
	public String removeExam(@RequestParam("examId") int examId) {
		examService.deleteExamQuestionOption(examId);
		return "redirect:/examList?courseId="+examId;
	}
	
	@PostMapping("/insertExam")
	public String insertExam(@ModelAttribute ExamDTO examDto) {
		examService.addExam(examDto);
		return "redirect:/examList?courseId="+examDto.getCourseId();
	}
	
	// 출결 관리
	@GetMapping("/attendanceList")
	public String attendanceByClass(
		@RequestParam(required = false, defaultValue = "1") int courseId, // 강의/반 ID, URL 파라미터로 받음
		@RequestParam(required = false) Integer year,
		@RequestParam(required = false) Integer month,
		Model model) {
		
		// 0. 강의 정보 가져오기
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd"); // 날짜 포맷 패턴 선언
		
		CourseDTO course = courseService.getCourseOne(courseId);
		LocalDate courseStartDate = LocalDate.parse(course.getStartDate(), dtf);
		LocalDate courseEndDate = LocalDate.parse(course.getEndDate(), dtf);

		
		// 1. 기준 날짜 셋팅: 년/월 파라미터 없으면 오늘 기준으로
		LocalDate today = LocalDate.now();
		int y = (year != null) ? year : today.getYear(); // 연도 선택값 또는 현재 연도
		int m = (month != null) ? month : today.getMonthValue(); // 월 선택값 또는 현재 월
		LocalDate firstDay = LocalDate.of(y, m, 1); // 해당 월 1일
		LocalDate lastDay = firstDay.withDayOfMonth(firstDay.lengthOfMonth()); // 해당 월 마지막 일
		
		// 2. dayList: 해당 월의 날짜 리스트 생성 (ex. 2025-06-01, ... 2025-06-30)
		
		List<String> dayList = new ArrayList<>();
		for (LocalDate d = firstDay; !d.isAfter(lastDay); d = d.plusDays(1)) {
			if (!d.isBefore(courseStartDate) && !d.isAfter(courseEndDate)) {
				dayList.add(d.format(dtf));  // yyyy-MM-dd 형태의 문자열로 dayList에 저장
			}

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
		
		// 공결 조회
		List<AttendanceFileDTO> fileList = attendanceFileService.getAttendanceFileByCourse(courseId);
		System.out.println("파일 리스트 개수: " + fileList.size());
		for(AttendanceFileDTO file : fileList) {
		    log.info(file.getFileName());
		}
		Map<Integer, Map<String, AttendanceFileDTO>> attendanceDocMap = new HashMap<>();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

		for (AttendanceFileDTO file : fileList) {
		    String dateKey = sdf.format(file.getDate());
		    attendanceDocMap
		        .computeIfAbsent(file.getStudentNo(), k -> new HashMap<>())
		        .put(dateKey, file);
		}

		model.addAttribute("attendanceDocMap", attendanceDocMap);
		
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
		model.addAttribute("courseStartDate", courseStartDate);
		model.addAttribute("courseEndDate", courseEndDate);
		
		
		// 8. JSP로 이동 (WEB-INF/views/teacher/attendanceList.jsp)
		return "/teacher/attendanceList";
	}
	
	@PostMapping("/manageAttendance")
	public String manageAttendance(@ModelAttribute AttendanceDTO attendanceDto
									, @RequestParam(value = "proofDoc", required = false) MultipartFile proofDoc
									, HttpSession session) throws IOException {
		// 로그인한 사용자 정보에서 courseId 가져오기
		SessionUserDTO loginUser = (SessionUserDTO) session.getAttribute("loginUser");
		if (loginUser == null || loginUser.getCourseId() == 0) {
			return "redirect:/login"; // 로그인 안 되어있거나 courseId 없으면 로그인 페이지로 리다이렉트
		}
		
		// 데이터 값이 있으면 수정 없으면 입력
		int hasAttendance = attendanceService.isAttendance(attendanceDto);
		if(hasAttendance == 0) {
			attendanceService.insertAttendance(attendanceDto);
		} else {
			attendanceService.updateAttendance(attendanceDto);
		};
		
		// 공결 + 파일 존재 시 파일 저장
	    if ("공결".equals(attendanceDto.getStatus()) && proofDoc != null && !proofDoc.isEmpty()) {
			AttendanceFileDTO fileDto = new AttendanceFileDTO();
			fileDto.setAttendanceNo(attendanceService.getAttendanceNo(attendanceDto)); // DB insert 시 생성된 값 필요할 경우 서비스에서 리턴받기
			fileDto.setTeacherNo(loginUser.getTeacherNo()); // 로그인 정보 기반
			fileDto.setFileName(proofDoc.getOriginalFilename());
			fileDto.setUploadDate(LocalDate.now().toString());
			
			// base64 인코딩 처리
			String base64 = Base64.getEncoder().encodeToString(proofDoc.getBytes());
			fileDto.setBase64Data(base64);
			
			attendanceFileService.saveProofFile(fileDto);
	    }
		int courseId = attendanceDto.getCourseId();
		return "redirect:/attendanceList?courseId="+courseId;
	}
	
	// 출결 한번에 업데이트
	@PostMapping("/insertAttendanceAll")
	public String insertAttendanceAll(@RequestParam String status
									, @RequestParam int courseId
									, Model model) {
		attendanceService.insertAttendanceAll(status, courseId);
		return "redirect:/attendanceList?courseId="+courseId;
	}
	
	// 공결 증빙자료 미리보기
	@GetMapping("/attendanceFile/preview")
	public void previewFile(@RequestParam("fileId") int fileId, HttpServletResponse response) throws IOException {
	    AttendanceFileDTO fileDto = attendanceFileService.getFileById(fileId);
	    
	    if (fileDto == null || fileDto.getBase64Data() == null) {
	        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
	        return;
	    }

	    String fileName = fileDto.getFileName();
	    String contentType = URLConnection.guessContentTypeFromName(fileName); // 예: image/jpeg, application/pdf

	    byte[] fileBytes = Base64.getDecoder().decode(fileDto.getBase64Data());

	    response.setContentType(contentType != null ? contentType : "application/octet-stream");
	    response.setHeader("Content-Disposition", "inline; filename=\"" + URLEncoder.encode(fileName, "UTF-8") + "\"");
	    response.getOutputStream().write(fileBytes);
	    response.getOutputStream().flush();
	}
	
	// 공결 증빙자료 다운로드
	@GetMapping("/attendanceFile/download")
	public void downloadFile(@RequestParam("fileId") int fileId, HttpServletResponse response) throws IOException {
	    AttendanceFileDTO fileDto = attendanceFileService.getFileById(fileId);
	    
	    if (fileDto == null || fileDto.getBase64Data() == null) {
	        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
	        return;
	    }

	    // 파일 이름 인코딩
	    String fileName = URLEncoder.encode(fileDto.getFileName(), "UTF-8").replaceAll("\\+", "%20");

	    // Base64 → byte[]
	    byte[] fileBytes = Base64.getDecoder().decode(fileDto.getBase64Data());

	    response.setContentType("application/octet-stream");
	    response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
	    response.getOutputStream().write(fileBytes);
	    response.getOutputStream().flush();
	}
	
	
	// 문제 리스트
	@GetMapping("/questionList")
	public String questionList(@RequestParam(name = "examId", required = false, defaultValue = "1") int examId
								, Model model) {
		int qCnt = examService.getQuestionCnt(examId);
		if(qCnt != 0) {
			List<ExamQuestionDTO> questions = examService.getQuestionList(examId);
			model.addAttribute("questions", questions);
		}
		
		String title = examService.getExamTitle(examId);
		log.info("qCnt:"+qCnt);
		
		model.addAttribute("examId", examId);
		model.addAttribute("title", title);
		model.addAttribute("qCnt", qCnt);
		
		return "/teacher/questionList";
	}
	
	// 문제 상세 페이지
	@GetMapping("/questionOne")
	public String questionOne(@RequestParam int questionId, Model model) {
		ExamQuestionDTO question = examService.getQuestionByQuestionId(questionId); // 문제 1개
	    List<ExamOptionDTO> options = examService.getOptionsByQuestionId(questionId); // 보기들

	    model.addAttribute("question", question);
	    model.addAttribute("options", options);
		
		return "/teacher/questionOne";
	}
	
	// 문제, 보기 수정 페이지
	@PostMapping("/updateQuestion")
	public String updateQuestion(@RequestParam("questionId") int questionId
								, @RequestParam("questionTitle") String questionTitle
								, @RequestParam("questionText") String questionText
								, @RequestParam("correctNo") int correctNo
								, HttpServletRequest request) {
		// 문제 내용 업데이트
		examService.updateQuestion(questionId, questionTitle, questionText, correctNo);
		
		// 보기 업데이트
		for (int i = 1; i <= 4; i++) {
			String optionText = request.getParameter("option" + i);
			examService.updateOption(questionId, i, optionText);
		}
		
		return "redirect:/questionOne?questionId=" + questionId;
	}
		
	// 문제 등록 페이지
	@GetMapping("/addQuestion")
	public String addQuestion(@RequestParam("examId") int examId
							, Model model) {
		model.addAttribute("examId", examId);
		return "/teacher/addQuestion";
	}
	
	@PostMapping("/submitQuestions")
	@ResponseBody
	public ResponseEntity<String> submitQuestions(
	        @RequestParam("examId") int examId,
	        @RequestBody List<ExamQuestionDTO> questions) {
	    try {
	        for (ExamQuestionDTO question : questions) {
	            question.setExamId(examId); // examId 설정
	            
	            // 서비스에서 문제와 보기 모두 저장
	            examService.insertQuestionAndOptions(question);
	        }
	        return ResponseEntity.ok("등록 성공");
	    } catch (Exception e) {
	        e.printStackTrace();
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("등록 실패");
	    }
	}

}
