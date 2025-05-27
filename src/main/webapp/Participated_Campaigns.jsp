<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.ArrayList" %>

<%
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("email") == null) {
        response.sendRedirect("User_Login.jsp?error=Please login first");
        return;
    }

    ArrayList<String[]> participatedCampaigns = (ArrayList<String[]>) request.getAttribute("participatedCampaigns");
%>

<html>
<head>
    <title>Participated Campaigns</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        body {
    font-family: 'Segoe UI', sans-serif;
    background-color: #f4f7f6;  
    margin: 0;
    padding: 20px;
    color: #333;
}

.container {
    max-width: 1300px;
    margin: auto;
    padding: 20px;
}

h2 {
    text-align: center;
    color: #2b6cb0; 
    margin-bottom: 30px;
}

.no-campaigns {
    text-align: center;
    font-size: 18px;
    color: #888;
}

.card-container {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
    gap: 20px;
    padding: 10px;
}

.card {
    background-color: #ffffff; 
    border-radius: 12px;
    padding: 18px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);  /* Subtle shadow for depth */
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    transition: transform 0.2s ease;
}

.card:hover {
    transform: translateY(-5px);  
}

.card h3 {
    color: #2c5282; 
    margin-bottom: 10px;
    font-size: 18px;
}

.card p {
    margin: 5px 0;
    font-size: 14px;
    color: #666;  
}

.view-btn, .submit-btn {
    display: inline-block;
    margin-top: 10px;
    padding: 8px 12px;
    font-size: 13px;
    text-decoration: none;
    border-radius: 5px;
    transition: background-color 0.3s ease;
}

.view-btn {
    background-color: #38a169;  
    color: #fff;
    margin-right: 8px;
}

.view-btn:hover {
    background-color: #2f855a; 
}

.submit-btn {
    background-color: #3182ce;  
    color: #fff;
}

.submit-btn:hover {
    background-color: #2b6cb0;  
}

.back-btn {
    display: inline-block;
    margin-top: 30px;
    padding: 10px 20px;
    background-color: #718096;  
    color: #fff;
    text-decoration: none;
    border-radius: 6px;
    font-size: 14px;
    transition: background-color 0.3s ease;
}

.back-btn:hover {
    background-color: #4a5568;  
}

@media (max-width: 768px) {
    .card-container {
        grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); 
    }  
}

    </style>
</head>
<body>

<div class="container">
    <h2>Your Participated Campaigns</h2>

    <% if (participatedCampaigns == null || participatedCampaigns.isEmpty()) { %>
        <p class="no-campaigns">You haven't participated in any campaigns yet.</p>
    <% } else { %>
        <div class="card-container">
            <% for (String[] campaign : participatedCampaigns) {
                String campaignId = campaign[0];
                String campaignTitle = campaign[1];
                String campaignLocation = campaign[2];
                String campaignStartDate = campaign[3];
                String campaignEndDate = campaign[4];
                String campaignStatus = campaign[5];
            %>

            <div class="card">
                <h3><%= campaignTitle %></h3>
                <p><strong>Location:</strong> <%= campaignLocation %></p>
                <p><strong>Start Date:</strong> <%= campaignStartDate %></p>
                <p><strong>End Date:</strong> <%= campaignEndDate %></p>
                <p><strong>Status:</strong> <%= campaignStatus %></p>
                <a href="ViewDetails.jsp?id=<%= campaignId %>" class="view-btn">View Details</a>
                <a href="PlantingRecord.jsp?campaign_id=<%= campaignId %>" class="submit-btn">Submit Record</a>
            </div>

            <% } %>
        </div>
    <% } %>

    <a href="User_Dashboard.jsp" class="back-btn">Back to Dashboard</a>
</div>

</body>
</html>
