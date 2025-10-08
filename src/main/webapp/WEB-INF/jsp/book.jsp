<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head><title>Book Appointment</title></head>
<body>
<h2>Book Appointment</h2>
<p>Welcome, ${sessionScope.username} | <a href="/myappointments">My Appointments</a> | <a href="/logout">Logout</a></p>

<c:if test="${not empty errors}">
    <ul style="color:red">
        <c:forEach var="e" items="${errors}"><li>${e}</li></c:forEach>
    </ul>
</c:if>

<!-- DEBUG (remove after confirmed) -->
<p>Debug: dentists=${fn:length(dentists)}, services=${fn:length(services)}</p>

<form id="bookForm" method="post" action="/book">
    <label>Dentist:
        <select name="dentistId" id="dentistSelect">
            <option value="">-- select dentist --</option>
            <c:forEach var="d" items="${dentists}">
                <option value="${d.id}">${d.name} (${d.specialization})</option>
            </c:forEach>
        </select>
    </label><br/>

    <label>Services:<br/>
        <c:forEach var="s" items="${services}">
            <input type="checkbox" name="serviceIds" value="${s.id}" /> ${s.name}<br/>
        </c:forEach>
    </label><br/>

    <label>Date: <input type="date" id="dateInput" name="date" value="${selectedDate}"/></label>
    <button type="button" id="showTimesBtn">Show Times</button><br/>

    <div id="timesArea">
        <!-- times will be injected here -->
    </div>

    <input type="hidden" name="time" id="timeInput"/>
    <br/>
    <button type="submit">Book</button>
</form>

<script>
    // Helper: safely build radio HTML using string concatenation
    function buildRadioHtml(time, ok) {
        var color = ok ? 'black' : 'gray';
        var disabledAttr = ok ? '' : 'disabled';
        // Build string with concatenation — avoid EL-like sequences so JSP EL won't evaluate them
        return '<label style="color:' + color + '">' +
               '<input type="radio" name="timeRadio" value="' + time + '" ' + disabledAttr + '/> ' +
               time + '</label><br/>';
    }

    document.getElementById('showTimesBtn').addEventListener('click', async function () {
        var date = document.getElementById('dateInput').value;
        var dentistId = document.getElementById('dentistSelect').value;
        if (!date) { alert('Pick a date first'); return; }

        // Use string concatenation to avoid server-side EL parsing
        var url = '/api/available?date=' + encodeURIComponent(date) + '&dentistId=' + (dentistId || '');
        try {
            var r = await fetch(url);
            if (!r.ok) {
                alert('Failed to fetch times: ' + r.statusText);
                return;
            }
            var arr = await r.json();
            var area = document.getElementById('timesArea');
            area.innerHTML = '';

            arr.forEach(function (it) {
                var parts = it.split('|');
                var time = parts[0];
                var ok = parts[1] === 'true';
                area.innerHTML += buildRadioHtml(time, ok);
            });

            // set hidden time input when selecting radio
            area.addEventListener('change', function (e) {
                if (e.target && e.target.name === 'timeRadio') {
                    document.getElementById('timeInput').value = e.target.value;
                }
            });
        } catch (err) {
            console.error(err);
            alert('Error fetching times. See console.');
        }
    });
</script>


</body>
</html>
