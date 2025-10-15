<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Appointment Confirmed</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/confirm.css">
</head>
<body>
    <!-- === HEADER === -->
    <header>
        <div class="header-left">
            <div class="logo">
                <img src="${pageContext.request.contextPath}/images/SkustaTeethLogo.png" alt="Dental Clinic Logo">
            </div>
            <nav>
                <a class="homer" href="/SkustaTeeth">Home</a>
                <a class="boker" href="/book">Book an Appointment</a>
                <a class="apointer" href="/myappointments">My Appointments</a>
            </nav>
        </div>
        <div class="user-info">
            Welcome, ${sessionScope.username} | <a href="/logout">Logout</a>
        </div>
    </header>

    <!-- === MAIN CONTENT === -->
    <main class="confirmation-page">
        <div class="confirmation-card">
            <h1>Appointment Confirmed!</h1>
            <p class="success-message">Your appointment has been successfully booked.</p>

            <div class="appointment-details">
                <h2>Appointment Details</h2>
                <p><strong>ID:</strong> ${appt.id}</p>
                <p><strong>Patient:</strong> ${appt.patient.firstName} ${appt.patient.lastName}</p>
                <p><strong>Dentist:</strong> ${appt.dentist.name}</p>
                <p><strong>Date:</strong> ${appt.appointmentDate}</p>
                <p><strong>Time:</strong> ${appt.appointmentStart} – ${appt.appointmentEnd}</p>
                <p><strong>Services:</strong><br/>
                    <c:forEach var="s" items="${appt.services}">
                        • ${s.name}<br/>
                    </c:forEach>
                </p>
            </div>

            <div class="confirmation-actions">
                <a href="/myappointments" class="btn">View My Appointments</a>
                <a href="/book" class="btn btn-secondary">Book Another</a>
            </div>
        </div>
    </main>
</body>
</html>