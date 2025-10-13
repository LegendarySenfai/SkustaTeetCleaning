<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Appointment</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/appointment.css">
    
    <!-- ✅ Clean Google Fonts (no extra spaces) -->
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
    <!-- === SAME HEADER AS BOOKING PAGE === -->
    <header>
        <div class="header-left">
            <div class="logo">
                <img src="${pageContext.request.contextPath}/images/dentallogo.png" alt="Dental Clinic Logo">
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

    <main>
        <h1>Edit Appointment</h1>

        <c:if test="${not empty errors}">
            <ul class="error-list">
                <c:forEach var="e" items="${errors}">
                    <li>${e}</li>
                </c:forEach>
            </ul>
        </c:if>

        <form class="edit-form" method="post" action="/appointments/${appt.id}/edit">
            <label>
                <span class="label-text">Dentist:</span>
                <select name="dentistId">
                    <c:forEach var="d" items="${dentists}">
                        <option value="${d.id}" <c:if test="${d.id == appt.dentist.id}">selected</c:if>>
                            ${d.name} <c:if test="${not empty d.specialization}">(${d.specialization})</c:if>
                        </option>
                    </c:forEach>
                </select>
            </label><br/>

            <label>
                <span class="label-text">Services:</span>
                <div class="services-grid">
                    <c:forEach var="s" items="${services}">
                        <label class="service-item">
                            <input type="checkbox" 
                                   name="serviceIds" 
                                   value="${s.id}"
                                   <c:if test="${appt.services.contains(s)}">checked</c:if> /> 
                            ${s.name}
                        </label>
                    </c:forEach>
                </div>
            </label><br/>

            <label>
                <span class="label-text">Date:</span>
                <input type="date" name="date" value="${appt.appointmentDate}" />
            </label>

            <label>
                <span class="label-text">Time:</span>
                <input type="time" name="time" value="${appt.appointmentStart}" />
            </label><br/>

            <button type="submit" class="btn">Save Changes</button>
        </form>
    </main>
</body>
</html>