<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 공통 메인 하단 콘텐츠 -->
<div class="commonMain">
    <!-- 공지사항 -->
    <div class="box">
        <h3>공지사항</h3>
        <ul>
            <c:forEach var="n" items="${noticeBoard}">
                <li>${n.noticeId} ${n.title}</li>
            </c:forEach>
        </ul>
        <a href="/notice"><button>View details</button></a>
    </div>

    <!-- QNA -->
    <div class="box">
        <h3>QNA</h3>
        <ul>
            <c:forEach var="q" items="${qnaBoard}">
                <li>${q.qnaId} ${q.title}</li>
            </c:forEach>
        </ul>
        <a href="/qnaBoard"><button>View details</button></a>
    </div>

    <!-- 자료실 -->
    <div class="box">
        <h3>자료실</h3>
        <ul>
            <c:forEach var="f" items="${fileBoard}">
                <li>${f.title}</li>
            </c:forEach>
        </ul>
        <a href="/fileBoard"><button>View details</button></a>
    </div>
</div>
