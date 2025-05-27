<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Send Notification</title>
     <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f1fdf3;
            padding: 40px;
            color: #2f4f2f;
        }

        h2 {
            text-align: center;
            color: #3e7049;
            margin-bottom: 30px;
        }

        form {
            max-width: 650px;
            margin: auto;
            background-color: #ffffff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.08);
        }

        label {
            font-size: 16px;
            font-weight: 500;
            display: block;
            margin-bottom: 8px;
            color: #305030;
        }

        input[type="text"], textarea, select {
            width: 100%;
            padding: 10px;
            font-size: 15px;
            margin-bottom: 20px;
            border: 1px solid #a8d5b4;
            border-radius: 8px;
            background-color: #f6fff8;
        }

        input[type="radio"] {
            margin-right: 8px;
        }

        textarea {
            resize: vertical;
        }

        button {
            background-color: #4caf50;
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        button:hover {
            background-color: #3e8e41;
        }

        p {
            text-align: center;
            font-size: 16px;
            margin-bottom: 20px;
        }

        #staffDropdown {
            margin-top: 10px;
        }
    </style>-
    
    <script>
        function toggleDropdown() {
            var specificRadio = document.getElementById("specific");
            var staffDropdown = document.getElementById("staffDropdown");
            staffDropdown.style.display = specificRadio.checked ? "block" : "none";
        }
        window.onload = toggleDropdown;
    </script>
</head>
<body>

<h2>Send Notification</h2>

<c:if test="${not empty success}">
    <p style="color:green;">${success}</p>
</c:if>
<c:if test="${not empty error}">
    <p style="color:red;">${error}</p>
</c:if>

<form action="${pageContext.request.contextPath}/sendNotification" method="post">
    <label><input type="radio" name="recipientType" value="all_trackers" onclick="toggleDropdown()" required> All Trackers</label><br>
    <label><input type="radio" name="recipientType" value="all_managers" onclick="toggleDropdown()"> All Managers</label><br>
    <label><input type="radio" name="recipientType" value="specific" id="specific" onclick="toggleDropdown()"> Specific Staff</label><br>

    <div id="staffDropdown" style="display:none; margin-top:10px;">
        <label>Select Staff:</label>
        <select name="staffId">
            <c:forEach var="staff" items="${staffList}">
                <option value="${staff.id}">${staff.email} (${staff.role})</option>
            </c:forEach>
        </select>
    </div>

    <br>
    <label>Subject:</label><br>
    <input type="text" name="subject" required><br><br>

    <label>Message:</label><br>
    <textarea name="message" rows="5" cols="40" required></textarea><br><br>

    <button type="submit">Send Notification</button>
</form>

</body>
</html>
