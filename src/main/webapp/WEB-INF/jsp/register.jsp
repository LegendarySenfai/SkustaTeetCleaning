<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head><title>Register</title></head>
<body>
<h2>Register</h2>
<c:if test="${not empty error}"><p style="color:red">${error}</p></c:if>
<form method="post" action="/register">
    Username: <input name="username"/><br/>
    Password: <input type="password" name="password"/><br/>
    First Name: <input name="firstName"/><br/>
    Last Name: <input name="lastName"/><br/>
    Email: <input name="email"/><br/>
    
    Gender:
    <select name="gender">
        <option value="">Select</option>
        <option>Male</option><option>Female</option><option>Other</option>
    </select><br/>
    Age: <input type="number" name="age" min="0" max="200"/><br/>
    <button type="submit">Register</button>
</form>
<p>Already have account? <a href="/login">Login</a></p>
</body>
</html>
