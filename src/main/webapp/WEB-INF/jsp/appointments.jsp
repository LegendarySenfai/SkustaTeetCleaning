<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Appointments</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/myappointment.css">
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
    <!-- === HEADER === -->
    <header>
        <div class="header-left">
            <div class="logo">
                <img src="${pageContext.request.contextPath}/images/SkustaTeethLogo.png" alt="Dental Clinic Logo">
            </div>
            <nav>
                <a class="homer" href="/DentalClinic">Home</a>
                <!-- Conditionally show Book link only if no active appointment -->
                <c:if test="${not hasActiveAppointment}">
                    <a class="boker" href="/book">Book an Appointment</a>
                </c:if>
                <a class="apointer active" href="/myappointments">My Appointments</a>
            </nav>
        </div>
        <div class="user-info">
  <c:choose>
    <c:when test="${not empty sessionScope.username}">
      <div class="dropdown">
        <button class="dropbtn">Hi, ${sessionScope.username} <i class="fa fa-caret-down"></i></button>
        <div class="dropdown-content">
          <a href="${pageContext.request.contextPath}/logout">Logout</a>
          <a href="#" id="deleteAccountLink">Delete Account</a>
        </div>
      </div>
    </c:when>
    <c:otherwise>
      <a href="${pageContext.request.contextPath}/login">Login</a>
    </c:otherwise>
  </c:choose>
</div>

<script>
  // Delete Account confirmation
  document.addEventListener('DOMContentLoaded', function() {
    const deleteLink = document.getElementById('deleteAccountLink');
    if (deleteLink) {
      deleteLink.addEventListener('click', function(e) {
        e.preventDefault();
        if (confirm("Are you sure you want to delete your account?")) {
          window.location.href = "${pageContext.request.contextPath}/account-delete";
        }
      });
    }
  });
</script>

<style>
/* Simple dropdown styling */
.dropdown {
  position: relative;
  display: inline-block;
}

.dropbtn {
  background-color: transparent;
  color: #333;
  font-weight: bold;
  border: none;
  cursor: pointer;
  font-family: 'Lato', sans-serif;
}

.dropbtn i {
  margin-left: 5px;
}

.dropdown-content {
  display: none;
  position: absolute;
  right: 0;
  background-color: white;
  min-width: 160px;
  box-shadow: 0px 8px 16px rgba(0,0,0,0.2);
  z-index: 1000;
  border-radius: 8px;
}

.dropdown-content a {
  color: #333;
  padding: 10px 16px;
  text-decoration: none;
  display: block;
}

.dropdown-content a:hover {
  background-color: #f1f1f1;
}

.dropdown:hover .dropdown-content {
  display: block;
}
</style>
        
    </header>

    <main>
        <h1>My Appointments</h1>

    </main>

    <!-- Appointments Table -->
    <c:if test="${not empty appointments}">
        <div class="appointments-table-container">
            <table class="appointments-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Date</th>
                        <th>Time</th>
                        <th>Dentist</th>
                        <th>Services</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="a" items="${appointments}">
                        <tr>
                            <td>${a.id}</td>
                            <td>${a.appointmentDate}</td>
                            <td>${a.appointmentStart}</td>
                            <td>${a.dentist.name}</td>
                            <td>
                                <c:forEach var="s" items="${a.services}">
                                    ${s.name}<br/>
                                </c:forEach>
                            </td>
							<td>${a.status}</td>
							<td>
							    <c:choose>
							        <c:when test="${a.status eq 'PENDING'}">
							            <a href="/appointments/${a.id}/edit" class="active-link">Update</a> |
							            <a href="/appointments/${a.id}/cancel-request"
							               class="cancel-link"
							               onclick="return confirm('Send cancellation OTP to your email?')">
							               Cancel
							            </a>
							        </c:when>
							        <c:otherwise>
							            <span style="color: gray; text-decoration: none;">Update</span> |
							            <span style="color: gray; text-decoration: none;">Cancel</span>
							        </c:otherwise>
							    </c:choose>
							</td>

                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>

    <!-- No appointments message -->
    <c:if test="${empty appointments}">
        <main>
            <p class="noappoint">You have no appointments yet.</p>
            <c:if test="${not hasActiveAppointment}">
  
            </c:if>
        </main>
    </c:if>

    <!-- Optional: Back to booking (only if not already shown prominently) -->
    <div class="appointments-table-container" style="text-align: center; margin-top: 20px;">
        <p><a href="/book" class="back-link">← Back to Booking</a></p>
    </div>

</body>
</html>