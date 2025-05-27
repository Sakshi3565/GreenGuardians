<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Integer managerId = (Integer) session.getAttribute("staff_id");
    String username = (String) session.getAttribute("username");
    String managerName = "";
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/yourdatabase", "root", "password");

        String nameQuery = "SELECT name FROM staff WHERE staff_id = ?";
        ps = conn.prepareStatement(nameQuery);
        ps.setInt(1, managerId);
        rs = ps.executeQuery();
        if (rs.next()) {
            managerName = rs.getString("name");
        }
        rs.close();
        ps.close();
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>

<html>
<head>
    <title>Campaign Manager Dashboard</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #e0eafc, #cfdef3);
            padding: 40px;
            color: #2c3e50;
        }
        h2, h3 {
            color: #3f51b5;
            margin-bottom: 10px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 30px;
            background-color: #ffffff;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 6px 12px rgba(0,0,0,0.1);
        }
        th, td {
            border: 1px solid #e0e0e0;
            padding: 15px;
            text-align: center;
            vertical-align: middle;
        }
        th {
            background: linear-gradient(to right, #d1c4e9, #b39ddb);
            color: #311b92;
        }
        .btn {
            padding: 10px 16px;
            background-color: #5c6bc0;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s ease;
        }
        .btn:hover {
            background-color: #3f51b5;
        }
        .status-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
        }
        .status-container span {
            font-weight: bold;
            color: #3949ab;
        }
        .action-group {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: center;
        }
        form {
            margin: 0;
        }
    </style>
</head>
<body>

    <h2>Welcome, <%= managerName %>! 👋</h2>

    <h3>📋 Your Assigned Campaigns</h3>
    <table>
        <tr>
            <th>Title</th>
            <th>Location</th>
            <th>Start Date</th>
            <th>End Date</th>
            <th>Status</th>
            <th>Participants</th>
            <th>Total Donations</th>
            <th>Actions</th>
        </tr>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/greenguardians", "root", "Sakshi@3565");

                String query = "SELECT c.*, " +
                               "(SELECT COUNT(*) FROM campaign_participation pp WHERE pp.campaign_id = c.campaign_id) AS participant_count, " +
                               "(SELECT IFNULL(SUM(amount), 0) FROM donations d WHERE d.campaign_id = c.campaign_id) AS total_donations " +
                               "FROM campaigns c " +
                               "JOIN campaign_assignment ca ON ca.campaign_id = c.campaign_id " +
                               "WHERE ca.staff_id = ?";

                ps = conn.prepareStatement(query);
                ps.setInt(1, managerId);
                rs = ps.executeQuery();

                while (rs.next()) {
                    int campaignId = rs.getInt("campaign_id");
                    String currentStatus = rs.getString("status");
        %>
        <tr>
            <td><%= rs.getString("title") %></td>
            <td><%= rs.getString("location") %></td>
            <td><%= rs.getDate("start_date") %></td>
            <td><%= rs.getDate("end_date") %></td>
            <td>
                <div class="status-container">
                    <span>Current Status: <%= currentStatus %></span>
                    <form action="UpdateCampaignStatus" method="post">
                        <input type="hidden" name="campaign_id" value="<%= campaignId %>">
                        <select name="status">
                            <option value="Ongoing" <%= "Ongoing".equals(currentStatus) ? "selected" : "" %>>Ongoing</option>
                            <option value="Completed" <%= "Completed".equals(currentStatus) ? "selected" : "" %>>Completed</option>
                            <option value="Upcoming" <%= "Upcoming".equals(currentStatus) ? "selected" : "" %>>Upcoming</option>
                        </select>
                        <button type="submit" class="btn">Update</button>
                    </form>
                </div>
            </td>
            <td>
                <%= rs.getInt("participant_count") %>
                <form action="ManageParticipant.jsp" method="get">
                    <input type="hidden" name="campaign_id" value="<%= campaignId %>">
                    <button type="submit" class="btn">Manage Participants</button>
                </form>
            </td>
            <td>
                ₹<%= rs.getDouble("total_donations") %>
            </td>
            <td>
                <div class="action-group">
                    <form action="ViewTracker.jsp" method="get">
                        <input type="hidden" name="campaign_id" value="<%= campaignId %>">
                        <button type="submit" class="btn">View Trackers</button>
                    </form>

                    <form action="FinalReport.jsp" method="get">
                        <input type="hidden" name="campaign_id" value="<%= campaignId %>">
                        <button type="submit" class="btn">Submit Final Report</button>
                    </form>

                    <form action="MarkAttendance" method="get">
                        <input type="hidden" name="campaign_id" value="<%= campaignId %>">
                        <button type="submit" class="btn">Mark Attendance</button>
                    </form>

                    <form action="ViewAttendance.jsp" method="get">
                        <input type="hidden" name="campaign_id" value="<%= campaignId %>">
                        <button type="submit" class="btn">View Attendance</button>
                    </form>
                </div>
            </td>
        </tr>
        <%
                }
            } catch (Exception e) {
                out.println("<tr><td colspan='8'>Error: " + e.getMessage() + "</td></tr>");
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            }
        %>
    </table>

</body>
</html>
