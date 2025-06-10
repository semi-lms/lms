package com.example.lms.dto;



import lombok.Data;
import java.util.Date;

@Data
public class LectureScheduleDTO {
	private Integer dateNo;         // date_no
    private int courseId;       // course_id
    private Date startDate;     // start_date
    private Date endDate;       // end_date
    private String memo;        // memo
}
