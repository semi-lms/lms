package com.example.lms.config;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

@WebListener
public class WebSocketInitializer implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext ctx = sce.getServletContext();
        ApplicationContext applicationContext = WebApplicationContextUtils.getRequiredWebApplicationContext(ctx);
        applicationContext.getBean(com.example.lms.config.ChatServer.class); // Bean 강제 등록
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    }
}
