package com.example.lms.controller;

import com.example.lms.dto.LectureScheduleDTO;
import com.example.lms.service.LectureScheduleService;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;

import java.text.SimpleDateFormat;
import java.util.*;

@Slf4j
@Controller
@RequestMapping("/lectureSchedule")
public class LectureScheduleController {

    @Autowired
    private LectureScheduleService lectureScheduleService;

    /**
     * 날짜 형식을 "yyyy-MM-dd"로 바인딩 설정 
     */
    @InitBinder
    public void initBinder(WebDataBinder binder) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        sdf.setLenient(false);
        binder.registerCustomEditor(Date.class, new CustomDateEditor(sdf, true));
    }

    /**
     * 강의 일정 달력 페이지 표시
     * @param courseId 강좌 ID
     * @param year 년도 (선택)
     * @param month 월 (선택)
     * @param session 로그인 세션
     * @param model 뷰에 전달할 데이터
     * @return 달력 페이지 뷰 이름
     */
    @GetMapping
    public String showLectureSchedulePage(@RequestParam("courseId") int courseId,
                                          @RequestParam(value = "year", required = false) Integer year,
                                          @RequestParam(value = "month", required = false) Integer month,
                                        
                                          HttpSession session,
                                          Model model) {

        // 현재 날짜 기준으로 연도/월 초기화
        Calendar cal = Calendar.getInstance();
        int displayYear = (year != null) ? year : cal.get(Calendar.YEAR);
        int displayMonth = (month != null) ? month : cal.get(Calendar.MONTH) + 1;

        // 해당 월의 1일로 설정 후, 해당 주의 일요일부터 시작하도록 조정
        cal.set(displayYear, displayMonth - 1, 1);
        int firstDayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
        int startOffset = firstDayOfWeek - 1;  // 일요일: 0
        cal.add(Calendar.DATE, -startOffset);

        // 5주치 날짜를 생성
        List<Map<String, Object>> weeks = new ArrayList<>();
        for (int w = 0; w < 5; w++) {
            List<Map<String, Object>> days = new ArrayList<>();
            for (int d = 0; d < 7; d++) {
                Date date = cal.getTime();
                Calendar tmpCal = Calendar.getInstance();
                tmpCal.setTime(date);

                int y = tmpCal.get(Calendar.YEAR);
                int m = tmpCal.get(Calendar.MONTH) + 1;
                int day = tmpCal.get(Calendar.DAY_OF_MONTH);
                int dayOfWeek = tmpCal.get(Calendar.DAY_OF_WEEK);

                String dateStr = String.format("%04d-%02d-%02d", y, m, day);
                boolean isCurrentMonth = (m == displayMonth);

                Map<String, Object> dayMap = new HashMap<>();
                dayMap.put("dateStr", dateStr);
                dayMap.put("day", day);
                dayMap.put("dayOfWeek", dayOfWeek);
                dayMap.put("isCurrentMonth", isCurrentMonth);
             
            

                days.add(dayMap);
             
                cal.add(Calendar.DATE, 1);  // 다음 날짜로 이동
            }
            Map<String, Object> weekMap = new HashMap<>();
            weekMap.put("days", days);
            weeks.add(weekMap);
        }

        // 일정 조회 범위 설정 (해당 월의 시작~끝)
        Date startDate = new GregorianCalendar(displayYear, displayMonth - 1, 1).getTime();
        Calendar endCal = Calendar.getInstance();
        endCal.set(displayYear, displayMonth - 1, 1);
        int lastDay = endCal.getActualMaximum(Calendar.DAY_OF_MONTH);
        endCal.set(displayYear, displayMonth - 1, lastDay);
        Date endDate = endCal.getTime();
        // DB에서 해당 강의의 일정 조회
        List<LectureScheduleDTO> schedules = lectureScheduleService.getLectureSchedules(Map.of(
                "courseId", courseId,
                "startDate", startDate,
                "endDate", endDate
        ));

        // 날짜별로 일정 리스트를 분류
        Map<String, List<LectureScheduleDTO>> dateToMemoList = new HashMap<>();
        Calendar dayCal = Calendar.getInstance();

        for (LectureScheduleDTO dto : schedules) {
            Date start = dto.getStartDate();
            Date end = dto.getEndDate();

            // 일정이 시작일~종료일까지 있는 경우, 모든 날짜에 매핑
            if (start != null && end != null) {
                dayCal.setTime(start);
                while (!dayCal.getTime().after(end)) {
                    String key = String.format("%tF", dayCal.getTime());
                    dateToMemoList.computeIfAbsent(key, k -> new ArrayList<>()).add(dto);
                    dayCal.add(Calendar.DATE, 1);
                }
            } else if (start != null) {
                String key = String.format("%tF", start);
                dateToMemoList.computeIfAbsent(key, k -> new ArrayList<>()).add(dto);
            }
        }

        // 뷰에 데이터 전달
        model.addAttribute("weeks", weeks);
        model.addAttribute("dateToMemoList", dateToMemoList);
        model.addAttribute("year", displayYear);
        model.addAttribute("month", displayMonth);
        model.addAttribute("courseId", courseId);
        if (session.getAttribute("teacherId") != null) {
            model.addAttribute("teacherId", session.getAttribute("teacherId"));
        }

        return "lectureSchedule/lectureCalendar";
    }

    /**
     * 일정 등록/수정 폼 페이지로 이동
     * @param courseId 강좌 ID
     * @param dateNo 수정할 일정 번호 (등록 시 null)
     * @param model 뷰에 전달할 데이터
     * @return 폼 페이지 뷰 이름
     */
    @GetMapping("/lectureScheduleForm")
    public String showScheduleForm(@RequestParam int courseId,
                                   @RequestParam(required = false) Integer dateNo,
                                   Model model) {

        LectureScheduleDTO schedule;

        if (dateNo != null) {
            schedule = lectureScheduleService.getScheduleByDateNo(dateNo);
            if (schedule == null) {
                // 잘못된 dateNo인 경우 예외처리 또는 기본값 세팅
                schedule = new LectureScheduleDTO();
                schedule.setCourseId(courseId);
            }
        } else {
            schedule = new LectureScheduleDTO();
            schedule.setCourseId(courseId);
        }

        model.addAttribute("schedule", schedule);
        return "lectureSchedule/lectureScheduleForm";
    }

    /**
     * 일정 저장 (등록 또는 수정)
     * @param scheduleDto 저장할 일정 DTO
     * @return 달력 페이지로 리다이렉트
     */
    @PostMapping("/save")
    public String saveSchedule(@ModelAttribute LectureScheduleDTO scheduleDto) {
        if (scheduleDto.getDateNo() != null) {
        	
            lectureScheduleService.modifyLectureSchedule(scheduleDto);  // 수정
        } else {
            lectureScheduleService.addLectureSchedule(scheduleDto);     // 신규 등록
        }
        return "redirect:/lectureSchedule?courseId=" + scheduleDto.getCourseId();
    }

    /**
     * 일정 삭제 처리
     * @param dateNo 삭제할 일정 번호
     * @param courseId 강좌 ID (리다이렉트용)
     * @return 달력 페이지로 리다이렉트
     */
    @PostMapping("/delete")
    public String deleteSchedule(@RequestParam int dateNo, @RequestParam int courseId) {
        lectureScheduleService.removeLectureSchedule(dateNo);
        return "redirect:/lectureSchedule?courseId=" + courseId;
    }
}
