<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book Appointment</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/appointment.css">	
</head>
<body>
	<header>
	  <div class="header-left">
	    <div class="logo">
	      <img src="${pageContext.request.contextPath}/images/dentallogo.png" alt="Dental Clinic Logo">
	    </div>
	    <nav>
	      <a class="homer" href="/DentalClinic">Home</a>
	      <a class="boker active" href="/book">Book an Appointment</a>
	      <a class="apointer" href="/myappointments">My Appointments</a>
	    </nav>
	  </div>
	  <div class="user-info">
	    Welcome, ${sessionScope.username} | <a href="/logout">Logout</a>
	  </div>
	</header>

    <!-- Display validation errors with styled list -->
    <c:if test="${not empty errors}">
        <ul class="error-list">
            <c:forEach var="e" items="${errors}">
                <li>${e}</li>
            </c:forEach>
        </ul>
    </c:if>

    <main>
        <h1>Book Appointment</h1>

        <form id="bookForm" method="post" action="/book">
            <label>Dentist:
                <select name="dentistId" id="dentistSelect">
                    <option class="inside-box" value="">-- select dentist --</option>
                    <c:forEach var="d" items="${dentists}">
                        <option value="${d.id}">${d.name} (${d.specialization})</option>
                    </c:forEach>
                </select>
            </label><br/>

            <label>Services:<br/>
                <div class="services-grid">
                    <c:forEach var="s" items="${services}">
                        <label class="service-item">
                            <input type="checkbox" name="serviceIds" value="${s.id}" /> ${s.name}
                        </label>
                    </c:forEach>
                </div>
            </label><br/>

            <label>Choose your appointment date: 
                <input type="date" id="dateInput" name="date" value="${selectedDate}"/>
            </label>
            <button type="button" id="showTimesBtn">Select your preferred time</button><br/>

            <div class="time-grid" id="timesArea">
                <!-- Available times will appear here after clicking "Select your preferred time" -->
            </div>

            <input type="hidden" name="time" id="timeInput" />
            <br/>
            <button type="submit">Book</button>
        </form>
    </main>

    <script>
        function buildRadioHtml(time, ok) {
            var disabledAttr = ok ? '' : 'disabled';
            var className = ok ? 'time-item' : 'time-item disabled';
            return '<label class="' + className + '">' +
                   '<input type="radio" name="timeRadio" value="' + time + '" ' + disabledAttr + '/> ' +
                   time +
                   '</label>';
        }

        document.getElementById('showTimesBtn').addEventListener('click', async function () {
            var date = document.getElementById('dateInput').value;
            var dentistId = document.getElementById('dentistSelect').value;
            if (!date) {
                alert('Please pick a date first.');
                return;
            }

            // Build API URL with query parameters
            var url = '/api/available?date=' + encodeURIComponent(date) + '&dentistId=' + (dentistId || '');
            
            try {
                const response = await fetch(url);
                if (!response.ok) {
                    throw new Error(response.statusText);
                }
                const timeSlots = await response.json(); // Expected: ["09:00|true", "10:00|false", ...]

                const timesArea = document.getElementById('timesArea');
                timesArea.innerHTML = '';

                timeSlots.forEach(function(slot) {
                    const [time, available] = slot.split('|');
                    const isAvailable = available === 'true';
                    timesArea.innerHTML += buildRadioHtml(time, isAvailable);
                });

                // Update hidden input when a time is selected
                timesArea.addEventListener('change', function(e) {
                    if (e.target && e.target.name === 'timeRadio') {
                        document.getElementById('timeInput').value = e.target.value;
                    }
                });
            } catch (err) {
                console.error('Error fetching available times:', err);
                alert('Failed to load available times. Please try again.');
            }
        });
    </script>
</body>
</html>