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
                <img src="${pageContext.request.contextPath}/images/SkustaTeethLogo.png" alt="Dental Clinic Logo">
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

    <!-- Script: only affects time slots + service checkbox disabling when date is in the past.
         Keeps fonts/markup untouched. -->
    <script>
    (function() {
        const showBtn = document.getElementById('showTimesBtn');
        const timesArea = document.getElementById('timesArea');
        const dateInput = document.getElementById('dateInput');
        const dentistSelect = document.getElementById('dentistSelect');
        const timeInput = document.getElementById('timeInput');
        const serviceCheckboxes = Array.from(document.querySelectorAll('input[name="serviceIds"]'));
        const initialTime = '<c:out value="${appt.appointmentStart}" />'; // server-side value

        function parseToLocalDate(dateStr, timeStr) {
            if (!dateStr || !timeStr) return null;
            const [hhRaw, mmRaw] = timeStr.split(':');
            const hh = String(hhRaw).padStart(2, '0');
            const mm = String(mmRaw || '00').padStart(2, '0');
            return new Date(dateStr + 'T' + hh + ':' + mm + ':00');
        }

        function isSlotInPast(dateStr, timeStr) {
            const dt = parseToLocalDate(dateStr, timeStr);
            if (!dt) return false;
            // slot <= now considered past/unselectable
            return dt.getTime() <= Date.now();
        }

        function isDateStrictlyBeforeToday(dateStr) {
            if (!dateStr) return false;
            const parts = dateStr.split('-'); // YYYY-MM-DD
            const d = new Date(parseInt(parts[0],10), parseInt(parts[1],10)-1, parseInt(parts[2],10));
            const today = new Date();
            const todayStart = new Date(today.getFullYear(), today.getMonth(), today.getDate());
            return d.getTime() < todayStart.getTime();
        }

        function buildSlotLabel(time, available, selDate) {
            const occupied = (available !== 'true');
            const past = isSlotInPast(selDate, time);
            const disabled = occupied || past;
            const disabledAttr = disabled ? 'disabled' : '';
            const style = disabled ? 'opacity:0.55; cursor:not-allowed; margin-right:8px;' : 'margin-right:8px;';
            const checkedAttr = (!disabled && time === initialTime) ? 'checked' : '';
            return '<label style="' + style + '">' +
                   '<input type="radio" name="timeRadio" value="' + time + '" ' + disabledAttr + ' ' + checkedAttr + '/> ' +
                   time +
                   '</label>';
        }

        async function fetchSlotsFor(date) {
            const dentistId = dentistSelect.value || '';
            const url = '/api/available?date=' + encodeURIComponent(date) + '&dentistId=' + encodeURIComponent(dentistId);
            const resp = await fetch(url);
            if (!resp.ok) throw new Error('Network response was not ok');
            const slots = await resp.json();
            let html = '';
            slots.forEach(s => {
                const [time, available] = s.split('|');
                html += buildSlotLabel(time, available, date);
            });
            return html;
        }

        function attachRadiosListener() {
            timesArea.querySelectorAll('input[name="timeRadio"]').forEach(r => {
                r.addEventListener('change', function(e) {
                    timeInput.value = e.target.value;
                });
            });
        }

        function updateServiceCheckboxes(dateStr) {
            const disable = isDateStrictlyBeforeToday(dateStr);
            serviceCheckboxes.forEach(cb => {
                cb.disabled = disable;
                cb.style.opacity = disable ? '0.55' : '';
                cb.style.cursor = disable ? 'not-allowed' : '';
            });
        }

        showBtn.addEventListener('click', async function() {
            const selDate = dateInput.value;
            if (!selDate) { alert('Please pick a date first.'); return; }

            // toggle
            if (timesArea.style.display === 'block') {
                timesArea.style.display = 'none';
                showBtn.textContent = 'Select your preferred time';
                return;
            }

            try {
                const html = await fetchSlotsFor(selDate);
                timesArea.innerHTML = html;
                timesArea.style.display = 'grid';
                showBtn.textContent = 'Hide available times';
                attachRadiosListener();

                // if the initialTime was checked in the generated HTML it will set hidden input accordingly
                const chosen = timesArea.querySelector('input[name="timeRadio"]:checked');
                if (chosen) timeInput.value = chosen.value;
            } catch (err) {
                console.error('Failed to load times', err);
                alert('Failed to load available times. Please try again.');
            }
        });

        // Hide time area and update services when dentist/date changes
        dentistSelect.addEventListener('change', function() {
            timesArea.style.display = 'none';
            showBtn.textContent = 'Select your preferred time';
        });
        dateInput.addEventListener('change', function() {
            timesArea.style.display = 'none';
            showBtn.textContent = 'Select your preferred time';
            updateServiceCheckboxes(this.value);
        });

        // initial state on page load
        document.addEventListener('DOMContentLoaded', function() {
            if (dateInput.value) updateServiceCheckboxes(dateInput.value);
        });
    })();
    </script>
</body>
</html>
