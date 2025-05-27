<%@ page contentType="text/html; charset=UTF-8" language="java" %>
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
    <title>Edit Profile</title>
</head>
<body>
    <h2>Edit Profile</h2>
    <form action="Update_Profile" method="post">
        <label>Name:</label>
        <input type="text" name="name" value="${name}" required><br>
        
        <label>Phone:</label>
        <input type="text" name="phone" value="${phone}" required><br>
        
        <label>Address:</label>
        <textarea name="address" required>${address}</textarea><br>
        
        <input type="submit" value="Update Profile">
    </form>
</body>
</html>
