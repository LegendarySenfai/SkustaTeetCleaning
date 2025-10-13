<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Confirm Registration</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/register-confirm.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
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
  <div class="background-image"></div>
  <div class="confirm-container">

    <div class="confirm-header">
      
      <h1>Confirm Registration</h1>
    </div>

    <p class="confirm-subtitle">Enter the code sent to your email.</p>

    <c:if test="${not empty error}">
      <div class="message-error">${error}</div>
    </c:if>
    <c:if test="${not empty msg}">
      <div class="message-success">${msg}</div>
    </c:if>

    <div class="otp-card">
      <form method="post" action="/register/confirm">
        <div class="otp-input-wrapper">
          <input type="text" name="code" class="otp-input" placeholder="_____" required />
          <span class="email-icon">
            <i class="fa-solid fa-envelope"></i>
          </span>
        </div>

        <p class="instructions">
          Enter the code from your email address at:
          <br/>
          <a>user@example.com</a>
        </p>

        <button type="submit" class="confirm-btn">Confirm</button>
      </form>
    </div>

    <!-- Footer Link -->
    <p class="footer-link">
      Didn’t receive the code? <a href="/register">Re-register</a> or contact admin.
    </p>

  </div>

</body>
</html>