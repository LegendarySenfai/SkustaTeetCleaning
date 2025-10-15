<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Forgot Password</title>
</head>
<body>
<h2>Forgot Password</h2>
<c:if test="${not empty error}"><p style="color:red">${error}</p></c:if>
<c:if test="${not empty msg}"><p style="color:green">${msg}</p></c:if>

<form method="post" action="/forgot-password">
    <label>Your registered email:</label><br/>
    <input type="email" name="email" value="${email}" required /><br/><br/>
    <button type="submit">Send OTP</button>
</form>

<p><a href="${pageContext.request.contextPath}/login">Back to Login</a></p>
</body>
</html>
