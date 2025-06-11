<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div>
  <h3>👤 개인정보</h3>
  <p>아이디: 
      <c:choose>
      <c:when test="${loginUser.role eq 'admin'}">${loginUser.adminId}</c:when>
      <c:when test="${loginUser.role eq 'teacher'}">${loginUser.teacherId}</c:when>
      <c:when test="${loginUser.role eq 'student'}">${loginUser.studentId}</c:when>
    </c:choose>
  </p>
  <p>이름: ${loginUser.name}</p>
  <p>이메일: ${loginUser.email}</p>
  <p>수강과목: ${loginUser.courseId}</p>
  <p>비밀번호: </p>
  <p>비밀번호 확인: </p>
  <p>가입일: ${loginUser.regDate}</p>
</div>