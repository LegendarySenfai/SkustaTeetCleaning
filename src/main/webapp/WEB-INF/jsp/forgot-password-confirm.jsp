<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head><meta charset="UTF-8"><title>Enter OTP</title></head>
<body>
<h2>Enter OTP</h2>
<c:if test="${not empty error}"><p style="color:red">${error}</p></c:if>
<c:if test="${not empty msg}"><p style="color:green">${msg}</p></c:if>

<form method="post" action="/forgot-password/confirm">
    <input type="hidden" name="email" value="${email}" />
    <label>OTP sent to ${email}:</label><br/>
    <input type="text" name="code" required /><br/><br/>
    <button type="submit">Verify OTP</button>
</form>

<p><a href="${pageContext.request.contextPath}/forgot-password">Back</a></p>
</body>
</html>
