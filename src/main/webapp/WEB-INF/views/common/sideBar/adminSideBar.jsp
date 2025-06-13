<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">

<div class="sidebar">
    <p class="user-name"><strong>${loginUser.name}</strong> 김예진/노민혁 님</p>
    <p class="title">마이페이지</p>

    <a href="/main"><button class="sidebar-btn home">🏠 홈</button></a><br><br>
    <button class="sidebar-btn" onclick="toggleSubmenu()">관리목록</button><br><br>
    <!-- 하위 메뉴: 기본은 숨김 -->
		<div id="submenu">
		  <a href="/admin/studentList" class="submenu-link">• 학생</a>
		  <a href="/admin/teacherList" class="submenu-link">• 강사</a>
		  <a href="/admin/courseList" class="submenu-link">• 강의</a>
		</div>
    <a href="/admin/attendanceStatistics"><button class="sidebar-btn">출석통계</button></a><br><br>
    <a href="/notice/noticeList"><button class="sidebar-btn">공지사항</button></a><br><br>
    <a href="/qna"><button class="sidebar-btn">QNA</button></a><br><br>
    <a href="/fileBoard"><button class="sidebar-btn">자료실</button></a><br><br>
    <a href="/logout"><button class="sidebar-btn">로그아웃</button></a>
</div>

<script>
function toggleSubmenu() {
  $('#submenu').slideToggle();  // 클릭할 때마다 메뉴 보이기/숨기기 전환
}
</script>
