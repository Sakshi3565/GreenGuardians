<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.http.*" %>

<%
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("email") == null) {
        response.sendRedirect("User_Login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Profile</title>
    <link rel="stylesheet" href="styles.css">
    <style>
    body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    margin: 0;
    padding: 0;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
}

.container {
    background: white;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    width: 400px;
    text-align: center;
}

h2 {
    color: #333;
    margin-bottom: 20px;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 20px;
}

th, td {
    padding: 10px;
    border-bottom: 1px solid #ddd;
    text-align: left;
}

th {
    background: #007bff;
    color: white;
    border-radius: 5px;
}

td {
    background: #f9f9f9;
}

a {
    display: inline-block;
    text-decoration: none;
    background: #28a745;
    color: white;
    padding: 10px 15px;
    border-radius: 5px;
    transition: 0.3s;
}

a:hover {
    background: #218838;
}
    
    </style>
</head>
<body>

    <div class="container">
        <h2>My Profile</h2>
        <table>
            <tr><th>Name:</th><td>${name}</td></tr>
            <tr><th>Email:</th><td>${email}</td></tr>
            <tr><th>Phone:</th><td>${phone}</td></tr>
            <tr><th>Address:</th><td>${address}</td></tr>
            <tr><th>Gender:</th><td>${gender}</td></tr>
            <tr><th>Joined On:</th><td>${created_at}</td></tr>
        </table>
        <a href="editProfile.jsp">Edit Profile</a>
    </div>
</body>
</html>
