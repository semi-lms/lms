<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- 메인 하단에 보여지는 공통 푸터 여러페이지에 있으므로 따로 생성 -->

<!-- footer.jsp: 하단 미리보기 출력 전용 값 -->
<div class="footer content">
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