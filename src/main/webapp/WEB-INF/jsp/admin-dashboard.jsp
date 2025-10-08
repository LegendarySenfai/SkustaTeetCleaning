<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Admin Dashboard</title>
    <style>
        #left { float:left; width:200px; }
        #main { margin-left:220px; }
    </style>
</head>
<body>
<h2>Admin Dashboard</h2>
<p><a href="/admin/logout">Logout</a></p>
<div id="left">
    <input type="radio" name="panel" id="p1" checked/> <label for="p1">Appointments</label><br/>
    <input type="radio" name="panel" id="p2"/> <label for="p2">Patients</label><br/>
    <input type="radio" name="panel" id="p3"/> <label for="p3">Dentists</label><br/>
</div>

<div id="main">
    <div id="appointmentsPanel">
        <h3>Appointments</h3>
        <table border="1">
            <tr><th>ID</th><th>Patient</th><th>Dentist</th><th>Date</th><th>Time</th><th>Services</th><th>Actions</th></tr>
            <c:forEach var="a" items="${appts}">
                <tr>
                    <td>${a.id}</td>
                    <td>${a.patient.firstName} ${a.patient.lastName}</td>
                    <td>${a.dentist.name}</td>
                    <td>${a.appointmentDate}</td>
                    <td>${a.appointmentStart}</td>
                    <td><c:forEach var="s" items="${a.services}">${s.name}<br/></c:forEach></td>
                    <td>
                        <form method="post" action="/admin/appointments/${a.id}/delete" style="display:inline">
                            <button type="submit" onclick="return confirm('Delete appointment?')">Delete</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </div>

    <div id="patientsPanel" style="display:none">
        <h3>Patients</h3>
        <table border="1">
            <tr><th>ID</th><th>Username</th><th>Name</th><th>Gender</th><th>Age</th></tr>
            <c:forEach var="u" items="${users}">
                <tr>
                    <td>${u.id}</td>
                    <td>${u.username}</td>
                    <td>${u.firstName} ${u.lastName}</td>
                    <td>${u.gender}</td>
                    <td>${u.age}</td>
                </tr>
            </c:forEach>
        </table>
    </div>

    <div id="dentistsPanel" style="display:none">
        <h3>Dentists</h3>
        <table border="1">
            <tr><th>ID</th><th>Name</th><th>Specialization</th></tr>
            <c:forEach var="d" items="${dentists}">
                <tr>
                    <td>${d.id}</td>
                    <td>${d.name}</td>
                    <td>${d.specialization}</td>
                </tr>
            </c:forEach>
        </table>
    </div>
</div>

<script>
    const p1 = document.getElementById('p1'), p2 = document.getElementById('p2'), p3 = document.getElementById('p3');
    p1.addEventListener('change', () => { show('appointmentsPanel'); });
    p2.addEventListener('change', () => { show('patientsPanel'); });
    p3.addEventListener('change', () => { show('dentistsPanel'); });
    function show(id) {
        document.getElementById('appointmentsPanel').style.display = id==='appointmentsPanel' ? 'block' : 'none';
        document.getElementById('patientsPanel').style.display = id==='patientsPanel' ? 'block' : 'none';
        document.getElementById('dentistsPanel').style.display = id==='dentistsPanel' ? 'block' : 'none';
    }
</script>
</body>
</html>
