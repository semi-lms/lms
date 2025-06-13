package com.example.lms.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new LoginCheckInterceptor())
                .addPathPatterns("/mypage/**", "/admin/**", "/notice/**", "/qna/**", "/file/**")
                .excludePathPatterns("/login", "/logout", "/css/**", "/js/**", "/images/**");
    }
}
