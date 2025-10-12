<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head><title>Admin OTP</title></head>
<body>
<h2>Admin Login - OTP Confirmation</h2>
<c:if test="${not empty error}"><p style="color:red">${error}</p></c:if>
<c:if test="${not empty msg}"><p style="color:green">${msg}</p></c:if>

<form method="post" action="/admin/confirm-otp">
    Enter OTP sent to system email: <input name="code" required /><br/>
    <button type="submit">Confirm</button>
</form>

<p><a href="/admin/login">Back to admin login</a></p>
</body>
</html>
