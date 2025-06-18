<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- 공통 메인 하단 콘텐츠 -->
<section class="common-main-section">
  <div class="common-card" data-url="/notice/noticeList">
    <h3>📢 공지사항</h3>
    <ul class="notice-list">
      <c:forEach var="n" items="${noticeList}" varStatus="status">
        <li class="list-item">
          ${n.title}   
          <span class="date">
            <fmt:formatDate value="${n.createDate}" pattern="yyyy-MM-dd" />
          </span>
        </li>
      </c:forEach>
    </ul>
  </div>

  <div class="common-card" data-url="/qna/qnaList">
    <h3>💬 QNA</h3>
    <ul class="qna-list">
      <c:forEach var="q" items="${qnaList}" varStatus="status">
        <li class="list-item">
          ${q.title}   
          <span class="date">
            <fmt:formatDate value="${q.createDate}" pattern="yyyy-MM-dd" />
          </span>
        </li>
      </c:forEach>
    </ul>
  </div>

  <div class="common-card" data-url="/file/fileBoardList">
    <h3>📁 자료실</h3>
    <ul class="file-list">
      <c:forEach var="f" items="${fileBoardList}" varStatus="status">
        <li class="list-item">
          ${f.title}   
          <span class="date">
            <fmt:formatDate value="${f.createDate}" pattern="yyyy-MM-dd" />
          </span>
        </li>
      </c:forEach>
    </ul>
  </div>
</section>

<script>
  document.addEventListener("DOMContentLoaded", function() {
    document.querySelectorAll(".common-card").forEach(card => {
      card.style.cursor = "pointer";
      card.addEventListener("click", function(e) {
        // a 태그 누르면 중복 이동 방지
        if (!e.target.closest("a")) {
          const url = this.getAttribute("data-url");
          if (url) window.location.href = url;
        }
      });
    });
  });
</script>