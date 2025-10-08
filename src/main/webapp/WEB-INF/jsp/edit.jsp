<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head><title>Edit Appointment</title></head>
<body>
<h2>Edit Appointment</h2>
<c:if test="${not empty errors}">
    <ul style="color:red">
        <c:forEach var="e" items="${errors}"><li>${e}</li></c:forEach>
    </ul>
</c:if>

<form method="post" action="/appointments/${appt.id}/edit">
    <label>Dentist:
        <select name="dentistId">
            <c:forEach var="d" items="${dentists}">
                <option value="${d.id}" <c:if test="${d.id == appt.dentist.id}">selected</c:if>>${d.name}</option>
            </c:forEach>
        </select>
    </label><br/>

    <label>Services:<br/>
        <c:forEach var="s" items="${services}">
            <input type="checkbox" name="serviceIds" value="${s.id}"
                <c:if test="${appt.services.contains(s)}">checked</c:if>/> ${s.name}<br/>
        </c:forEach>
    </label><br/>

    <label>Date: <input type="date" name="date" value="${appt.appointmentDate}"/></label>
    <label>Time: <input type="time" name="time" value="${appt.appointmentStart}"/></label><br/>

    <button type="submit">Save</button>
</form>
</body>
</html>
