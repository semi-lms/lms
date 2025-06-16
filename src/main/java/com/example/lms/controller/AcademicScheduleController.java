package com.example.lms.controller;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.lms.dto.AcademicScheduleDTO;
import com.example.lms.dto.HolidaysDTO;
import com.example.lms.service.AcademicScheduleService;
import com.example.lms.service.HolidaysService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/admin")
public class AcademicScheduleController {
	
	@Autowired private AcademicScheduleService academicScheduleService;
	@Autowired private HolidaysService holidaysService;
	
	// 관리자 달력 (개강, 종강, 휴강)
	@GetMapping("/academicSchedule")
	public String showAcademicSchedule(@RequestParam(required = false) Integer year,
						           	   @RequestParam(required = false) Integer month,
						               Model model) {

        Calendar cal = Calendar.getInstance();
        int displayYear = (year != null) ? year : cal.get(Calendar.YEAR);
        int displayMonth = (month != null) ? month : cal.get(Calendar.MONTH) + 1;

   
        // 1일 세팅
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

        List<AcademicScheduleDTO> schedules = academicScheduleService.getAcademicSchedules();
     
        Map<String, List<AcademicScheduleDTO>> dateScheduleMap = new HashMap<>();
        Calendar dayCal = Calendar.getInstance();

        for (AcademicScheduleDTO dto : schedules) {
            String key = dto.getDate();
            if (key != null) {
            	dateScheduleMap.computeIfAbsent(key, k -> new ArrayList<>()).add(dto);
            }
        }

        model.addAttribute("weeks", weeks);
        model.addAttribute("year", displayYear);
        model.addAttribute("month", displayMonth);
        model.addAttribute("dateScheduleMap", dateScheduleMap);

        return "admin/academicSchedule";
    }
	
	
	// 휴강 등록 (팝업)
	@GetMapping("/academicSchedule/insertHolidayForm")
	public String insertHolidayForm() {
		return "admin/insertHolidayForm";
	}
	
	@PostMapping("/academicSchedule/insertHoliday")
	public String insertHoliday(@ModelAttribute HolidaysDTO holidaysDTO, Model model) {
		holidaysService.insertHoliday(holidaysDTO);
		model.addAttribute("success", true);
		return "admin/insertHolidayForm";  // 리다이렉트로 할 경우 팝업창 닫는 JS 실행 불가능
	}
	
	
	// 휴강 등록 시 날짜 중복 유효성 검사
	@GetMapping("/academicSchedule/exists")
	@ResponseBody
	public boolean existsByDate(@RequestParam("date") String date) {
		return academicScheduleService.existsByDate(date);
	}
	
	
	// 휴강 수정
	@GetMapping("/academicSchedule/updateHolidayDate")
	public String updateHolidayDate() {
		return "admin/updateHolidayDate";
	}
	
	@PostMapping("/academicSchedule/updateHolidayDate")
	public String updateHolidayDate(@ModelAttribute HolidaysDTO holidaysDTO) {
		holidaysService.updateHolidayDate(holidaysDTO);
		return "redirect:/admin/academicSchedule";
	}
	
	
	// 휴강 삭제
	@PostMapping("/academicSchedule/deleteHoliday")
	public String deleteHoliiay(@ModelAttribute HolidaysDTO holidaysDTO) {
		holidaysService.deleteHoliday(holidaysDTO);
		return "redirect:/admin/academicSchedule";
	}

}
