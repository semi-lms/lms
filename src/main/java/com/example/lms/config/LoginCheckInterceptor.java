package com.example.lms.config;

import org.springframework.web.servlet.HandlerInterceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class LoginCheckInterceptor implements HandlerInterceptor{
   
	@Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        HttpSession session = request.getSession(false); // 세션이 없으면 null 반환

        if (session == null || session.getAttribute("loginUser") == null) {
            response.sendRedirect("/login"); // 로그인 페이지로 리다이렉트
            return false; // 컨트롤러 요청 차단
        }

        return true; // 통과
    }
}
