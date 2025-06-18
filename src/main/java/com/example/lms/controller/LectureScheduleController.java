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
import java.time.LocalDate;
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
        
        model.addAttribute("year", year);
        model.addAttribute("month", month);
   
	    // 1일로 세팅
	    cal.set(displayYear, displayMonth - 1, 1);
	    // 1일이 무슨 요일인지 (일:1, 월:2, ..., 토:7)
	    int firstDayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
	    // (0:일요일, 1:월요일 ... 6:토요일)로 변경
	    int startOffset = firstDayOfWeek - 1; // Calendar.SUNDAY == 1
	    cal.add(Calendar.DATE, -startOffset); // ← 요기서 -startOffset


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

    //강의일(달력) 등록 수정 
    @GetMapping("/lectureScheduleForm")
    public String showScheduleForm(@RequestParam int courseId,
                                   @RequestParam(required = false) Integer dateNo,
                                   @RequestParam(required = false) Integer year,
                                   @RequestParam(required = false) Integer month,
                                   Model model) {

        LectureScheduleDTO schedule;

        if (dateNo != null) {
            schedule = lectureScheduleService.getScheduleByDateNo(dateNo);
            if (schedule == null) {
                schedule = new LectureScheduleDTO();
                schedule.setCourseId(courseId);
            }
        } else {
            schedule = new LectureScheduleDTO();
            schedule.setCourseId(courseId);
        }

        model.addAttribute("schedule", schedule);
        model.addAttribute("courseId", courseId);
        model.addAttribute("month", month);

        return "lectureSchedule/lectureScheduleForm";
    }


   
    @PostMapping("/save")
    public String saveSchedule(@ModelAttribute LectureScheduleDTO scheduleDto,
                               @RequestParam(required = false) Integer year,
                               @RequestParam(required = false) Integer month) {

        if (scheduleDto.getDateNo() != null) {
            lectureScheduleService.modifyLectureSchedule(scheduleDto);
        } else {
            lectureScheduleService.addLectureSchedule(scheduleDto);
        }

        return "redirect:/lectureSchedule?courseId=" + scheduleDto.getCourseId()
                + (year != null ? "&year=" + year : "")
                + (month != null ? "&month=" + month : "");
    }


   
    @PostMapping("/delete")
    public String deleteSchedule(@RequestParam int dateNo, @RequestParam int courseId) {
        lectureScheduleService.removeLectureSchedule(dateNo);
        return "redirect:/lectureSchedule?courseId=" + courseId;
    }
}
