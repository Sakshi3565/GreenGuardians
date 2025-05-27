<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    HttpSession sessionObj = request.getSession(false); 
    if (sessionObj == null || sessionObj.getAttribute("username") == null) {
        response.sendRedirect("login.jsp?error=Please login first");
        return;     }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Campaign</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: white;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin-top:150px;
            
        }
        .container {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            width: 500px;
          
        }
        h2 {
            text-align: center;
            color: #007BFF;
        }
        label {
            font-weight: bold;
            margin-top: 10px;
            display: block;
        }
        input, select, textarea {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        textarea {
            resize: none;
            height: 80px;
        }
        button {
            width: 100%;
            background: #007BFF;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 15px;
            transition: 0.3s;
        }
        button:hover {
            background: #0056b3;
        }
        .hidden { display: none; }
    </style>
    <script>
        function toggleFields() {
            let type = document.getElementById("campaignType").value;
            document.getElementById("treeField").style.display = (type === "Planting") ? "block" : "none";
        }
    </script>
</head>
<body>
  <%@include file="header.jsp" %>    
    <div class="container">
        <h2>Create a New Campaign</h2>
        <form action="CreateCampaign" method="post">
            <label>Title:</label>
            <input type="text" name="title" required>

            <label>Description:</label>
            <textarea name="description" required></textarea>

            <label>Type:</label>
            <select name="campaign_type" id="campaignType" onchange="toggleFields()" required>
                <option value="Awareness">Awareness</option>
                <option value="Planting">Planting</option>
            </select>

            <div id="treeField" class="hidden">
                <label>Number of Trees to be Planted:</label>
                <input type="number" name="trees_to_plant" min="1">
            </div>

            <label>Number of People Required:</label>
            <input type="number" name="people_required" min="1" required>

            <label>Donation Required (in $):</label>
            <input type="number" name="donation_required" step="0.01" min="0" required>

            <label>Location:</label>
            <input type="text" name="location" required>

            <label>Start Date:</label>
            <input type="date" name="start_date" required>

            <label>End Date:</label>
            <input type="date" name="end_date" required>

            <label>Status:</label>
            <select name="status">
                <option value="Upcoming">Upcoming</option>
                <option value="Ongoing">Ongoing</option>
                <option value="Completed">Completed</option>
            </select>

            <button type="submit">Create Campaign</button>
        </form>
    </div>
</body>
</html>