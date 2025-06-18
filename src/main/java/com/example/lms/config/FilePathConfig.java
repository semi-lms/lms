package com.example.lms.config;

import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;

import lombok.Getter;

@Getter
@Component
public class FilePathConfig {
	
		private final String uploadPath;
	
		public FilePathConfig() {
			String os = System.getProperty("os.name").toLowerCase();
			if (os.contains("win")) {
				this.uploadPath = "C:/upload/";
			} else {
				this.uploadPath = "/home/ubuntu/upload/";
			}
			System.out.println("운영체제: " + os + " → uploadPath: " + this.uploadPath);
		}
	
		public String getUploadPath() {
			return uploadPath;
	    }
}
