<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head><title>Cancel Appointment - OTP</title></head>
<body>
<h2>Cancel Appointment - OTP Confirmation</h2>
<c:if test="${not empty error}"><p style="color:red">${error}</p></c:if>
<c:if test="${not empty msg}"><p style="color:green">${msg}</p></c:if>

<form method="post" action="/appointments/${appointmentId}/cancel-confirm">
    Enter OTP sent to your email: <input name="code" /><br/>
    <button type="submit">Confirm Cancel</button>
</form>

<p><a href="/myappointments">Back to My Appointments</a></p>
</body>
</html>
