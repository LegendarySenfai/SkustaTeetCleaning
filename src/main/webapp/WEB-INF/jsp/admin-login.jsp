<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head><title>Admin Login</title></head>
<body>
<h2>Admin Login</h2>
<c:if test="${not empty error}"><p style="color:red">${error}</p></c:if>
<form method="post" action="/admin/login">
    Username: <input name="username"/><br/>
    Password: <input type="password" name="password"/><br/>
    <button type="submit">Login</button>
</form>
</body>
</html>
