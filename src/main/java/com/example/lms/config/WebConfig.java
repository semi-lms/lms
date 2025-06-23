package com.example.lms.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new LoginCheckInterceptor())
                .addPathPatterns("/admin/**", "/file/**", "/mypage/**", "/notice/**", "/qna/**", "/student/**", "/teacher/**")
                .excludePathPatterns("/login", "/logout", "/css/**", "/js/**", "/images/**", "/upload/**");
    }
        
    // 업로드 파일 접근 경로 등록 (URL ↔ 실제 서버 경로)
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        String os = System.getProperty("os.name").toLowerCase();
        String uploadPath;

        if (os.contains("win")) {
            uploadPath = "file:///C:/upload/";
        } else {
            uploadPath = "file:/home/ubuntu/upload/";
        }

        registry.addResourceHandler("/upload/**")
                .addResourceLocations(uploadPath);
    }
}
