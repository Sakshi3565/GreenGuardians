<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Campaign Participants</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
        th { background-color: #f2f2f2; }
        h2, h3 { color: #2e7d32; }
        .btn { padding: 6px 12px; background-color: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer; }
        .btn:hover { background-color: #45a049; }
        .status-container { display: flex; align-items: center; }
        .status-container span { margin-right: 10px; font-weight: bold; }
    </style>
</head>
<body>
    <h2>Participants for Campaign</h2>
    <table>
        <tr>
            <th>Participant Name</th>
            <th>Assigned Tracker</th>
        </tr>
        <%
            int campaignId = Integer.parseInt(request.getParameter("campaign_id"));
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/yourdatabase", "root", "password");

                String query = "SELECT *from campaign_participation WHERE campaign_id=?";
                               
                ps = conn.prepareStatement(query);
                ps.setInt(1, campaignId);
                rs = ps.executeQuery();

                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getString("participant_name") %></td>
            <td><%= rs.getString("tracker_name") != null ? rs.getString("tracker_name") : "No tracker assigned" %></td>
        </tr>
        <%
                }
            } catch (Exception e) {
                out.println("<tr><td colspan='2'>Error: " + e.getMessage() + "</td></tr>");
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            }
        %>
    </table>
    <form action="ManagerDashboard.jsp">
        <button type="submit" class="btn">Back to Dashboard</button>
    </form>
</body>
</html>
