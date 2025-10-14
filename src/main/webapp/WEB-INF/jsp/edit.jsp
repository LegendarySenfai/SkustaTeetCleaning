<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Appointment</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/appointment.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
	
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
                <select name="dentistId" id="dentistSelect">
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
                <input type="date" name="date" id="dateInput" value="${appt.appointmentDate}" />
            </label>

            <!-- ✅ TIME SECTION: IDENTICAL TO BOOK.JSP, WITH PRE-SELECTION -->
            <button type="button" id="showTimesBtn">Select your preferred time</button><br/>
            <div class="time-grid" id="timesArea"></div>
            <input type="hidden" name="time" id="timeInput" value="${appt.appointmentStart}" />

            <br/>
            <button type="submit" class="btn">Save Changes</button>
        </form>
    </main>

    <!-- ✅ SCRIPT: COPY OF BOOK.JSP, WITH MINIMAL EDIT FOR PRE-SELECTION -->
    <script>
        let timeSlotsLoaded = false;
        let currentTimesHtml = '';
        const initialTime = "${appt.appointmentStart}"; // Pre-selected time

        function buildRadioHtml(time, ok) {
            var disabledAttr = ok ? '' : 'disabled';
            var checkedAttr = (time === initialTime) ? 'checked' : '';
            var className = ok ? 'time-item' : 'time-item disabled';
            return '<label class="' + className + '">' +
                   '<input type="radio" name="timeRadio" value="' + time + '" ' + disabledAttr + ' ' + checkedAttr + '/> ' +
                   time +
                   '</label>';
        }

        document.getElementById('showTimesBtn').addEventListener('click', async function () {
            const timesArea = document.getElementById('timesArea');
			const isCurrentlyVisible = getComputedStyle(timesArea).display !== 'none';

            if (isCurrentlyVisible) {
                timesArea.style.display = 'none';
                this.textContent = 'Select your preferred time';
                return;
            }

            var date = document.getElementById('dateInput').value;
            if (!date) {
                alert('Please pick a date first.');
                return;
            }

            var dentistId = document.getElementById('dentistSelect').value;
            if (!dentistId) {
                alert('Please select a dentist first.');
                return;
            }

            if (!timeSlotsLoaded) {
                var url = '/api/available?date=' + encodeURIComponent(date) + '&dentistId=' + encodeURIComponent(dentistId);
                try {
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(response.statusText);
                    }
                    const timeSlots = await response.json();

                    currentTimesHtml = '';
                    timeSlots.forEach(function(slot) {
                        const [time, available] = slot.split('|');
                        const isAvailable = available === 'true';
                        currentTimesHtml += buildRadioHtml(time, isAvailable);
                    });

                    timeSlotsLoaded = true;
                } catch (err) {
                    console.error('Error fetching available times:', err);
                    alert('Failed to load available times. Please try again.');
                    return;
                }
            }

            timesArea.innerHTML = currentTimesHtml;
            timesArea.style.display = 'grid';
            this.textContent = 'Hide available times';

            const handleChange = function(e) {
                if (e.target && e.target.name === 'timeRadio') {
                    document.getElementById('timeInput').value = e.target.value;
                }
            };

            timesArea.removeEventListener('change', handleChange);
            timesArea.addEventListener('change', handleChange);
        });
    </script>
</body>
</html>