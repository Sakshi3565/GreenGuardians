<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Integer managerId = (Integer) session.getAttribute("staff_id");
    if (managerId == null) {
        response.sendRedirect("login.jsp?error=Please login first");
        return;
    }

    String campaignIdParam = request.getParameter("campaign_id");
    int campaignId = -1;
    if (campaignIdParam != null && !campaignIdParam.isEmpty()) {
        campaignId = Integer.parseInt(campaignIdParam);
    } else {
        response.sendRedirect("ManagerDashboard.jsp?error=Invalid campaign ID");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>

<html>
<head>
    <title>Manage Participants</title>
    <style>
        body {
            font-family: Arial;
            background: #f0f0f0;
            padding: 20px;
        }

        .container {
            background: white;
            padding: 20px;
            border-radius: 10px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        table, th, td {
            border: 1px solid #ccc;
        }

        th, td {
            padding: 10px;
        }

        h2 {
            color: #2b2b2b;
        }

        .btn-danger {
            background: #e74c3c;
            color: white;
            padding: 5px 10px;
            border: none;
            cursor: pointer;
        }

        .btn-danger:hover {
            background: #c0392b;
        }

        .section {
            margin-top: 30px;
        }

        .date-label {
            font-weight: bold;
            color: #333;
            margin-top: 10px;
        }
    </style>
    <script>
        function confirmRemove() {
            return confirm("Are you sure you want to remove this participant from the campaign?");
        }
    </script>
</head>
<body>
<div class="container">
    <h2>🌱 Manage Participants</h2>

    <table>
        <tr>
            <th>Participant Name</th>
            <th>Participation Date</th>
            <th>Attendance (Days Present)</th>
            <th>Reports</th>
            <th>Action</th>
        </tr>
        <%
            try {
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/yourdatabase", "root", "password");

                String participantQuery = "SELECT cp.user_id, u.name, cp.participation_date FROM campaign_participation cp JOIN users u ON cp.user_id = u.user_id WHERE cp.campaign_id = ?";
                ps = conn.prepareStatement(participantQuery);
                ps.setInt(1, campaignId);
                rs = ps.executeQuery();

                while (rs.next()) {
                    int userId = rs.getInt("user_id");
                    String userName = rs.getString("name");
                    java.sql.Timestamp participationDate = rs.getTimestamp("participation_date");

        %>
        <tr>
            <td><%= userName %></td>
            <td><%= participationDate %></td>
            <td>
                <%
                    String countQuery = "SELECT COUNT(*) AS present_count FROM campaign_attendance WHERE campaign_id = ? AND user_id = ? AND status = 'Present'";
                    PreparedStatement countStmt = conn.prepareStatement(countQuery);
                    countStmt.setInt(1, campaignId);
                    countStmt.setInt(2, userId);

                    ResultSet countRs = countStmt.executeQuery();

                    int presentCount = 0;
                    if (countRs.next()) {
                        presentCount = countRs.getInt("present_count");
                    }
                    countRs.close();
                    countStmt.close();
                %>
                <%= presentCount %> days
            </td>
            <td>
                <%
                    String repQuery = "SELECT date, trees_planted, notes FROM planting_records WHERE campaign_id = ? AND user_id = ? ORDER BY date DESC";
                    PreparedStatement repStmt = conn.prepareStatement(repQuery);
                    repStmt.setInt(1, campaignId);
                    repStmt.setInt(2, userId);
                    ResultSet repRs = repStmt.executeQuery();
                    while (repRs.next()) {
                %>
                    <div class="date-label">
                        <%= repRs.getDate("date") %>:
                        <strong>Planted:</strong> <%= repRs.getInt("trees_planted") %>,
                        <strong>Notes:</strong> <%= repRs.getString("notes") %>
                    </div>
                <%
                    }
                    repRs.close();
                    repStmt.close();
                %>
            </td>
            <td>
                <form method="post" action="RemoveParticipant" onsubmit="return confirmRemove();">
                    <input type="hidden" name="campaign_id" value="<%= campaignId %>">
                    <input type="hidden" name="user_id" value="<%= userId %>">
                    <button type="submit" class="btn btn-danger">Remove</button>
                </form>
            </td>
        </tr>
        <% 
                }
                rs.close();
                ps.close();
                conn.close();
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            }
        %>
    </table>
</div>
</body>
</html>
