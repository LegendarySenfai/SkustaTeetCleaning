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
<<<<<<< HEAD
    <!-- === ADMIN HEADER === -->
    <header>
        <div class="header-left">
            <div class="logo">
                <img src="${pageContext.request.contextPath}/images/SkustaTeethLogo.png" alt="Dental Clinic Logo">
=======
    <h1>Edit Appointment (Admin)</h1>

    <c:if test="${not empty errors}">
        <ul style="color:red;">
            <c:forEach var="e" items="${errors}">
                <li>${e}</li>
            </c:forEach>
        </ul>
    </c:if>

    <form method="post" action="/admin/updateAppointment">
        <input type="hidden" name="id" value="${appt.id}" />

        <label>
            Patient:
            <c:choose>
                <c:when test="${not empty appt.patient}">
                    ${appt.patient.firstName} ${appt.patient.lastName}
                </c:when>
                <c:otherwise>
                    (no patient)
                </c:otherwise>
            </c:choose>
        </label>
        <br/><br/>

        <label>
            Dentist:
            <select name="dentistId" id="dentistSelect">
                <option value="">-- select dentist --</option>
                <c:forEach var="d" items="${dentists}">
                    <option value="${d.id}" <c:if test="${d.id == appt.dentist.id}">selected</c:if>>
                        ${d.name}<c:if test="${not empty d.specialization}"> (${d.specialization})</c:if>
                    </option>
                </c:forEach>
            </select>
        </label>
        <br/><br/>

        <label>
            Services:
            <div id="servicesArea">
                <c:forEach var="s" items="${services}">
                    <label>
                        <input type="checkbox" name="serviceIds" value="${s.id}" <c:if test="${appt.services.contains(s)}">checked</c:if> />
                        ${s.name}
                    </label><br/>
                </c:forEach>
>>>>>>> branch 'main' of https://github.com/LegendarySenfai/SkustaTeetCleaning.git
            </div>
        </div>
        <div class="user-info">
            Admin | <a href="/logout">Logout</a>
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

<<<<<<< HEAD
        <form class="edit-form" method="post" action="/admin/updateAppointment">
            <input type="hidden" name="id" value="${appt.id}" />
=======
        <input type="hidden" id="timeInput" name="time" value="<c:out value='${appt.appointmentStart}'/>" />
        <br/><br/>
>>>>>>> branch 'main' of https://github.com/LegendarySenfai/SkustaTeetCleaning.git

<<<<<<< HEAD
            <label>
                <span class="label-text">Patient:</span>
                <c:choose>
                    <c:when test="${not empty appt.patient}">
                        ${appt.patient.firstName} ${appt.patient.lastName}
                    </c:when>
                    <c:otherwise>(no patient)</c:otherwise>
                </c:choose>
            </label>
=======
        <label>
            Status:
            <select name="status">
                <option value="">(leave unchanged)</option>
                <option value="PENDING" <c:if test="${appt.status == 'PENDING'}">selected</c:if>>PENDING</option>
                <option value="COMPLETED" <c:if test="${appt.status == 'COMPLETED'}">selected</c:if>>COMPLETED</option>
                <option value="CANCELLED" <c:if test="${appt.status == 'CANCELLED'}">selected</c:if>>CANCELLED</option>
                <option value="NO SHOW" <c:if test="${appt.status == 'NO SHOW'}">selected</c:if>>NO SHOW</option>
            </select>
        </label>
        <br/><br/>
>>>>>>> branch 'main' of https://github.com/LegendarySenfai/SkustaTeetCleaning.git

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
                            <input type="checkbox" name="serviceIds" value="${s.id}"
                                   <c:if test="${appt.services.contains(s)}">checked</c:if> />
                            ${s.name}
                        </label>
                    </c:forEach>
                </div>
            </label>

            <label>
                <span class="label-text">Date:</span>
                <input type="date" id="dateInput" name="date" value="${appt.appointmentDate}" />
            </label>

            <button type="button" id="showTimesBtn" class="btn">Select Available Time</button>
            <div class="time-grid" id="timesArea"></div>
            <input type="hidden" id="timeInput" name="time" value="${appt.appointmentStart}" />

            <label>
                <span class="label-text">Status:</span>
                <select name="status">
                    <option value="">(leave unchanged)</option>
                    <option value="PENDING" <c:if test="${appt.status == 'PENDING'}">selected</c:if>>PENDING</option>
                    <option value="COMPLETED" <c:if test="${appt.status == 'COMPLETED'}">selected</c:if>>COMPLETED</option>
                    <option value="CANCELLED" <c:if test="${appt.status == 'CANCELLED'}">selected</c:if>>CANCELLED</option>
                </select>
            </label>

            <div class="button-row">
                <button type="submit" class="btn"><i class="fa-solid fa-floppy-disk"></i> Save Changes</button>
                <a href="/admin/dashboard" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </main>

<<<<<<< HEAD
    <script>
        (function(){
            const showBtn = document.getElementById('showTimesBtn');
            const timesArea = document.getElementById('timesArea');
            const dateInput = document.getElementById('dateInput');
            const dentistSelect = document.getElementById('dentistSelect');
            const timeInput = document.getElementById('timeInput');
            const initialTime = "${appt.appointmentStart}";
=======
<script>
(function(){
    const showBtn = document.getElementById('showTimesBtn');
    const timesArea = document.getElementById('timesArea');
    const dateInput = document.getElementById('dateInput');
    const dentistSelect = document.getElementById('dentistSelect');
    const timeInput = document.getElementById('timeInput');
    const initialTime = '<c:out value="${appt.appointmentStart}" />';

    function parseSlot(dateStr, timeStr) {
        if (!dateStr || !timeStr) return null;
        const parts = timeStr.split(':');
        const hh = parts[0].padStart(2,'0');
        const mm = (parts.length>1)?parts[1].padStart(2,'0'):'00';
        return new Date(dateStr + 'T' + hh + ':' + mm + ':00');
    }
>>>>>>> branch 'main' of https://github.com/LegendarySenfai/SkustaTeetCleaning.git

<<<<<<< HEAD
            function buildRadioHtml(time, ok) {
                var disabledAttr = ok ? '' : 'disabled';
                var checkedAttr = (time === initialTime) ? 'checked' : '';
                return '<label class="time-item ' + (ok ? '' : 'disabled') + '">' +
                       '<input type="radio" name="timeRadio" value="' + time + '" ' + disabledAttr + ' ' + checkedAttr + '/> ' +
                       time +
                       '</label>';
            }
=======
    function isSlotInPast(dateStr, timeStr) {
        const dt = parseSlot(dateStr, timeStr);
        if (!dt) return false;
        return dt.getTime() <= Date.now();
    }
>>>>>>> branch 'main' of https://github.com/LegendarySenfai/SkustaTeetCleaning.git

<<<<<<< HEAD
            async function loadTimes() {
                const date = dateInput.value;
                if (!date) { alert('Please choose date first'); return; }
                const dentistId = dentistSelect.value || '';
                const url = '/api/available?date=' + encodeURIComponent(date) + '&dentistId=' + encodeURIComponent(dentistId);
                try {
                    const resp = await fetch(url);
                    if (!resp.ok) throw new Error(resp.statusText);
                    const slots = await resp.json();
                    let html = '';
                    slots.forEach(slot => {
                        const [time, available] = slot.split('|');
                        const ok = (available === 'true');
                        html += buildRadioHtml(time, ok);
                    });
                    timesArea.innerHTML = html;
                    timesArea.style.display = 'grid';
                    timesArea.querySelectorAll('input[name="timeRadio"]').forEach(r => {
                        r.addEventListener('change', e => timeInput.value = e.target.value);
                    });
                } catch (err) {
                    console.error('Failed to load times', err);
                    alert('Failed to load available times.');
                }
            }

            showBtn.addEventListener('click', () => {
                if (timesArea.style.display === 'grid') {
                    timesArea.style.display = 'none';
                    showBtn.textContent = 'Select Available Time';
                } else {
                    loadTimes();
                    showBtn.textContent = 'Hide Available Times';
                }
=======
    function buildRadioHtml(time, available, selDate) {
        const occupied = (available !== 'true');
        const past = isSlotInPast(selDate, time);
        const disabled = occupied || past;
        const disabledAttr = disabled ? 'disabled' : '';
        const checkedAttr = (!disabled && initialTime === time) ? 'checked' : '';
        const style = 'margin-right:8px; ' + (disabled ? 'opacity:0.55; cursor:not-allowed;' : '');
        return '<label style="' + style + '">' +
               '<input type="radio" name="timeRadio" value="' + time + '" ' + disabledAttr + ' ' + checkedAttr + '/> ' +
               time +
               '</label>';
    }

    async function fetchTimes(date) {
        const dentistId = dentistSelect.value || '';
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

    function attachListener() {
        timesArea.querySelectorAll('input[name="timeRadio"]').forEach(r => {
            if (r.checked) timeInput.value = r.value;
            r.addEventListener('change', function(e){
                timeInput.value = e.target.value;
>>>>>>> branch 'main' of https://github.com/LegendarySenfai/SkustaTeetCleaning.git
            });
<<<<<<< HEAD
            dentistSelect.addEventListener('change', () => { timesArea.style.display='none'; showBtn.textContent='Select Available Time'; });
            dateInput.addEventListener('change', () => { timesArea.style.display='none'; showBtn.textContent='Select Available Time'; });
        })();
    </script>
=======
        });
    }

    let cacheHtml = '', cacheDate = '', cacheDent = '';

    showBtn.addEventListener('click', async function(){
        const date = dateInput.value;
        if (!date) { alert('Please choose date first'); return; }

        if (timesArea.style.display === 'block') {
            timesArea.style.display = 'none';
            showBtn.textContent = 'Select time';
            return;
        }

        try {
            if (!cacheHtml || cacheDate !== date || cacheDent !== dentistSelect.value) {
                cacheHtml = await fetchTimes(date);
                cacheDate = date;
                cacheDent = dentistSelect.value;
            }
            timesArea.innerHTML = cacheHtml;
            timesArea.style.display = 'block';
            showBtn.textContent = 'Hide times';
            attachListener();
        } catch (err) {
            console.error('Failed to load times', err);
            alert('Failed to load available times.');
        }
    });

    dentistSelect.addEventListener('change', function(){ cacheHtml=''; cacheDent = dentistSelect.value; timesArea.style.display='none'; showBtn.textContent='Select time'; });
    dateInput.addEventListener('change', function(){ cacheHtml=''; cacheDate=''; timesArea.style.display='none'; showBtn.textContent='Select time'; });

})();
</script>
>>>>>>> branch 'main' of https://github.com/LegendarySenfai/SkustaTeetCleaning.git
</body>
</html>
