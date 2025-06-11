<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div style="border: 2px solid #ddd; padding: 10px; padding-top: 30px; border-radius: 15px;
            width: 250px; height: 700px; background-color: #fff; box-shadow: 2px 2px 10px rgba(0,0,0,0.1); text-align: center;">
    
    <p style="font-size: 18px;"><strong>${loginUser.name}</strong>관리자</p>
    <p style="margin-bottom: 10px;">마이페이지</p>

   <a href="/main"><button style="font-size: 20px;">🏠 홈</button></a><br><br>

    <a href="/mypage/attendance"><button>전체일정</button></a><br><br>
    <button type="button" onclick="toggleSubmenu()">관리목록</button><br><br>
    <!-- 하위 메뉴: 기본은 숨김 -->
	<div id="submenu">
	  <a href="/manage/course" class="submenu-link">• 학생</a>
	  <a href="/manage/member" class="submenu-link">• 강사</a>
	  <a href="/manage/stat" class="submenu-link">• 강의</a>
	</div>
    <a href="/mypage/exam"><button>출석통계</button></a><br><br>
    <a href="/mypage/schedule"><button>공지사항</button></a><br><br>
    <a href="/qna"><button>QNA</button></a><br><br>
    <a href="/fileBoard"><button>자료실</button></a><br><br>
    <a href="/logout"><button>로그아웃</button></a>
</div>