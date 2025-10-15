<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dental Clinic | Sign Up</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/register.css">
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
	    <img src="${pageContext.request.contextPath}/images/SkustaTeethLogo.png" alt="Dental Clinic Logo">
	  </div>
	  <nav class="header-nav">
	    <a href="/DentalClinic">Home</a>
	    <a href="/DentalClinic#services">Services</a>
	    <a href="/book">Book an Appointment</a>
	    <a href="/DentalClinic#contact">Contact Us</a>
	    <a href="/DentalClinic#about">About Us</a>
	  </nav>
	</header>
	
  <div class="signup-container">


    <div class="signup-right">
      <div class="form-box">
        <h1>Create an Account</h1>
		
		<!-- Error Message -->
		<div class="error-container">
		  <c:if test="${not empty error}">
		    <div class="error-message">${error}</div>
		  </c:if>
		</div>

        <form method="post" action="/register">
          <div class="name-row">
            <input type="text" name="firstName" placeholder="First Name" required>
            <input type="text" name="lastName" placeholder="Last Name" required>
          </div>
		  
		  <input type="email" name="email" placeholder="Email" required> 
          <input type="text" name="username" placeholder="Username" required>
          <input type="password" name="password" placeholder="Password" required>
		  <input type="number" name="age" placeholder="Age" min="0" max="200" required>

          <select name="gender" required>
            <option value="">Select Gender</option>
            <option value="Male">Male</option>
            <option value="Female">Female</option>
            <option value="Other">Other</option>
          </select>



          <button type="submit" class="btn">Sign Up</button>
        </form>

        <p class="signin-text">
          Already have an account? <a href="/login">Sign In</a>
        </p>
      </div>
    </div>
  </div>

</body>
</html>