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
          <img src="${pageContext.request.contextPath}/images/SkustaTeethLogo.png" alt="Dental Clinic Logo">
        </div>
        <nav>
          <a class="homer" href="/SkustaTeeth">Home</a>
          <a class="boker active" href="/book">Book an Appointment</a>
          <a class="apointer" href="/myappointments">My Appointments</a>
        </nav>
      </div>
      <div class="user-info">
  <c:choose>
    <c:when test="${not empty sessionScope.username}">
      <div class="dropdown">
        <button class="dropbtn">Hi, ${sessionScope.username} <i class="fa fa-caret-down"></i></button>
        <div class="dropdown-content">
          <a href="${pageContext.request.contextPath}/logout">Logout</a>
          <a href="#" id="deleteAccountLink">Delete Account</a>
        </div>
      </div>
    </c:when>
    <c:otherwise>
      <a href="${pageContext.request.contextPath}/login">Login</a>
    </c:otherwise>
  </c:choose>
</div>

<script>
  // Delete Account confirmation
  document.addEventListener('DOMContentLoaded', function() {
    const deleteLink = document.getElementById('deleteAccountLink');
    if (deleteLink) {
      deleteLink.addEventListener('click', function(e) {
        e.preventDefault();
        if (confirm("Are you sure you want to delete your account?")) {
          window.location.href = "${pageContext.request.contextPath}/account-delete";
        }
      });
    }
  });
</script>

<style>
/* Simple dropdown styling */
.dropdown {
  position: relative;
  display: inline-block;
}

.dropbtn {
  background-color: transparent;
  color: #333;
  font-weight: bold;
  border: none;
  cursor: pointer;
  font-family: 'Lato', sans-serif;
}

.dropbtn i {
  margin-left: 5px;
}

.dropdown-content {
  display: none;
  position: absolute;
  right: 0;
  background-color: white;
  min-width: 160px;
  box-shadow: 0px 8px 16px rgba(0,0,0,0.2);
  z-index: 1000;
  border-radius: 8px;
}

.dropdown-content a {
  color: #333;
  padding: 10px 16px;
  text-decoration: none;
  display: block;
}

.dropdown-content a:hover {
  background-color: #f1f1f1;
}

.dropdown:hover .dropdown-content {
  display: block;
}
</style>
      
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
                <div class="services-grid" id="servicesArea">
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
        // --- new behavior: disable past slots (and occupied slots remain disabled) ---
        // cache keyed by date + dentist to avoid stale disabled state
        let cacheHtml = '';
        let cacheDate = '';
        let cacheDent = '';

        function parseTimeToDate(dateStr, timeStr) {
            // dateStr - "YYYY-MM-DD", timeStr - "HH:mm" (24h)
            if (!dateStr || !timeStr) return null;
            const hhmm = timeStr.split(':');
            const hh = hhmm[0].padStart(2,'0');
            const mm = (hhmm.length>1)?hhmm[1].padStart(2,'0'):'00';
            return new Date(dateStr + 'T' + hh + ':' + mm + ':00');
        }

        function isSlotInPast(dateStr, timeStr) {
            const slot = parseTimeToDate(dateStr, timeStr);
            if (!slot) return false;
            // treat slot <= now as in the past (can't pick)
            return slot.getTime() <= Date.now();
        }

        function buildRadioHtml(time, available, selDate) {
            const occupied = (available !== 'true');
            const past = isSlotInPast(selDate, time);
            const disabled = occupied || past;
            const disabledAttr = disabled ? 'disabled' : '';
            const css = disabled ? 'opacity:0.55; cursor:not-allowed; margin-right:8px;' : 'margin-right:8px;';
            return '<label style="' + css + '">' +
                   '<input type="radio" name="timeRadio" value="' + time + '" ' + disabledAttr + '/> ' +
                   time +
                   '</label>';
        }

        async function fetchTimesFor(date) {
            const dentistId = document.getElementById('dentistSelect').value || '';
            const url = '/api/available?date=' + encodeURIComponent(date) + '&dentistId=' + encodeURIComponent(dentistId);
            const resp = await fetch(url);
            if (!resp.ok) throw new Error(resp.statusText);
            const slots = await resp.json();
            let html = '';
            slots.forEach(s => {
                const [time, available] = s.split('|');
                html += buildRadioHtml(time, available, date);
            });
            return html;
        }

        const showBtn = document.getElementById('showTimesBtn');
        const timesArea = document.getElementById('timesArea');
        const dateInput = document.getElementById('dateInput');
        const dentistSelect = document.getElementById('dentistSelect');

        function attachChangeHandler() {
            timesArea.querySelectorAll('input[name="timeRadio"]').forEach(r => {
                r.addEventListener('change', function(e){
                    document.getElementById('timeInput').value = e.target.value;
                });
            });
        }

        showBtn.addEventListener('click', async function () {
            const isCurrentlyVisible = getComputedStyle(timesArea).display !== 'none';
            if (isCurrentlyVisible) {
                timesArea.style.display = 'none';
                this.textContent = 'Select your preferred time';
                return;
            }

            const date = dateInput.value;
            if (!date) {
                alert('Please pick a date first.');
                return;
            }

            try {
                // cache keyed by date & dentist
                if (!cacheHtml || cacheDate !== date || cacheDent !== dentistSelect.value) {
                    cacheHtml = await fetchTimesFor(date);
                    cacheDate = date;
                    cacheDent = dentistSelect.value;
                }
                timesArea.innerHTML = cacheHtml;
                timesArea.style.display = 'grid';
                this.textContent = 'Hide available times';
                attachChangeHandler();
            } catch (err) {
                console.error('Error fetching available times:', err);
                alert('Failed to load available times. Please try again.');
                return;
            }
        });

        // clear cache when dentist or date changes
        dentistSelect.addEventListener('change', function(){ cacheHtml = ''; cacheDent = dentistSelect.value; timesArea.style.display = 'none'; showBtn.textContent='Select your preferred time'; });
        dateInput.addEventListener('change', function(){ cacheHtml = ''; cacheDate = ''; timesArea.style.display = 'none'; showBtn.textContent='Select your preferred time'; });
    </script>
</body>
</html>
