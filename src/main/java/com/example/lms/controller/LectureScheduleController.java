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

        // 이번 달 첫날과 마지막날 구하기
        cal.set(displayYear, displayMonth - 1, 1);
        Date firstDay = cal.getTime();

        cal.set(displayYear, displayMonth - 1, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
        Date lastDate = cal.getTime();

        Map<String, Object> params = new HashMap<>();
        params.put("courseId", courseId);
        params.put("startDate", firstDay);
        params.put("endDate", lastDate);

        List<LectureScheduleDTO> scheduleList = lectureScheduleService.getLectureSchedules(params);

        log.info("scheduleList size = {}", scheduleList.size());
        for (LectureScheduleDTO dto : scheduleList) {
            log.info("dto startDate={}, endDate={}, memo={}", dto.getStartDate(), dto.getEndDate(), dto.getMemo());
        }

        Map<Date, String> dateToMemo = new HashMap<>();
        Calendar dayCal = Calendar.getInstance();

        for (LectureScheduleDTO dto : scheduleList) {
            Date startDate = dto.getStartDate();
            Date endDate = dto.getEndDate();

            if (startDate != null && endDate != null) {
                dayCal.setTime(startDate);
                while (!dayCal.getTime().after(endDate)) {
                    dateToMemo.put(dayCal.getTime(), dto.getMemo());
                    dayCal.add(Calendar.DATE, 1);
                }
            } else if (startDate != null) {
                dateToMemo.put(startDate, dto.getMemo());
            } else {
                log.info("start 또는 end 날짜가 null임: start={}, end={}", startDate, endDate);
            }
        }

        // 달력 그리기 (Date 대신 Calendar로 계산)
        List<List<Date>> weeks = new ArrayList<>();
        cal.set(displayYear, displayMonth -1, 1);
        int firstDayOfWeek = cal.get(Calendar.DAY_OF_WEEK); // 일요일=1, 토요일=7
        int startOffset = firstDayOfWeek - 1; // 일요일=0 기준

        cal.add(Calendar.DATE, -startOffset);
        // 6주 → 5주로 변경
        for (int week = 0; week < 5; week++) {
            List<Date> days = new ArrayList<>();
            for (int day = 0; day < 7; day++) {
                days.add(cal.getTime());
                cal.add(Calendar.DATE, 1);
            }
            weeks.add(days);
        }

        model.addAttribute("weeks", weeks);
        model.addAttribute("dateToMemo", dateToMemo);
        model.addAttribute("year", displayYear);
        model.addAttribute("month", displayMonth);
        model.addAttribute("courseId", courseId);

        Object teacherId = session.getAttribute("teacherId");
        if (teacherId != null) {
            model.addAttribute("teacherId", teacherId);
        }

        return "lecture/lectureCalendar";
    }
}
