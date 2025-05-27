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
              background: url('image/bg1.jpg') no-repeat center center fixed ;
            background-size: cover;
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
            margin: 20px 0;
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
</head>
<body>

    <%@ include file="header.jsp" %> 
       <h2>Admin Login</h2>
        <form name="login" action="Login" method="post">
            <label><b>Username:</b></label>
            <input type="text" name="username" placeholder="Enter username">

            <label><b>Password:</b></label>
            <input type="password" name="password" placeholder="Enter Password">
            <% if (request.getParameter("error") != null) { %>
        <p style="color:red;"><%= request.getParameter("error") %></p>
    <% } %>

            <button type="submit">Login</button>
        </form>
 <div class="footer">
        <%@ include file="footer.jsp" %>
    </div>
</body>
</html>
