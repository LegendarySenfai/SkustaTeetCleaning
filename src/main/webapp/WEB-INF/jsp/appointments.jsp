<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>My Appointments</title>
    <style>
        /* tiny style so empty action cells look OK */
        .empty-action { color: #999; }
        .btn { padding: 6px 10px; border-radius:4px; background:#2d9cdb; color:white; text-decoration:none; margin-right:8px; }
        .btn-ghost { background:transparent; color:#2d9cdb; border:1px solid #2d9cdb; }
    </style>
</head>
<body>
<h2>My Appointments</h2>

<!-- Add "Create New Booking" only if user has no active appointment -->
<c:if test="${not hasActiveAppointment}">
    <a href="/book" class="btn">Create New Booking</a>
</c:if>

<!-- Always allow logout -->
<a href="/logout" class="btn btn-ghost">Logout</a>

<br/><br/>

<table border="1" cellpadding="6" cellspacing="0">
    <thead>
        <tr>
            <th>ID</th>
            <th>Date</th>
            <th>Time</th>
            <th>Dentist</th>
            <th>Services</th>
            <th>Status</th>
            <th>Actions</th> <!-- header kept, but rows may be empty when cancelled -->
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
                    <c:forEach var="s" items="${a.services}">${s.name}<br/></c:forEach>
                </td>
                <td>${a.status}</td>

                <!-- Actions cell: only show buttons if appointment is NOT CANCELLED -->
                <td>
                    <c:choose>
                        <c:when test="${a.status != 'CANCELLED'}">
                            <a href="/appointments/${a.id}/edit">Update</a>
                            |
                            <form method="get" action="/appointments/${a.id}/cancel-request" style="display:inline">
                                <button type="submit" onclick="return confirm('Send cancellation OTP to your email?')">Cancel</button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <!-- empty cell: nothing to do for cancelled appointment -->
                            <span class="empty-action">&nbsp;</span>
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>

</body>
</html>
