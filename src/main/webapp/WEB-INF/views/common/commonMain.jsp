<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- 공통 메인 하단 콘텐츠 -->
<section class="common-main-section">
  <div class="common-card">
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
    <a href="/notice/noticeList" class="view-btn">더보기</a>
  </div>

  <div class="common-card">
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
    <a href="/qna/qnaList" class="view-btn">더보기</a>
  </div>

  <div class="common-card">
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
    <a href="/file/fileBoardList" class="view-btn">더보기</a>
  </div>
</section>
