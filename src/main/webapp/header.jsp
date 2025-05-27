<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
/* Header */
header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: white;
    padding: 20px 10px;
    position: fixed;
    width: 100%;
    top: 0;
    z-index: 1000;
}

.logo {
    font-size: 24px;
    font-weight: bold;
    color: black;
}

nav ul {
    list-style: none;
    margin: 0;
    padding: 0;
    display: flex;
}

nav ul li {
    margin: 0 15px;
    position: relative;
}

nav ul li a {
    text-decoration: none;
    color: black;
    font-size: 18px;
    padding: 8px 15px;
    transition: 0.3s;
}

nav ul li a:hover,
nav ul li a:active {
    background: #6aff6a;
    color: black;
    border-radius: 5px;
}

/* Dropdown */
.dropdown-content {
    display: none;
    position: absolute;
    background-color: rgba(0, 51, 0, 0.9);
    min-width: 120px;
    box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.2);
    z-index: 1;
    border-radius: 5px;
}

.dropdown-content a {
    color: #fff;
    padding: 10px;
    display: block;
    text-align: left;
}

.dropdown-content a:hover {
    background-color: #6aff6a;
    color: #003300;
}

.show {
    display: block;
}
</style>
</head>
<body>
      <header>
        <div class="logo">🌱 GreenGuardians</div>
        <nav>
            <ul>
                <li><a href="index.jsp">Home</a></li>
                <li><a href="about.jsp">About Us </a></li>
                <li class="dropdown">
                    <a href="#" class="dropbtn" onclick="toggleDropdown()">Login</a>
                    <div class="dropdown-content" id="loginDropdown">
                        <a href="login.jsp">Staff</a>
                        <a href="User_Login.jsp">User</a>
                    </div>
                </li>
                <li><a href="register.jsp">Register</a></li>
               
                	
            </ul>
        </nav>
    </header>
  
</body>
</html>