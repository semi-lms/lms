package com.example.lms.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.lms.dto.HolidaysDTO;
import com.example.lms.service.HolidaysService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/admin")
public class HolidaysController {
	
	@Autowired private HolidaysService holidaysService;
	
	// 휴강 등록 (팝업)
	@GetMapping("/holidays/insertHolidayForm")
	public String insertHolidayForm() {
		return "admin/insertHolidayForm";
	}
	
	@PostMapping("/holidays/insertHoliday")
	public String insertHoliday(@ModelAttribute HolidaysDTO holidaysDTO, Model model) {
		holidaysService.insertHoliday(holidaysDTO);
		model.addAttribute("success", true);
		return "admin/insertHolidayForm";  // 리다이렉트로 할 경우 팝업창 닫는 JS 실행 불가능
	}
	
	
	// 휴강 등록 시 날짜 중복 유효성 검사 -> 날짜에 해당하는 일정 유형 반환
	@GetMapping("/holidays/dateType")
	@ResponseBody
	public String getDateType(@RequestParam("date") String date) {
		return holidaysService.getDateType(date);
	}
	
	
	// 휴강 날짜 수정 (팝업)
	@GetMapping("/holidays/editHolidayForm")
	public String editHoliday(@RequestParam("date") String date,
							  @RequestParam("holidayId") Integer holidayId, 	
						      Model model) {
		model.addAttribute("date", date);
		model.addAttribute("holidayId", holidayId);
		return "admin/editHolidayForm";
	}
	
	@PostMapping("/holidays/updateHolidayDate")
	public String updateHolidayDate(@ModelAttribute HolidaysDTO holidaysDTO, Model model) {
		holidaysService.updateHolidayDate(holidaysDTO);
		model.addAttribute("success", true);
		return "admin/editHolidayForm";
	}
	
	
	// 휴강 날짜 수정 시 날짜 유효성 검사
	@GetMapping("/holidays/duplicate-check")
	@ResponseBody
	public boolean isDuplicateDateForUpdate(@RequestParam("date") String date,
											@RequestParam("holidayId") int holidayId) {
		HolidaysDTO holidaysDTO = new HolidaysDTO();
		holidaysDTO.setDate(date);
		holidaysDTO.setHolidayId(holidayId);
		return holidaysService.isDuplicateDateForUpdate(holidaysDTO);
	}
	
	
	// 휴강 삭제 (팝업)
	@PostMapping("/holidays/deleteHoliday")
	public String deleteHoliday(@ModelAttribute HolidaysDTO holidaysDTO, Model model) {
		holidaysService.deleteHoliday(holidaysDTO);
		model.addAttribute("deleted", true);
		return "admin/editHolidayForm";
	}
}
