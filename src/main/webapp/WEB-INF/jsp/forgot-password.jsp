<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Forgot Password</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/forgot-password.css">

	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Lato:ital,wght@0,300;0,400;0,700;1,300;1,400;1,700&display=swap" rel="stylesheet">

</head>
<body>
    <div class="background-image"></div>

    <div class="confirm-container">
        <div class="confirm-header">
            <h1>Forgot Password</h1>
        </div>

        <p class="confirm-subtitle">Enter your registered email to receive a password reset link.</p>

        <c:if test="${not empty error}">
            <div class="message-error">${error}</div>
        </c:if>
        <c:if test="${not empty msg}">
            <div class="message-success">${msg}</div>
        </c:if>

        <form method="post" action="/forgot-password">
            <div class="email-input-wrapper">
                <input 
                    type="email" 
                    name="email" 
                    class="email-input"
                    value="${email}" 
                    placeholder="you@example.com"
                    required 
                />
                <i class="fas fa-envelope email-icon"></i>
            </div>

            <button type="submit" class="confirm-btn">Send Reset Link</button>
        </form>

        <div class="footer-link">
            <a href="${pageContext.request.contextPath}/login">
                <i class="fas fa-arrow-left"></i> Back to Login
            </a>
        </div>
    </div>
</body>
</html>
