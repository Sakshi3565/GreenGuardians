<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Select Date to View Attendance</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f5f5f5;
            padding: 40px;
            color: #333;
        }
        h2 {
            color: #2e8b57;
        }
        form {
            background-color: #fff;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 0 8px rgba(0, 0, 0, 0.1);
            width: 350px;
        }
        label {
            font-weight: 600;
        }
        input[type="date"] {
            padding: 8px;
            width: 100%;
            margin-top: 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }
        input[type="submit"] {
            margin-top: 20px;
            padding: 10px 16px;
            border: none;
            background-color: #2e8b57;
            color: white;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
        }
        input[type="submit"]:hover {
            background-color: #256b46;
        }
    </style>
</head>
<body>

<h2> View Present Attendance</h2>

<!-- Fetch campaign_id from request -->
<%
    String campaignId = request.getParameter("campaign_id");
%>

<form action="ViewPresent" method="get">
    <input type="hidden" name="campaign_id" value="<%= campaignId %>" />
    <label for="attendance_date">Select Date:</label>
    <input type="date" id="attendance_date" name="attendance_date" required />
    <input type="submit" value="View Attendance" />
</form>

</body>
</html>
