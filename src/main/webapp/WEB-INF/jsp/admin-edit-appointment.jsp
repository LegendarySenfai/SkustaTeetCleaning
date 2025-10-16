<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Appointment (Admin)</title>
</head>
<body>
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
            </div>
        </label>
        <br/>

        <label>
            Date:
            <input type="date" id="dateInput" name="date" value="${appt.appointmentDate}" />
        </label>
        <br/><br/>

        <button type="button" id="showTimesBtn">Select time</button>
        <div id="timesArea" style="display:none; margin-top:8px;"></div>

        <input type="hidden" id="timeInput" name="time" value="<c:out value='${appt.appointmentStart}'/>" />
        <br/><br/>

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

        <button type="submit">Save changes</button>
        <a href="/admin/dashboard" style="margin-left:12px;">Cancel</a>
    </form>

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

    function isSlotInPast(dateStr, timeStr) {
        const dt = parseSlot(dateStr, timeStr);
        if (!dt) return false;
        return dt.getTime() <= Date.now();
    }

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
            });
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
</body>
</html>
