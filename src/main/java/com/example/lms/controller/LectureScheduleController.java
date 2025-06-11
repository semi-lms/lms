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

    @GetMapping
    public String showLectureSchedulePage(@RequestParam int courseId,
                                          @RequestParam(required = false) Integer year,
                                          @RequestParam(required = false) Integer month,
                                          HttpSession session,
                                          Model model) {

        Calendar cal = Calendar.getInstance();
        int displayYear = (year != null) ? year : cal.get(Calendar.YEAR);
        int displayMonth = (month != null) ? month : cal.get(Calendar.MONTH) + 1;

   
     // 1일 셋팅
        cal.set(displayYear, displayMonth - 1, 1);
        int firstDayOfWeek = cal.get(Calendar.DAY_OF_WEEK);

        // 일요일이면 offset 0, 아니면 (요일 - 2)로 계산 (월=0, ... 일=6)
        int startOffset = (firstDayOfWeek == Calendar.SUNDAY) ? 0 : firstDayOfWeek - 2;
        if (startOffset < 0) startOffset = 6;  // 일요일일 때 음수 방지

        // 달력 시작 날짜 = 1일 - startOffset 일
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
            // hasCurrentMonthDate == false 인 경우, weeks에 안 넣으므로 빈 줄 제거됨
        }


        // 시작, 끝 날짜 계산 (현재 월 1일 ~ 말일)
        Calendar startCal = Calendar.getInstance();
        startCal.set(displayYear, displayMonth - 1, 1);
        Date startDate = startCal.getTime();

        Calendar endCal = Calendar.getInstance();
        int lastDay = endCal.getActualMaximum(Calendar.DAY_OF_MONTH);
        endCal.set(displayYear, displayMonth - 1, lastDay);
        Date endDate = endCal.getTime();

        List<LectureScheduleDTO> schedules = lectureScheduleService.getLectureSchedules(Map.of(
                "courseId", courseId,
                "startDate", startDate,
                "endDate", endDate
        ));

        Map<String, List<LectureScheduleDTO>> dateToMemoList = new HashMap<>();
        Calendar dayCal = Calendar.getInstance();

        for (LectureScheduleDTO dto : schedules) {
            Date start = dto.getStartDate();
            Date end = dto.getEndDate();

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

   
    @PostMapping("/save")
    public String saveSchedule(@ModelAttribute LectureScheduleDTO scheduleDto) {
        if (scheduleDto.getDateNo() != null) {
        	
            lectureScheduleService.modifyLectureSchedule(scheduleDto);  // 수정
        } else {
            lectureScheduleService.addLectureSchedule(scheduleDto);     // 신규 등록
        }
        return "redirect:/lectureSchedule?courseId=" + scheduleDto.getCourseId();
    }

   
    @PostMapping("/delete")
    public String deleteSchedule(@RequestParam int dateNo, @RequestParam int courseId) {
        lectureScheduleService.removeLectureSchedule(dateNo);
        return "redirect:/lectureSchedule?courseId=" + courseId;
    }
}
