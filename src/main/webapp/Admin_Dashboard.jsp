<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="green.DBConnection" %>
<%
    HttpSession sessionObj = request.getSession(false); // Get existing session, don't create a new one
    if (sessionObj == null || sessionObj.getAttribute("username") == null) {
        response.sendRedirect("login.jsp?error=Please login first");
        return;
    }

    int totalCampaigns = 0;
    int totalStaff = 0;
    List<Map<String, String>> recentCampaigns = new ArrayList<>();

    try {
        Connection conn = DBConnection.getConnection();

     
        PreparedStatement ps1 = conn.prepareStatement("SELECT COUNT(*) FROM campaigns");
        ResultSet rs1 = ps1.executeQuery();
        if (rs1.next()) totalCampaigns = rs1.getInt(1);

     
        PreparedStatement ps2 = conn.prepareStatement("SELECT COUNT(*) FROM staff");
        ResultSet rs2 = ps2.executeQuery();
        if (rs2.next()) totalStaff = rs2.getInt(1);

      
        PreparedStatement ps3 = conn.prepareStatement("SELECT title, campaign_type, status FROM campaigns ORDER BY start_date DESC LIMIT 10");
        ResultSet rs3 = ps3.executeQuery();
        while (rs3.next()) {
            Map<String, String> campaign = new HashMap<>();
            campaign.put("name", rs3.getString("title"));
            campaign.put("type", rs3.getString("campaign_type"));
            campaign.put("status", rs3.getString("status"));
            recentCampaigns.add(campaign);
        }

        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <style>
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background-color: #f4f7fb;
        margin-top: 100px;
        padding: 0;
        color: #333;
    }

    .navbar {
        background: #003366;
        padding: 15px;
        text-align: center;
        box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
    }

    .navbar h2 {
        color: white;
        margin: 0;
        font-size: 24px;
    }

    .sidebar {
        width: 250px;
        height: 100vh;
        position: absolute;
        background: #2c3e50; 
        padding-top: 20px;
        transition: width 0.3s ease;
    }

    .sidebar a {
        display: block;
        color: white;
        text-decoration: none;
        padding: 15px;
        font-size: 18px;
        border-bottom: 1px solid #34495e;
        transition: 0.3s ease;
    }

    .sidebar a:hover {
        background: #16a085; 
    }

    .content {
        margin-left: 270px;
        padding: 20px;
    }

    .card {
        background: white;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
        margin-bottom: 20px;
        transition: transform 0.3s ease;
    }

    .card:hover {
        transform: translateY(-5px); 
    }

    .stats {
        display: flex;
        justify-content: center;
        text-align: center;
        margin-bottom: 20px;
    }

    .stats .stat-card {
        background: white;
        padding: 15px;
        border-radius: 8px;
        box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
        width: 30%;
        margin-right: 20px;
        transition: transform 0.3s ease;
    }

    .stats .stat-card:hover {
        transform: translateY(-5px);
    }

    .quick-actions {
        display: flex;
        justify-content: space-around;
        margin-bottom: 20px;
    }

    .quick-actions a {
        padding: 10px 15px;
        background: #2980b9; 
        color: white;
        border-radius: 5px;
        text-decoration: none;
        font-size: 16px;
        transition: 0.3s ease;
    }

    .quick-actions a:hover {
        background: #3498db; 
    }

    .table-container {
        margin-top: 20px;
    }

    table {
        width: 100%;
        border-collapse: collapse;
    }

    table, th, td {
        border: 1px solid #e0e0e0;
    }

    th, td {
        padding: 10px;
        text-align: center;
    }

    th {
        background: #2980b9; 
        color: white;
    }

    td {
        background: #f9f9f9; 
        transition: background 0.3s ease;
    }

    td:hover {
        background: #ecf0f1; 
    }
</style>


</head>
<body>
<%@ include file="header.jsp" %>
<div class="navbar">
    <h2>Admin Dashboard</h2>
</div>
<div class="sidebar">
    <a href="CreateCampaign.jsp"><i class="fas fa-plus-circle"></i> Create Campaign</a>
    <a href="addStaff.jsp"><i class="fas fa-user-plus"></i> Add staff</a>
    <a href="${pageContext.request.contextPath}/loadAssignmentForm"><i class="fas fa-user-tag"></i> Assign Staff To Campaign</a>
    <a href="AllCampaigns.jsp"><i class="fas fa-chart-line"></i> Track Campaign Progress</a>
    <a href="generateReport.jsp"><i class="fas fa-file-alt"></i> Generate Report</a>
    <a href="${pageContext.request.contextPath}/loadUsers"><i class="fas fa-bell"></i> Manage Notifications</a>
    <a href="logout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a>
</div>
<div class="content">
    <div class="stats">
        <div class="stat-card">
            <h3>Total Campaigns</h3>
            <p><%= totalCampaigns %></p>
        </div>
        <div class="stat-card">
            <h3>Staff Size</h3>
            <p><%= totalStaff %></p>
        </div>
    </div>

    <div class="quick-actions">
        <a href="CreateCampaign.jsp">New Campaign</a>
        <a href="generateReport.jsp">Generate Report</a>
    </div>

    <div class="table-container">
        <h3>Recent Campaigns</h3>
        <table>
            <tr>
                <th>Campaign Name</th>
                <th>Type</th>
                <th>Status</th>
            </tr>
            <%
                for (Map<String, String> campaign : recentCampaigns) {
            %>
            <tr>
                <td><%= campaign.get("name") %></td>
                <td><%= campaign.get("type") %></td>
                <td><%= campaign.get("status") %></td>
            </tr>
            <%
                }
            %>
        </table>
    </div>
</div>
</body>
</html>
