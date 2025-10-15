<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Set New Password</title>

    <!-- Google Fonts: Lato -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:ital,wght@0,300;0,400;0,700;1,300;1,400;1,700&display=swap" rel="stylesheet">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
	
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/forgot-password-new.css">


</head>
<body>
    <div class="background-image"></div>

    <div class="confirm-container">
        <div class="confirm-header">
            <h1>Set New Password</h1>
        </div>

        <p class="confirm-subtitle">
            Create a new password for your account.
        </p>

        <c:if test="${not empty error}">
            <div class="message-error">${error}</div>
        </c:if>
        <c:if test="${not empty msg}">
            <div class="message-success">${msg}</div>
        </c:if>

        <form method="post" action="/forgot-password/new-password">
            <input type="hidden" name="email" value="${email}" />

            <div class="password-input-wrapper">
                <label for="newPassword">New Password</label>
                <input 
                    type="password" 
                    id="newPassword"
                    name="newPassword" 
                    class="password-input"
                    required 
                />
            </div>

            <div class="password-input-wrapper">
                <label for="confirmPassword">Confirm New Password</label>
                <input 
                    type="password" 
                    id="confirmPassword"
                    name="confirmPassword" 
                    class="password-input"
                    required 
                />
            </div>

            <button type="submit" class="confirm-btn">Update Password</button>
        </form>

        <div class="footer-link">
            <a href="${pageContext.request.contextPath}/login">
                <i class="fas fa-arrow-left"></i> Cancel
            </a>
        </div>
    </div>
</body>
</html>