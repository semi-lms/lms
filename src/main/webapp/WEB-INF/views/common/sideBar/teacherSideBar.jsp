<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <img src="/img/cursor.png" id="custom-cursor" alt="커서" />


<link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">

<div class="sidebar">
	<div class="user-role">강사</div>
    <p class="user-name"><strong>${loginUser.name}</strong> 강사님</p>
    <p class="title">마이페이지</p>

    <a href="/main"><button class="sidebar-btn home">🏠 홈</button></a><br><br>
    <button type="button" class="sidebar-btn" onclick="goToInfo()">개인정보</button><br><br>
    <a href="/courseListFromTeacher?teacherNo=${loginUser.teacherNo}"><button class="sidebar-btn">강의목록</button></a><br><br>
    <button class="sidebar-btn" onclick="toggleSubmenu()">관리목록</button><br><br>
    <!-- 하위 메뉴: 기본은 숨김 -->
		<div id="submenu">
		  <a href="/attendanceList?courseId=${loginUser.courseId}" class="submenu-link">• 출결</a>
		  <a href="/studentListFromTeacher?courseId=${loginUser.courseId}" class="submenu-link">• 학생</a>
		  <a href="/examList?courseId=${loginUser.courseId}" class="submenu-link">• 시험</a>
		</div>
    <a href="/lectureSchedule?courseId=${loginUser.courseId}&year=2025&month=6"><button class="sidebar-btn">강의일정</button></a><br><br>
     <a href="/notice/noticeList"><button class="sidebar-btn">공지사항</button></a><br><br>
    <a href="/qna/qnaList"><button class="sidebar-btn">QNA</button></a><br><br>
    <a href="/file/fileBoardList"><button class="sidebar-btn">자료실</button></a><br><br>
   <a href="/attendanceList?courseId=${loginUser.courseId}"><button class="sidebar-btn">출결관리</button></a><br><br>
    <a href="/logout"><button class="sidebar-btn">로그아웃</button></a>
</div>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', () => {
	  const cursorImg = document.getElementById('custom-cursor');
	  document.addEventListener('mousemove', function (e) {
	    cursorImg.style.left = (e.clientX + 30) + 'px';  // 마우스 x좌표 + 30px
	    cursorImg.style.top = (e.clientY + 30) + 'px';   // 마우스 y좌표 + 30px
	  });
	});
	
function toggleSubmenu() {
	  $('#submenu').slideToggle();  // 클릭할 때마다 메뉴 보이기/숨기기 전환
	}
function goToInfo() {
  // 현재 페이지가 mypage.jsp가 아니라면 먼저 이동
  if (!document.getElementById('contentArea')) {
    location.href = '/mypage'; // 이동 후 document.ready에서 info 자동 로딩됨
  } else {
    loadContent('/mypage/info'); // 이미 mypage.jsp면 바로 AJAX 로딩
  }
}

function loadContent(url) {
  fetch(url)
    .then(response => response.text())
    .then(html => {
      document.getElementById('contentArea').innerHTML = html;
    });
}
</script>