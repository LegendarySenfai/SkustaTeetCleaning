<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head><meta charset="UTF-8"><title>Set New Password</title></head>
<body>
<h2>Set New Password</h2>
<c:if test="${not empty error}"><p style="color:red">${error}</p></c:if>
<c:if test="${not empty msg}"><p style="color:green">${msg}</p></c:if>

<form method="post" action="/forgot-password/new-password">
    <input type="hidden" name="email" value="${email}" />
    <label>New password:</label><br/>
    <input type="password" name="newPassword" required /><br/><br/>
    <label>Confirm new password:</label><br/>
    <input type="password" name="confirmPassword" required /><br/><br/>
    <button type="submit">Update Password</button>
</form>

<p><a href="${pageContext.request.contextPath}/login">Cancel</a></p>
</body>
</html>
