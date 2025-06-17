<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 공통 메인 하단 콘텐츠 -->
<section class="common-main-section">
  <div class="common-card">
    <h3>📢 공지사항</h3>
    <ul>
      <c:forEach var="n" items="${noticeList}" varStatus="status">
        <li>${status.count}. ${n.title}</li>
      </c:forEach>
    </ul>
    <a href="/notice/noticeList" class="view-btn">더보기</a>
  </div>

  <div class="common-card">
    <h3>💬 QNA</h3>
    <ul>
      <c:forEach var="q" items="${qnaList}" varStatus="status">
        <li>${status.count}. ${q.title}</li>
      </c:forEach>
    </ul>
    <a href="/qna/qnaList" class="view-btn">더보기</a>
  </div>

  <div class="common-card">
    <h3>📁 자료실</h3>
    <ul>
      <c:forEach var="f" items="${fileBoardList}" varStatus="status">
        <li>${status.count}. ${f.title}</li>
      </c:forEach>
    </ul>
    <a href="/file/fileBoardList" class="view-btn">더보기</a>
  </div>
</section>
