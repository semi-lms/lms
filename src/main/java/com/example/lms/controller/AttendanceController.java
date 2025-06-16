package com.example.lms.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
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
    
    // 출석 통계(전체) 페이지
    @GetMapping("/admin/attendanceStatistics")
    public String getAttendanceStatistics(Model model) {
        LocalDate now = LocalDate.now();
        String startDate = now.withDayOfMonth(1).toString();     // 이번 달 1일
        String endDate = LocalDate.now().plusDays(1).toString(); // 오늘 + 1일

        // 강의(반) ID, 이름
        List<Integer> courseIds = Arrays.asList(1, 2, 3, 4, 5);
        List<String> classNames = Arrays.asList("A반", "B반", "C반", "D반", "E반");

        // 통계 데이터 저장할 리스트
        List<Integer> studentCounts = new ArrayList<>();
        List<Integer> attendanceTotalCounts = new ArrayList<>();
        List<Integer> actuals = new ArrayList<>();

        // 각 반(courseId)별 데이터 집계
        for (Integer courseId : courseIds) {
            int studentCount = attendanceService.getStudentCount(courseId);  // 학생 수
            int attendanceTotalCount = attendanceService.getAttendanceTotalCount(startDate, endDate, studentCount, courseId); // 전체 출석 가능 횟수
            int actual = attendanceService.getActualAttendance(startDate, endDate, courseId); // 실제 출석(지각포함) 횟수

            studentCounts.add(studentCount);
            attendanceTotalCounts.add(attendanceTotalCount);
            actuals.add(actual);
        }

        // JSP에서 쓸 데이터 모델에 저장
        model.addAttribute("classNames", classNames);
        model.addAttribute("studentCounts", studentCounts);
        model.addAttribute("attendanceTotalCounts", attendanceTotalCounts);
        model.addAttribute("actuals", actuals);
        model.addAttribute("courseIds", courseIds);

        // 통계 페이지로 이동
        return "/admin/attendanceStatistics";
    }
    
    // 특정 반/월별 출석 상세 페이지
    @GetMapping("/admin/attendanceByClass")
    public String attendanceByClass(
            @RequestParam int courseId, // 강의(반) ID
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Integer month,
            Model model) {

        // 1. 기준 연/월 세팅 (파라미터 없으면 이번 달)
        LocalDate today = LocalDate.now();
        int y = (year != null) ? year : today.getYear();
        int m = (month != null) ? month : today.getMonthValue();
        LocalDate firstDay = LocalDate.of(y, m, 1);            // 해당 월 1일
        LocalDate lastDay = firstDay.withDayOfMonth(firstDay.lengthOfMonth()); // 마지막 일

        // 2. dayList: 해당 월의 날짜 리스트(yyyy-MM-dd 문자열)
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        List<String> dayList = new ArrayList<>();
        for (LocalDate d = firstDay; !d.isAfter(lastDay); d = d.plusDays(1)) {
            dayList.add(d.format(dtf));
        }

        // 3. 출석/학생 데이터 조회
        List<AttendanceDTO> list = attendanceService.getAttendanceByClass(courseId);    // 출석 정보(학생번호, 날짜, 상태)
        List<StudentDTO> studentList = attendanceService.getStudentListByCourse(courseId); // 반 학생명단

        // (디버깅) 실제 출석 DTO 데이터 콘솔 출력
        System.out.println("AttendanceDTO 리스트 디버깅 ---------");
        for (AttendanceDTO dto : list) {
            System.out.println("학생번호: " + dto.getStudentNo() + ", 날짜: " + dto.getDate() + ", 상태: " + dto.getStatus());
        }
        System.out.println("----------------------------------");

        // 4. 출석 map 생성 (학생번호 -> 날짜별 출석상태)
        Map<Integer, Map<String, String>> attendanceMap = new HashMap<>();
        for (AttendanceDTO dto : list) {
            int studentNo = dto.getStudentNo();
            java.util.Date date = dto.getDate();
            String dateKey = new java.text.SimpleDateFormat("yyyy-MM-dd").format(date);
            String status = dto.getStatus();
            attendanceMap
                .computeIfAbsent(studentNo, k -> new HashMap<>())
                .put(dateKey, status);
        }

        // 5. 공휴일/휴강일 리스트 (yyyy-MM-dd 형식)
        List<String> holidays = attendanceService.getHolidayList()
            .stream()
            .map(date -> date.toLocalDate().format(dtf))
            .collect(Collectors.toList());

        // (디버깅) 출석 map, 날짜 리스트 콘솔 확인
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

        // 6. JSP로 전달할 데이터 Model에 저장
        model.addAttribute("studentList", studentList);    // 학생명단
        model.addAttribute("dayList", dayList);            // 날짜 리스트
        model.addAttribute("attendanceMap", attendanceMap);// 학생별-날짜별 출결 상태
        model.addAttribute("holidays", holidays);          // 휴일 리스트
        model.addAttribute("year", y);                     // 연도
        model.addAttribute("month", m);                    // 월
        model.addAttribute("courseId", courseId);          // 반/강의ID

        // 7. 이전/다음 달 값 계산(네비게이션 버튼용)
        int prevYear = (m == 1) ? y - 1 : y;
        int prevMonth = (m == 1) ? 12 : m - 1;
        int nextYear = (m == 12) ? y + 1 : y;
        int nextMonth = (m == 12) ? 1 : m + 1;
        model.addAttribute("prevYear", prevYear);
        model.addAttribute("prevMonth", prevMonth);
        model.addAttribute("nextYear", nextYear);
        model.addAttribute("nextMonth", nextMonth);

        // 8. JSP로 이동 (상세 출석 페이지)
        return "/admin/attendanceByClass";
    }

}
