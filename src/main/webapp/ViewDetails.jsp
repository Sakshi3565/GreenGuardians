<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String campaignId = request.getParameter("id");
    if (campaignId == null || campaignId.trim().isEmpty()) {
        response.sendRedirect("User_Dashboard.jsp?error=Campaign ID is missing.");
        return;
    }

    String title = "", description = "", location = "", startDate = "", endDate = "", status = "";
    int treesToPlant = 0;

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/yourdatabase", "root", "password");

        String query = "SELECT * FROM campaigns WHERE campaign_id = ?";
        ps = conn.prepareStatement(query);
        ps.setString(1, campaignId);
        rs = ps.executeQuery();

        if (rs.next()) {
            title = rs.getString("title");
            description = rs.getString("description");
            location = rs.getString("location");
            startDate = rs.getString("start_date");
            endDate = rs.getString("end_date");
            status = rs.getString("status");
            treesToPlant = rs.getInt("trees_to_plant");
        } else {
            out.println("<p style='color:red;'>Campaign not found.</p>");
            return;
        }
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Campaign Details</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f5f8fa;
            padding: 40px;
            color: #2c3e50;
        }

        .campaign-box {
            background-color: #fff;
            padding: 30px;
            max-width: 600px;
            margin: auto;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }

        h2 {
            color: #2b6cb0;
            margin-bottom: 20px;
            text-align: center;
        }

        .detail {
            margin-bottom: 15px;
        }

        .detail strong {
            display: inline-block;
            width: 140px;
            color: #444;
        }

        .back-btn {
            display: block;
            width: fit-content;
            margin: 30px auto 0;
            padding: 10px 20px;
            background-color: #2b6cb0;
            color: #fff;
            text-decoration: none;
            border-radius: 6px;
            font-size: 14px;
        }

        .back-btn:hover {
            background-color: #254e80;
        }
    </style>
</head>
<body>

<div class="campaign-box">
    <h2>🌿 Campaign Details</h2>

    <div class="detail"><strong>Title:</strong> <%= title %></div>
    <div class="detail"><strong>Description:</strong> <%= description %></div>
    <div class="detail"><strong>Location:</strong> <%= location %></div>
    <div class="detail"><strong>Start Date:</strong> <%= startDate %></div>
    <div class="detail"><strong>End Date:</strong> <%= endDate %></div>
    <div class="detail"><strong>Status:</strong> <%= status %></div>
    <div class="detail"><strong>Trees to Plant:</strong> <%= treesToPlant %></div>
</div>

<a href="ParticipatedCampaigns" class="back-btn">← Back to Campaigns</a>

</body>
</html>
