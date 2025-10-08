<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head><title>Appointment Confirmed</title></head>
<body>
<h2>Appointment Successful</h2>
<p>Your appointment has been created.</p>
<p><a href="/myappointments">View My Appointments</a> | <a href="/book">Book Another</a></p>

<h3>Details</h3>
<p>Appointment ID: ${appt.id}</p>
<p>Patient: ${appt.patient.firstName} ${appt.patient.lastName}</p>
<p>Dentist: ${appt.dentist.name}</p>
<p>Date: ${appt.appointmentDate}</p>
<p>Time: ${appt.appointmentStart} - ${appt.appointmentEnd}</p>
<p>Services:
    <c:forEach var="s" items="${appt.services}">
        ${s.name}<br/>
    </c:forEach>
</p>
</body>
</html>
