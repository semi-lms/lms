package com.example.lms.dto;

import lombok.Data;

@Data
public class AcademicScheduleDTO {
    private String date;
    private String memo;
    private String type;  		// 개강, 종강, 휴강, 공휴일
    private Integer holidayId;  // 휴강 및 공휴일만 해당
}
