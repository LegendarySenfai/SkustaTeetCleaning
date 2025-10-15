<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Login</title>

  <!-- Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Lato:ital,wght@0,300;0,400;0,700;1,300;1,400;1,700&display=swap" rel="stylesheet">

  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
  
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-login.css">

</head>
<body>
<!-- === ADMIN LOGIN FORM === -->
<div class="background-image"></div>
  <div class="admin-login-container">
    <div class="admin-login-box">
      <h1>Admin Login</h1>
      <p>Sign in to access the Skusta Teeth Dental Clinic admin dashboard.</p>

      <c:if test="${not empty error}">
        <div class="error-message">${error}</div>
      </c:if>

      <form method="post" action="/admin/login">
        <label for="username">Username</label>
        <input type="text" id="username" name="username" placeholder="Enter admin username" required>

        <label for="password">Password</label>
        <input type="password" id="password" name="password" placeholder="Enter password" required>

        <button type="submit" class="btn">Login</button>
      </form>

 
    </div>
  </div>
</body>
</html>