<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head><title>Confirm Registration</title></head>
<body>
<h2>Confirm Registration</h2>
<c:if test="${not empty error}"><p style="color:red">${error}</p></c:if>
<c:if test="${not empty msg}"><p style="color:green">${msg}</p></c:if>

<form method="post" action="/register/confirm">
    <input type="hidden" name="pendingUserId" value="${pendingUserId}" />
    Enter OTP sent to your email: <input name="code" /><br/>
    <button type="submit">Confirm</button>
</form>

<p>If you didn't receive the code, re-register or contact admin.</p>
</body>
</html>
