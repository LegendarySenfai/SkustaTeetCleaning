<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book Appointment</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/appointment.css">	
    
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
	<header>
	  <div class="header-left">
	    <div class="logo">
	      <img src="${pageContext.request.contextPath}/images/dentallogo.png" alt="Dental Clinic Logo">
	    </div>
	    <nav>
	      <a class="homer" href="/SkustaTeeth">Home</a>
	      <a class="boker active" href="/book">Book an Appointment</a>
	      <a class="apointer" href="/myappointments">My Appointments</a>
	    </nav>
	  </div>
	  <div class="user-info">
	    Welcome, ${sessionScope.username} | <a href="/logout">Logout</a>
	  </div>
	</header>

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
            <label>
                <span class="label-text">Dentist:</span>
                <select name="dentistId" id="dentistSelect">
                    <option value="">-- select dentist --</option>
                    <c:forEach var="d" items="${dentists}">
                        <option value="${d.id}">${d.name} (${d.specialization})</option>
                    </c:forEach>
                </select>
            </label><br/>

            <label>
                <span class="label-text">Services:</span>
                <div class="services-grid">
                    <c:forEach var="s" items="${services}">
                        <label class="service-item">
                            <input type="checkbox" name="serviceIds" value="${s.id}" /> ${s.name}
                        </label>
                    </c:forEach>
                </div>
            </label><br/>

            <label>
                <span class="label-text">Choose your appointment date:</span>
                <input type="date" id="dateInput" name="date" value="${selectedDate}"/>
            </label>
            <button type="button" id="showTimesBtn">Select your preferred time</button><br/>

            <div class="time-grid" id="timesArea"></div>

            <input type="hidden" name="time" id="timeInput" />
            <br/>
            <button type="submit">Book</button>
        </form>
    </main>

	<script>
	    let timeSlotsLoaded = false; // Track if we've already fetched time slots
	    let currentTimesHtml = '';   // Cache the generated HTML

	    function buildRadioHtml(time, ok) {
	        var disabledAttr = ok ? '' : 'disabled';
	        var className = ok ? 'time-item' : 'time-item disabled';
	        return '<label class="' + className + '">' +
	               '<input type="radio" name="timeRadio" value="' + time + '" ' + disabledAttr + '/> ' +
	               time +
	               '</label>';
	    }
		
		function formatTo12Hour(time24) {
		    const [hours, minutes] = time24.split(':').map(Number);
		    const period = hours >= 12 ? 'PM' : 'AM';
		    const hours12 = hours % 12 || 12; 
		    return `${hours12}:${minutes.toString().padStart(2, '0')} ${period}`;
		}

	    document.getElementById('showTimesBtn').addEventListener('click', async function () {
	        const timesArea = document.getElementById('timesArea');
			const isCurrentlyVisible = getComputedStyle(timesArea).display !== 'none';

	        if (isCurrentlyVisible) {
	            // Close: hide the time slots
	            timesArea.style.display = 'none';
	            this.textContent = 'Select your preferred time';
	            return;
	        }

	        // Open: show time slots
	        var date = document.getElementById('dateInput').value;
	        if (!date) {
	            alert('Please pick a date first.');
	            return;
	        }

	        // If not loaded yet, fetch and cache
	        if (!timeSlotsLoaded) {
	            var dentistId = document.getElementById('dentistSelect').value;
	            var url = '/api/available?date=' + encodeURIComponent(date) + '&dentistId=' + (dentistId || '');
	            
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

	        // Show cached or newly fetched content
	        timesArea.innerHTML = currentTimesHtml;
	        timesArea.style.display = 'grid'; // matches your .time-grid display
	        this.textContent = 'Hide available times';

	        // Ensure the change listener is attached (only once is enough, but safe to reattach)
	        const handleChange = function(e) {
	            if (e.target && e.target.name === 'timeRadio') {
	                document.getElementById('timeInput').value = e.target.value;
	            }
	        };

	        // Remove previous listener to avoid duplicates, then add
	        timesArea.removeEventListener('change', handleChange);
	        timesArea.addEventListener('change', handleChange);
	    });
	</script>
</body>
</html>