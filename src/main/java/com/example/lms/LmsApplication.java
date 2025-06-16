package com.example.lms;

import java.util.TimeZone;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.stereotype.Component;

import jakarta.annotation.PostConstruct;

@SpringBootApplication
public class LmsApplication {

	public static void main(String[] args) {
		SpringApplication.run(LmsApplication.class, args);
	}
	@Component
	public class TimeZoneConfig {

	    @PostConstruct
	    public void init() {
	        TimeZone.setDefault(TimeZone.getTimeZone("Asia/Seoul"));
	    }
	}
}
