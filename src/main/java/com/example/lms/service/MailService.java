package com.example.lms.service;

import java.security.SecureRandom;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class MailService {

    @Autowired
    private JavaMailSender mailSender;

    // 아이디 전송
    public void sendIdMail(String toEmail, String userName, String userId) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(toEmail);
        message.setSubject("[LMS] " + userName + "님의 아이디 찾기 결과");
        message.setText("반갑다. 요청하신 아이디는 다음과 같습니다.\n\n아이디: " + userId);
        mailSender.send(message);
    }

    // 임시 비밀번호 전송
    public void sendTempPasswordMail(String toEmail, String userName, String tempPw) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(toEmail);
        message.setSubject("[LMS] " + userName + "님의 임시 비밀번호 안내");
        message.setText("안녕하세요. 요청하신 임시 비밀번호를 발급해드립니다.\n\n임시 비밀번호: " + tempPw +
                        "\n로그인 후 반드시 비밀번호를 변경해주세요.");
        mailSender.send(message);
    }
    
    public String createTempPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$";
        SecureRandom rnd = new SecureRandom();
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < length; i++) {
            sb.append(chars.charAt(rnd.nextInt(chars.length())));
        }
        return sb.toString();
    }
}