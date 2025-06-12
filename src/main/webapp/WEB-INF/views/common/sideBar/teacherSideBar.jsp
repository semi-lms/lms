<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">

<div class="sidebar">
    <p class="user-name"><strong>${loginUser.name}</strong> 님</p>
    <p class="title">마이페이지</p>

    <a href="/main"><button class="sidebar-btn home">🏠 홈</button></a><br><br>
    <button class="sidebar-btn" onclick="loadContent('/mypage/info')">개인정보</button><br><br>
    <button class="sidebar-btn" onclick="toggleSubmenu()">관리목록</button><br><br>
    <!-- 하위 메뉴: 기본은 숨김 -->
		<div id="submenu">
		  <a href="/manage/course" class="submenu-link">• 출결</a>
		  <a href="/manage/member" class="submenu-link">• 학생</a>
		  <a href="/manage/stat" class="submenu-link">• 시험</a>
		</div>
    <a href="/lectureSchedule?=${loginuser.courseId }&year=2025&month=6"><button class="sidebar-btn">강의일정</button></a><br><br>
    <a href="/mypage/schedule"><button class="sidebar-btn">공지사항</button></a><br><br>
    <a href="/qna"><button class="sidebar-btn">QNA</button></a><br><br>
    <a href="/fileBoard"><button class="sidebar-btn">자료실</button></a><br><br>
    <a href="/logout"><button class="sidebar-btn">로그아웃</button></a>
</div>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
function toggleSubmenu() {
  $('#submenu').slideToggle();  // 클릭할 때마다 메뉴 보이기/숨기기 전환
}
</script>