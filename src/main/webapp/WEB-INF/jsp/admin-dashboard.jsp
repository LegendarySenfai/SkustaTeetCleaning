<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-dashboard.css">
</head>
<body>
    <!-- === ADMIN HEADER === -->
	<header class="admin-header">
	    <div class="header-logo">
	        <img src="${pageContext.request.contextPath}/images/dentallogo.png" alt="Dental Clinic Logo">
	    </div>
	    <nav class="header-nav">
	        <a href="/admin/dashboard" class="active">Admin Dashboard</a>
	    </nav>
	    <div class="user-info">
	        Admin | <a href="/admin/logout">Logout</a>
	    </div>
	</header>

    <div class="admin-container">
        <!-- === SIDE NAVIGATION (Tabs) === -->
        <nav class="admin-sidebar">
            <label class="tab-label">
                <input type="radio" name="panel" value="appointments" checked />
                <span>Appointments</span>
            </label>
            <label class="tab-label">
                <input type="radio" name="panel" value="patients" />
                <span>Patients</span>
            </label>
            <label class="tab-label">
                <input type="radio" name="panel" value="dentists" />
                <span>Dentists</span>
            </label>
        </nav>

        <!-- === MAIN CONTENT AREA === -->
        <main class="admin-main">
            <!-- Appointments Panel -->
            <div id="appointmentsPanel" class="panel active">
                <h2>Appointments</h2>
                <c:choose>
                    <c:when test="${empty appts}">
                        <p>No appointments found.</p>
                    </c:when>
                    <c:otherwise>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Patient</th>
                                    <th>Dentist</th>
                                    <th>Date</th>
                                    <th>Time</th>
                                    <th>Services</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="a" items="${appts}">
                                    <tr>
                                        <td>${a.id}</td>
                                        <td>${a.patient.firstName} ${a.patient.lastName}</td>
                                        <td>${a.dentist.name}</td>
                                        <td>${a.appointmentDate}</td>
                                        <td>${a.appointmentStart}</td>
                                        <td>
                                            <c:forEach var="s" items="${a.services}">
                                                ${s.name}<br/>
                                            </c:forEach>
                                        </td>
                                        <td>
                                            <form method="post" action="/admin/appointments/${a.id}/delete" style="display:inline;">
                                                <button type="submit" class="btn-danger" 
                                                        onclick="return confirm('Delete this appointment permanently?')">
                                                    Delete
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Patients Panel -->
            <div id="patientsPanel" class="panel">
                <h2>Patients</h2>
                <c:choose>
                    <c:when test="${empty users}">
                        <p>No patients registered.</p>
                    </c:when>
                    <c:otherwise>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Username</th>
                                    <th>Name</th>
                                    <th>Gender</th>
                                    <th>Age</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="u" items="${users}">
                                    <tr>
                                        <td>${u.id}</td>
                                        <td>${u.username}</td>
                                        <td>${u.firstName} ${u.lastName}</td>
                                        <td>${u.gender}</td>
                                        <td>${u.age}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Dentists Panel -->
            <div id="dentistsPanel" class="panel">
                <h2>Dentists</h2>
                <c:choose>
                    <c:when test="${empty dentists}">
                        <p>No dentists registered.</p>
                    </c:when>
                    <c:otherwise>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Specialization</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="d" items="${dentists}">
                                    <tr>
                                        <td>${d.id}</td>
                                        <td>${d.name}</td>
                                        <td>${d.specialization}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>

    <script>
        // Tab switching logic
        document.querySelectorAll('input[name="panel"]').forEach(radio => {
            radio.addEventListener('change', function() {
                const panelMap = {
                    'appointments': 'appointmentsPanel',
                    'patients': 'patientsPanel',
                    'dentists': 'dentistsPanel'
                };
                const targetId = panelMap[this.value];
                
                // Hide all panels
                document.querySelectorAll('.panel').forEach(panel => {
                    panel.classList.remove('active');
                });
                // Show selected panel
                document.getElementById(targetId).classList.add('active');
            });
        });
    </script>
</body>
</html>