<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Appointment (Admin)</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-edit-appointment.css">

    <!-- Fonts & Icons -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@300;400;700&family=Playfair+Display:wght@500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</head>
<body>
    <!-- === ADMIN HEADER === -->
    <header>
        <div class="header-left">
            <div class="logo">
                <img src="${pageContext.request.contextPath}/images/SkustaTeethLogo.png" alt="Dental Clinic Logo">
            </div>

            <c:if test="${not empty errors}">
                <ul style="color:red;">
                    <c:forEach var="e" items="${errors}">
                        <li>${e}</li>
                    </c:forEach>
                </ul>
            </c:if>
        </div>
        <div class="user-info">
            Admin | <a href="/admin/login">Logout</a>
        </div>
    </header>

    <main>
        <h1>Edit Appointment (Admin)</h1>
        <form class="edit-form" method="post" action="/admin/updateAppointment">
            <input type="hidden" name="id" value="${appt.id}" />

            <label>
                <span class="label-text">Patient:</span>
                <c:choose>
                    <c:when test="${not empty appt.patient}">
                        ${appt.patient.firstName} ${appt.patient.lastName}
                    </c:when>
                    <c:otherwise>(no patient)</c:otherwise>
                </c:choose>
            </label>

            <label>
                <span class="label-text">Dentist:</span>
                <select name="dentistId" id="dentistSelect">
                    <option value="">-- select dentist --</option>
                    <c:forEach var="d" items="${dentists}">
                        <option value="${d.id}" <c:if test="${d.id == appt.dentist.id}">selected</c:if>>
                            ${d.name}<c:if test="${not empty d.specialization}"> (${d.specialization})</c:if>
                        </option>
                    </c:forEach>
                </select>
            </label>

            <label>
                <span class="label-text">Services:</span>
                <div class="services-grid" id="servicesArea">
                    <c:forEach var="s" items="${services}">
                        <label class="service-item">
                            <input type="checkbox" name="serviceIds" value="${s.id}" <c:if test="${appt.services.contains(s)}">checked</c:if> />
                            ${s.name}
                        </label>
                    </c:forEach>
                </div>
            </label>

            <label>
                <span class="label-text">Date:</span>
                <input type="date" id="dateInput" name="date" value="${appt.appointmentDate}" />
            </label>

            <!-- ✅ FIXED: Only one hidden input for time -->
            <input type="hidden" id="timeInput" name="time" value="${appt.appointmentStart}" />

            <label>
                <span class="label-text">Status:</span>
                <select name="status">
                    <option value="">(leave unchanged)</option>
                    <option value="PENDING" <c:if test="${appt.status == 'PENDING'}">selected</c:if>>PENDING</option>
                    <option value="COMPLETED" <c:if test="${appt.status == 'COMPLETED'}">selected</c:if>>COMPLETED</option>
                    <option value="CANCELLED" <c:if test="${appt.status == 'CANCELLED'}">selected</c:if>>CANCELLED</option>
                    <option value="NO SHOW" <c:if test="${appt.status == 'NO SHOW'}">selected</c:if>>NO SHOW</option>
                </select>
            </label>

            <button type="button" id="showTimesBtn" class="btn">Select your preferred time</button><br/>
            <div class="time-grid" id="timesArea"></div>

            <div class="button-row">
                <button type="submit" class="btn"><i class="fa-solid fa-floppy-disk"></i> Save Changes</button>
                <a href="/admin/dashboard" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </main>

    <script>
    (function() {
        const showBtn = document.getElementById('showTimesBtn');
        const timesArea = document.getElementById('timesArea');
        const dateInput = document.getElementById('dateInput');
        const dentistSelect = document.getElementById('dentistSelect');
        const timeInput = document.getElementById('timeInput');
        const initialTime = '<c:out value="${appt.appointmentStart}" />';

        function parseToLocalDate(dateStr, timeStr) {
            if (!dateStr || !timeStr) return null;
            const [hhRaw, mmRaw] = timeStr.split(':');
            const hh = String(hhRaw).padStart(2, '0');
            const mm = String(mmRaw || '00').padStart(2, '0');
            return new Date(dateStr + 'T' + hh + ':' + mm + ':00');
        }

        function isSlotInPast(dateStr, timeStr) {
            const dt = parseToLocalDate(dateStr, timeStr);
            return dt && dt.getTime() <= Date.now();
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

        showBtn.addEventListener('click', async function() {
            const selDate = dateInput.value;
            if (!selDate) { alert('Please pick a date first.'); return; }

            if (timesArea.style.display === 'grid') {
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

                const chosen = timesArea.querySelector('input[name="timeRadio"]:checked');
                if (chosen) timeInput.value = chosen.value;
            } catch (err) {
                console.error('Failed to load times', err);
                alert('Failed to load available times. Please try again.');
            }
        });

        dentistSelect.addEventListener('change', function() {
            timesArea.style.display = 'none';
            showBtn.textContent = 'Select your preferred time';
        });
        dateInput.addEventListener('change', function() {
            timesArea.style.display = 'none';
            showBtn.textContent = 'Select your preferred time';
        });
    })();
    </script>
</body>
</html>
