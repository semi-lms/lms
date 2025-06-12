<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">

<div class="sidebar">
    <p class="user-name"><strong>${loginUser.name}</strong> 님</p>
    <p class="title">마이페이지</p>

    <a href="/main"><button class="sidebar-btn home">🏠 홈</button></a><br><br>
    <button class="sidebar-btn" onclick="loadContent('/mypage/info')">개인정보</button><br><br>
    <a href="/mypage/attendance"><button class="sidebar-btn">출석현황</button></a><br><br>
    <a href="/mypage/courses"><button class="sidebar-btn">수강과목</button></a><br><br>
    <a href="/mypage/exam"><button class="sidebar-btn">시험문제</button></a><br><br>
    <a href="/localhost/lectureSchedule?courseId=?&year=2025&month=6"><button class="sidebar-btn">강의일정</button></a><br><br>
    <a href="/mypage/schedule"><button class="sidebar-btn">공지사항</button></a><br><br>
    <a href="/qna"><button class="sidebar-btn">QNA</button></a><br><br>
    <a href="/fileBoard"><button class="sidebar-btn">자료실</button></a><br><br>
    <a href="/logout"><button class="sidebar-btn">로그아웃</button></a>
</div>
