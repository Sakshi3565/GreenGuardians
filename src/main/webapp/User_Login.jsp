<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <style>
        body {
           
            font-family: Arial, sans-serif;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            margin-top:100px;
        }
        h2 {
       text-align: center;
       width:100%;
       margin-bottom: -60px; 
      
     }
        form {
            padding: 60px;
            margin: 100px auto;
            border: 1px solid #ccc; 
            backdrop-filter: blur(10px);
            background: rgba(255, 255, 255, 0);
            max-width: 500px;
            }        
        input {
            display: block;
            width: 300px;
            height: 30px;
            margin: 10px 0;
            padding: 10px;
        }
        button {
            width: 100%;
            padding: 9px 25px;
            background: #E74C3C;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 18px;
            cursor: pointer;
            transition: 0.3s;
        }
        button:hover {
            background: #C0392B;
        }
        .error {
            color: red;
            font-size: 14px;
            display: block;
        }
         .footer {
            width: 100%;
            position: absolute;
            bottom: 0;
        }
    </style>
    <script>
        function validateLogin() {
            let email = document.forms["loginForm"]["email"].value;
            let password = document.forms["loginForm"]["password"].value;

            let emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
            let valid = true;

            document.getElementById("emailError").innerText = emailPattern.test(email) ? "" : "Invalid email format.";
            document.getElementById("passwordError").innerText = password.length >= 6 ? "" : "Password must be at least 6 characters.";

            if (!emailPattern.test(email) || password.length < 6) {
                valid = false;
            }

            return valid;
        }
    </script>
</head>
<body>

    <%@ include file="header.jsp" %> 
       <h2>User Login</h2>
        <form name="loginForm" action="User_login" method="post" onsubmit="return validateLogin()">
            <label><b>Email:</b></label>
            <input type="email" name="email" placeholder="Enter Email">
            <span id="emailError" class="error"></span><br>

            <label><b>Password:</b></label>
            <input type="password" name="password" placeholder="Enter Password">
            <span id="passwordError" class="error"></span><br>

            <button type="submit">Login</button>
            <p>Don't have an account? <a href="register.jsp">Register here</a></p>
        </form>
 <div class="footer">
        <%@ include file="footer.jsp" %>
    </div>
</body>
</html>
