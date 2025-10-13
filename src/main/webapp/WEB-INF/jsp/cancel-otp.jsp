<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cancel Appointment - OTP</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cancel-otp.css">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:ital,wght@0,300;0,400;0,700;1,300;1,400;1,700&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</head>
<body>

    <div class="background-image"></div>

    <div class="confirm-container">
        <div class="confirm-header">
            <h1>Cancel Appointment</h1>
        </div>

        <p class="confirm-subtitle">Enter the OTP sent to your email to confirm cancellation.</p>

        <c:if test="${not empty error}">
            <div class="message-error">${error}</div>
        </c:if>
        <c:if test="${not empty msg}">
            <div class="message-success">${msg}</div>
        </c:if>
		
        <form method="post" action="/appointments/${appointmentId}/cancel-confirm">
            <div class="otp-card">
                <div class="otp-input-wrapper">
                    <input 
                        type="text" 
                        name="code" 
                        class="otp-input" 
                        placeholder="______"
                        maxlength="6"
                        inputmode="numeric"
                        required
                    />
                    <i class="fas fa-envelope email-icon"></i>
                </div>
            </div>

            <button type="submit" class="confirm-btn">Confirm Cancellation</button>
        </form>

        <div class="footer-link">
            <a href="/myappointments">
                <i class="fas fa-arrow-left"></i> Back to My Appointments
            </a>
        </div>
    </div>
</body>
</html>