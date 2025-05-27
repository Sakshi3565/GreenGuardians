<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>Mark Attendance</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
        }

        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 15px;
        }

        th, td {
            border: 1px solid #ccc;
            padding: 10px;
            text-align: center;
        }

        .msg {
            padding: 10px;
            margin: 15px 0;
            width: 90%;
            border-radius: 8px;
            font-weight: bold;
            text-align: center;
        }

        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>

<fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy-MM-dd" var="today" />

<h2>Mark Attendance for Campaign #${campaign_id} - ${today}</h2>

<c:if test="${not empty param.success}">
    <div class="msg success">${param.success}</div>
</c:if>
<c:if test="${not empty param.error}">
    <div class="msg error">${param.error}</div>
</c:if>

<form action="SubmitAttendance" method="post">
    <input type="hidden" name="campaign_id" value="${campaign_id}" />
    <input type="hidden" name="attendance_date" value="${today}" />

    <table>
        <tr>
            <th>User ID</th>
            <th>Name</th>
            <th>Attendance</th>
        </tr>

        <c:forEach var="p" items="${participants}">
            <tr>
                <td>${p.user_id}</td>
                <td>${p.name}</td>
                <td>
                    <input type="checkbox" name="user_ids" value="${p.user_id}" style="display: none;" checked />
                    <input type="radio" name="attendance_${p.user_id}" value="Present"
                        ${p.attendance == "Present" ? "checked" : ""}/> Present
                    <input type="radio" name="attendance_${p.user_id}" value="Absent"
                        ${p.attendance == "Absent" ? "checked" : ""}/> Absent
                </td>
            </tr>
        </c:forEach>
    </table>

    <br>
    <input type="submit" value="Submit Attendance" />
</form>

</body>
</html>
