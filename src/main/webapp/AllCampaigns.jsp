<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>All Campaigns</title>
    <link rel="stylesheet" href="styles.css">
     <style>
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background-color: #f3f4fc;
    }
    .header {
        background-color: #5a4fcf;
        color: white;
        padding: 20px;
        text-align: center;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }
    .campaign-container {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
        gap: 20px;
        padding: 40px;
    }
    .campaign-card {
        border: 1px solid #c9c4ec;
        border-radius: 10px;
        background-color: #ffffff;
        padding: 20px;
        box-shadow: 0 4px 8px rgba(90, 79, 207, 0.1);
        transition: transform 0.3s, box-shadow 0.3s;
    }
    .campaign-card:hover {
        transform: translateY(-10px);
        box-shadow: 0 8px 16px rgba(90, 79, 207, 0.2);
    }
    .campaign-card h3 {
        margin: 0 0 15px;
        font-size: 1.5rem;
        color: #4b3db7;
    }
    .campaign-card p {
        margin: 8px 0;
        font-size: 1rem;
        color: #555a77;
    }
    .button-group {
        margin-top: 20px;
    }
    .btn {
        padding: 10px 20px;
        background-color: #5a4fcf;
        color: white;
        border-radius: 5px;
        text-decoration: none;
        font-size: 1rem;
        transition: background-color 0.3s;
        border: none;
        cursor: pointer;
    }
    .btn:hover {
        background-color: #483fa8;
    }
</style>

</head>
<body>

<div class="header">
    <h2>All Campaigns</h2>
</div>

<div class="campaign-container">
    <%
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/yourdatabase", "root", "password");
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT * FROM campaigns");

            while (rs.next()) {
                int campaignId = rs.getInt("campaign_id");
    %>
    <div class="campaign-card">
        <h3><%= rs.getString("title") %></h3>
        <p><strong>Type:</strong> <%= rs.getString("campaign_type") %></p>
        <p><strong>Start:</strong> <%= sdf.format(rs.getDate("start_date")) %></p>
        <p><strong>End:</strong> <%= sdf.format(rs.getDate("end_date")) %></p>
        <p><strong>Status:</strong> <%= rs.getString("status") %></p>
        <div class="button-group">
            <form action="TrackProgress" method="get">
                <input type="hidden" name="campaign_id" value="<%= campaignId %>">
                <button type="submit" class="btn">Track Progress</button>
            </form>
        </div>
    </div>
    <%
            }
        } catch (Exception e) {
            e.printStackTrace();
    %>
    <p>Error loading campaigns.</p>
    <%
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    %>
</div>

</body>
</html>
