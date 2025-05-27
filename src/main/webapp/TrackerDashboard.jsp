<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    Integer trackerId = (Integer) session.getAttribute("staff_id");
    if (trackerId == null) {
        response.sendRedirect("login.jsp?error=Please login first");
        return;
    }

    String trackerName = "";
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/yourdatabase", "root", "password");

        // Get tracker name
        ps = conn.prepareStatement("SELECT name FROM staff WHERE staff_id = ?");
        ps.setInt(1, trackerId);
        rs = ps.executeQuery();
        if (rs.next()) {
            trackerName = rs.getString("name");
        }
        rs.close();
        ps.close();
%>

<html>
<head>
    <title>Tracker Dashboard</title>
    <style>
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
        th { background-color: #e8f5e9; }
        h2 { color: #2e7d32; }
        .btn { padding: 6px 12px; background-color: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer; }
        .btn:disabled { background-color: #ccc; cursor: not-allowed; }
    </style>
</head>
<body>
    <h2> Welcome, <%= trackerName %>!</h2>
    <h3>Your Assigned Campaigns for Tracking</h3>

    <% String msg = (String) request.getAttribute("message");
       if (msg != null) { %>
        <script>alert('<%= msg %>');</script>
    <% } %>

    <table>
        <tr>
            <th>Title</th>
            <th>Type</th>
            <th>Location</th>
            <th>Start Date</th>
            <th>End Date</th>
            <th>Status</th>
            <th>Manager</th>
            <th>Last Report</th>
            <th>Action</th>
        </tr>
    <%
        String sql = "SELECT DISTINCT c.campaign_id, c.title, c.location, c.start_date, c.end_date, c.status, c.campaign_type, " +
                     "(SELECT s2.name FROM campaign_assignment ca2 " +
                     " JOIN staff s2 ON ca2.staff_id = s2.staff_id " +
                     " WHERE ca2.campaign_id = c.campaign_id AND s2.role = 'Campaign Manager' LIMIT 1) AS manager_name, " +
                     "(SELECT MAX(date) FROM tracker_records tr " +
                     " WHERE tr.campaign_id = c.campaign_id AND tr.staff_id = ?) AS last_report " +
                     "FROM campaigns c " +
                     "JOIN campaign_assignment ca ON ca.campaign_id = c.campaign_id " +
                     "JOIN staff s ON ca.staff_id = s.staff_id " +
                     "WHERE s.staff_id = ? AND s.role = 'Tracker'";

        ps = conn.prepareStatement(sql);
        ps.setInt(1, trackerId); // last_report
        ps.setInt(2, trackerId); // assigned campaigns
        rs = ps.executeQuery();

        java.sql.Date today = new java.sql.Date(System.currentTimeMillis());

        while (rs.next()) {
            int campaignId = rs.getInt("campaign_id");
            String status = rs.getString("status");
            String campaignType = rs.getString("campaign_type");
            java.sql.Date lastReportDate = rs.getDate("last_report");

            boolean submittedToday = lastReportDate != null && lastReportDate.equals(today);
    %>
        <tr>
            <td><%= rs.getString("title") %></td>
            <td><%= campaignType %></td>
            <td><%= rs.getString("location") %></td>
            <td><%= rs.getDate("start_date") %></td>
            <td><%= rs.getDate("end_date") %></td>
            <td><%= status %></td>
            <td><%= rs.getString("manager_name") != null ? rs.getString("manager_name") : "Not Assigned" %></td>
            <td>
                <%= lastReportDate != null ? lastReportDate.toString() : "No report yet" %>
                <br>
                <a href="my_report.jsp?campaign_id=<%= campaignId %>">📋 View My Reports</a>
            </td>
            <td>
                <form action="TrackerReport.jsp" method="post">
                    <input type="hidden" name="campaign_id" value="<%= campaignId %>">
                    <input type="hidden" name="campaign_type" value="<%= campaignType %>">
                    <button class="btn" type="submit"
                        <%= !"Ongoing".equals(status) || submittedToday ? "disabled" : "" %>>
                        Submit Report
                    </button>
                </form>
                <% if (submittedToday) { %>
                    <small style="color: green;">✅ Submitted today</small>
                <% } %>
            </td>
        </tr>
    <%
        }
    } catch (Exception e) {
        out.println("<tr><td colspan='9'>Error: " + e.getMessage() + "</td></tr>");
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
    %>
    </table>
</body>
</html>
