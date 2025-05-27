<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("email") == null) {
        response.sendRedirect("User_Login.jsp?error=Please login first");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Campaign Details</title>
    <style>
    body {
    font-family: 'Segoe UI', sans-serif;
    background-color: #f7f9fb;
    padding: 40px;
    color: #2d3748;
}

.container {
    background-color: #ffffff;
    padding: 30px;
    max-width: 720px;
    margin: auto;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
}

h2 {
    color: #2f855a;
    text-align: center;
    margin-bottom: 25px;
}

p {
    margin-bottom: 12px;
    font-size: 16px;
}

strong {
    color: #444;
}

.button-row {
    display: flex;
    justify-content: center;
    gap: 20px;
    margin-top: 20px;
}

.btn {
    padding: 10px 20px;
    font-size: 15px;
    border: none;
    border-radius: 6px;
    color: #fff;
    background-color: #2f855a; /* soft green */
    cursor: pointer;
    transition: background-color 0.3s ease;
}

.btn:hover {
    background-color: #276749; /* darker green on hover */
}
    
    </style>
</head>
<body>

<div class="container">
    <% if ("Awareness".equals(request.getAttribute("campaignType"))) { %>
        <p><strong>"Join the campaign as an audience member and support 
        the campaign with donation — your contribution means a lot to us!"</strong></p>
    <% } %>

    <h2><%= request.getAttribute("campaignTitle") %></h2>

    <p><strong>Type:</strong> <%= request.getAttribute("campaignType") %></p>
    <p><strong>Location:</strong> <%= request.getAttribute("location") %></p>
    <p><strong>Start Date:</strong> <%= request.getAttribute("startDate") %></p>
    <p><strong>End Date:</strong> <%= request.getAttribute("endDate") %></p>
    <p><strong>Status:</strong> <%= request.getAttribute("status") %></p>
    <p><strong>Description:</strong> <%= request.getAttribute("description") %></p>
    <p><strong>People Required:</strong> <%= request.getAttribute("peopleRequired") %></p>
    <p><strong>Donation Required:</strong> $<%= request.getAttribute("donationRequired") %></p>

    <% if ("Planting".equals(request.getAttribute("campaignType"))) { %>
        <p><strong>Trees to Plant:</strong> <%= request.getAttribute("treesToPlant") %></p>
    <% } %>

    <!-- Button Row -->
    <div class="button-row">
        <form action="Participate" method="post">
            <input type="hidden" name="campaignId" value="<%= request.getParameter("id") %>">
            <button type="submit" class="btn">Participate</button>
        </form>

        <form action="donation.jsp" method="post">
            <input type="hidden" name="campaignId" value="<%= request.getParameter("id") %>">
            <button type="submit" class="btn">Donate</button>
        </form>
    </div>
</div>

</body>
</html>
