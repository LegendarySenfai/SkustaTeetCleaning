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
                        <input type="checkbox" name="serviceIds" value="${s.id}"
                               <c:if test="${appt.services.contains(s)}">checked</c:if> />
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

        <input type="hidden" id="timeInput" name="time" value="${appt.appointmentStart}" />
        <br/><br/>

        <label>
            Status:
            <select name="status">
                <option value="">(leave unchanged)</option>
                <option value="PENDING" <c:if test="${appt.status == 'PENDING'}">selected</c:if>>PENDING</option>
                <option value="COMPLETED" <c:if test="${appt.status == 'COMPLETED'}">selected</c:if>>COMPLETED</option>
                <option value="CANCELLED" <c:if test="${appt.status == 'CANCELLED'}">selected</c:if>>CANCELLED</option>
            </select>
        </label>
        <br/><br/>

        <button type="submit">Save changes</button>
        <a href="/admin/dashboard" style="margin-left:12px;">Cancel</a>
    </form>

    <script>
        // Basic time picker logic matching /book behavior.
        (function(){
            const showBtn = document.getElementById('showTimesBtn');
            const timesArea = document.getElementById('timesArea');
            const dateInput = document.getElementById('dateInput');
            const dentistSelect = document.getElementById('dentistSelect');
            const timeInput = document.getElementById('timeInput');

            // initial time from server (preselect)
            const initialTime = "${appt.appointmentStart}";

            function buildRadioHtml(time, ok) {
                var disabledAttr = ok ? '' : 'disabled';
                var checkedAttr = (time === initialTime) ? 'checked' : '';
                var className = ok ? '' : 'disabled';
                return '<label style="margin-right:8px;">' +
                    '<input type="radio" name="timeRadio" value="' + time + '" ' + disabledAttr + ' ' + checkedAttr + '/> ' +
                    time +
                    '</label>';
            }

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
                    timesArea.style.display = 'block';

                    // attach listener to update hidden input
                    timesArea.querySelectorAll('input[name="timeRadio"]').forEach(r => {
                        r.addEventListener('change', function(e){
                            timeInput.value = e.target.value;
                        });
                    });

                } catch (err) {
                    console.error('Failed to load times', err);
                    alert('Failed to load available times.');
                }
            }

            showBtn.addEventListener('click', function(){
                if (timesArea.style.display === 'block') {
                    timesArea.style.display = 'none';
                    showBtn.textContent = 'Select time';
                } else {
                    loadTimes();
                    showBtn.textContent = 'Hide times';
                }
            });

            // When dentist or date changes, hide cache so admin can reload
            dentistSelect.addEventListener('change', function(){ timesArea.style.display='none'; showBtn.textContent='Select time'; });
            dateInput.addEventListener('change', function(){ timesArea.style.display='none'; showBtn.textContent='Select time'; });
        })();
    </script>
</body>
</html>
