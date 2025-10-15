<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dental Clinic | Login</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Lato:ital,wght@0,300;0,400;0,700;1,300;1,400;1,700&display=swap" rel="stylesheet">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Crimson+Pro:ital,wght@0,400;0,600;0,700;1,400;1,600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</head>
<body>
	<header>
	  <div class="header-logo">
	    <img src="${pageContext.request.contextPath}/images/dentallogo.png" alt="Dental Clinic Logo">
	  </div>
	  <nav class="header-nav">
	    <a href="/DentalClinic">Home</a>
	    <a href="/DentalClinic#services">Services</a>
	    <a href="/book">Book an Appointment</a>
	    <a href="/DentalClinic#contact">Contact Us</a>
	    <a href="/DentalClinic#about">About Us</a>
	  </nav>
	</header>

  <div class="login-container">
    <!-- RIGHT SECTION -->
    <div class="login-right">
      <div class="login-box">
        <h1>Welcome!</h1>
        <p>Log in to set an appointment.</p>

        <!-- Error & Success Messages -->
        <c:if test="${not empty error}">
          <div class="error-message">${error}</div>
        </c:if>
        <c:if test="${not empty msg}">
          <div class="success-message">${msg}</div>
        </c:if>

        <form method="post" action="/login">
          <label for="username">Username</label>
          <input type="text" id="username" name="username" placeholder="Enter your username" required>

          <label for="password">Password</label>
          <input type="password" id="password" name="password" placeholder="Enter your password" required>

          <button type="submit" class="btn">Login</button>
        </form>

        <p class="signup-text">
          New user? <a href="/register">Sign Up</a>
        </p>
        <p><a href="${pageContext.request.contextPath}/forgot-password">Forgot your password?</a></p>
      </div>
    </div>
  </div>

</body>
</html>