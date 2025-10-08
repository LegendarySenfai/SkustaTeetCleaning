<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head><title>Login</title></head>
<body>
<h2>Login</h2>
<c:if test="${not empty error}"><p style="color:red">${error}</p></c:if>
<c:if test="${not empty msg}"><p style="color:green">${msg}</p></c:if>
<form method="post" action="/login">
    Username: <input name="username"/><br/>
    Password: <input type="password" name="password"/><br/>
    <button type="submit">Login</button>
</form>
<p>No account? <a href="/register">Register here</a></p>
</body>
</html>
