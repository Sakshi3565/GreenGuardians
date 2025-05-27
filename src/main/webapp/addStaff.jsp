<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Add Staff</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f4fc;
            padding: 40px;
            color: #333;
        }

        h2 {
            color: #5a4fcf;
            text-align: center;
            margin-bottom: 30px;
        }

        form {
            max-width: 600px;
            margin: auto;
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(90, 79, 207, 0.1);
        }

        label, input, select, textarea {
            display: block;
            width: 100%;
            margin-bottom: 15px;
            font-size: 16px;
        }

        input, select, textarea {
            padding: 10px;
            border: 1px solid #bfb6ff;
            border-radius: 8px;
            background-color: #f7f6ff;
            transition: all 0.3s ease;
        }

        input:focus, select:focus, textarea:focus {
            outline: none;
            border-color: #5a4fcf;
            background-color: #ffffff;
        }

        button {
            background-color: #5a4fcf;
            color: #ffffff;
            padding: 12px 20px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        button:hover {
            background-color: #483db0;
        }

        p {
            text-align: center;
            font-size: 16px;
        }
    </style>
</head>
<body>
<h2>Add New Staff</h2>

<c:if test="${not empty success}">
    <p style="color:green;">${success}</p>
</c:if>
<c:if test="${not empty error}">
    <p style="color:red;">${error}</p>
</c:if>

<form action="${pageContext.request.contextPath}/addStaff" method="post">

    Name: <input type="text" name="name" required>
    Email: <input type="email" name="email" required>
    Role:
    <select name="role" required>
        <option value="Tracker">Tracker</option>
        <option value="Campaign Manager">Campaign Manager</option>
    </select>
    Phone: <input type="text" name="phone" required>
    Address: <textarea name="address"></textarea>
    City: <input type="text" name="city">
    State: <input type="text" name="state">
    Date of Birth: <input type="date" name="dob"><br>

    <button type="submit">Add Staff</button>
</form>
</body>
</html>
