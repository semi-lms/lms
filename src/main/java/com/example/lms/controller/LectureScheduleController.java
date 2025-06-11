package com.example.lms.controller;

import com.example.lms.dto.LectureScheduleDTO;
import com.example.lms.service.LectureScheduleService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@Slf4j
@Controller
@RequestMapping("/lectureSchedule")
public class LectureScheduleController {

    @Autowired
    private LectureScheduleService lectureScheduleService;

    @GetMapping
    public String showLectureSchedulePage(@RequestParam("courseId") int courseId,
                                          @RequestParam(value = "year", required = false) Integer year,
                                          @RequestParam(value = "month", required = false) Integer month,
                                          HttpSession session,
                                          Model model) {

        Calendar cal = Calendar.getInstance();
        int displayYear = (year != null) ? year : cal.get(Calendar.YEAR);
        int displayMonth = (month != null) ? month : cal.get(Calendar.MONTH) + 1;

        cal.set(displayYear, displayMonth - 1, 1);
        int firstDayOfWeek = cal.get(Calendar.DAY_OF_WEEK); // 일요일=1

        int startOffset = firstDayOfWeek - 1; // 0-based offset (일요일=0)

        cal.add(Calendar.DATE, -startOffset);

        List<Map<String, Object>> weeks = new ArrayList<>();
        // 5주치 날짜 리스트
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

                String monthStr = (m < 10) ? "0" + m : String.valueOf(m);
                String dayStr = (day < 10) ? "0" + day : String.valueOf(day);
                String dateStr = y + "-" + monthStr + "-" + dayStr;

                boolean isCurrentMonth = (m == displayMonth);

                Map<String, Object> dayMap = new HashMap<>();
                dayMap.put("dateStr", dateStr);
                dayMap.put("day", day);
                dayMap.put("dayOfWeek", dayOfWeek);
                dayMap.put("isCurrentMonth", isCurrentMonth);

                days.add(dayMap);
                cal.add(Calendar.DATE, 1);
            }
            Map<String, Object> weekMap = new HashMap<>();
            weekMap.put("days", days);
            weeks.add(weekMap);
        }

        // 기존 scheduleList에서 dateToMemo(Map<String, String>)로 변환 (키를 문자열로)
        Map<String, String> dateToMemo = new HashMap<>();
        Calendar dayCal = Calendar.getInstance();

        for (LectureScheduleDTO dto : lectureScheduleService.getLectureSchedules(Map.of(
                "courseId", courseId,
                "startDate", new GregorianCalendar(displayYear, displayMonth - 1, 1).getTime(),
                "endDate", new GregorianCalendar(displayYear, displayMonth - 1, cal.getActualMaximum(Calendar.DAY_OF_MONTH)).getTime()
        ))) {
            Date startDate = dto.getStartDate();
            Date endDate = dto.getEndDate();

            if (startDate != null && endDate != null) {
                dayCal.setTime(startDate);
                while (!dayCal.getTime().after(endDate)) {
                    Date curr = dayCal.getTime();
                    String key = String.format("%tF", curr); // yyyy-MM-dd 포맷
                    dateToMemo.put(key, dto.getMemo());
                    dayCal.add(Calendar.DATE, 1);
                }
            } else if (startDate != null) {
                String key = String.format("%tF", startDate);
                dateToMemo.put(key, dto.getMemo());
            }
        }

        model.addAttribute("weeks", weeks);
        model.addAttribute("dateToMemo", dateToMemo);
        model.addAttribute("year", displayYear);
        model.addAttribute("month", displayMonth);
        model.addAttribute("courseId", courseId);

        Object teacherId = session.getAttribute("teacherId");
        if (teacherId != null) model.addAttribute("teacherId", teacherId);

        return "lectureSchedule/lectureCalendar";
    }

 // 등록 또는 수정 폼 페이지
    @GetMapping("/form")
    public String showScheduleForm(@RequestParam("courseId") int courseId,
                                   @RequestParam(value = "scheduleId", required = false) Integer scheduleId,
                                   Model model) {
        LectureScheduleDTO dto = new LectureScheduleDTO();
        if (scheduleId != null) {
            dto = lectureScheduleService.getLectureScheduleById(scheduleId);
        }

        model.addAttribute("lectureSchedule", dto);
        model.addAttribute("courseId", courseId);
        return "lecture/lectureScheduleForm";
    }

    // 저장 처리 (등록 또는 수정)
    @PostMapping("/save")
    public String saveSchedule(@ModelAttribute LectureScheduleDTO scheduleDto) {
        if (scheduleDto.getDateNo() != null) {
            lectureScheduleService.modifyLectureSchedule(scheduleDto);
        } else {
            lectureScheduleService.addLectureSchedule(scheduleDto);
        }
        return "redirect:/lectureSchedule?courseId=" + scheduleDto.getCourseId();
    }

}
