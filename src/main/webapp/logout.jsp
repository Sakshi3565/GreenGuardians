<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj != null) {
        sessionObj.invalidate(); 
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Logging Out...</title>
    <link rel="stylesheet" type="text/css" href="logout.css"> <!-- Linking the CSS -->
    <meta http-equiv="refresh" content="3;url=User_Login.jsp?message=Logged out successfully">
</head>
<body>
    <div class="logout-container">
        <h2>You have been logged out</h2>
        <p>Redirecting to Home page...</p>
        <a href="index.jsp" class="login-btn">Go to Home</a>
    </div>
</body>
</html>
