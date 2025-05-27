<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Present Attendance</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f9f9f9;
            padding: 40px;
            color: #333;
        }
        h2 {
            color: #2e8b57;
            margin-bottom: 20px;
        }
        table {
            width: 70%;
            border-collapse: collapse;
            margin-bottom: 20px;
            background-color: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        th, td {
            padding: 12px 15px;
            text-align: left;
        }
        th {
            background-color: #2e8b57;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f0f0f0;
        }
        .count {
            font-size: 18px;
            font-weight: bold;
            color: #333;
        }
    </style>
</head>
<body>

<h2> Present Participants on ${attendanceDate}</h2>

<table>
    <tr>
        <th>User ID</th>
        <th>Name</th>
    </tr>
    <c:forEach var="user" items="${presentUsers}">
        <tr>
            <td>${user.user_id}</td>
            <td>${user.name}</td>
        </tr>
    </c:forEach>
</table>

<div class="count">
    Total Present: <strong>${count}</strong>
</div>

</body>
</html>
