<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("email") == null) {
        response.sendRedirect("User_Login.jsp?error=Please login first");
        return;
    }

    String email = (String) sessionObj.getAttribute("email");
    String campaignId = request.getParameter("campaign_id");

    if (campaignId == null || campaignId.trim().isEmpty()) {
        out.println("<p style='color:red;'>Invalid campaign.</p>");
        return;
    }

    List<Map<String, String>> records = new ArrayList<>();
    Set<String> submittedDates = new HashSet<>();

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/yourdatabase", "root", "password");

        String query = "SELECT * FROM planting_records WHERE campaign_id = ? AND user_id = (SELECT user_id FROM users WHERE email = ?) ORDER BY date DESC";
        ps = conn.prepareStatement(query);
        ps.setString(1, campaignId);
        ps.setString(2, email);
        rs = ps.executeQuery();

        while (rs.next()) {
            Map<String, String> record = new HashMap<>();
            record.put("date", rs.getString("date"));
            record.put("trees", rs.getString("trees_planted"));
            record.put("notes", rs.getString("notes"));
            records.add(record);
            submittedDates.add(rs.getString("date"));
        }
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }

    String today = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
    boolean submittedToday = submittedDates.contains(today);
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Planting Records</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f0f4f8;
            padding: 40px;
            color: #333;
        }
        h2 {
            color: #2b6cb0;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
        }
        th, td {
            border: 1px solid #ccc;
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #e2ecf9;
        }
        tr:nth-child(even) {
            background-color: #f9fcff;
        }
        .form-box {
            background-color: #fff;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            max-width: 600px;
            margin: auto;
        }
        label {
            font-weight: bold;
            display: block;
            margin-top: 15px;
        }
        input[type="number"], textarea {
            width: 100%;
            padding: 10px;
            margin-top: 8px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }
        button {
            margin-top: 20px;
            padding: 12px 20px;
            background-color: #2b6cb0;
            color: #fff;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }
        button:hover {
            background-color: #254e80;
        }
        .back-btn {
            display: inline-block;
            margin-top: 20px;
            color: #2b6cb0;
            text-decoration: none;
        }
    </style>
</head>
<body>

<h2>📅 Your Submitted Planting Records</h2>

<% if (records.isEmpty()) { %>
    <p>You haven't submitted any records yet for this campaign.</p>
<% } else { %>
    <table>
        <thead>
        <tr>
            <th>Date</th>
            <th>Trees Planted</th>
            <th>Notes</th>
        </tr>
        </thead>
        <tbody>
        <% for (Map<String, String> record : records) { %>
            <tr>
                <td><%= record.get("date") %></td>
                <td><%= record.get("trees") %></td>
                <td><%= record.get("notes") == null ? "—" : record.get("notes") %></td>
            </tr>
        <% } %>
        </tbody>
    </table>
<% } %>

<% if (!submittedToday) { %>
<div class="form-box">
    <h3>🌱 Submit Today’s Record</h3>
    <form action="PlantingRecords" method="post">
        <input type="hidden" name="campaign_id" value="<%= campaignId %>">
        <label for="trees">Trees Planted:</label>
        <input type="number" id="trees" name="trees_planted" min="0" required>

        <label for="notes">Notes (optional):</label>
        <textarea id="notes" name="notes" rows="4" placeholder="Any remarks or notes..."></textarea>

        <button type="submit">Submit Record</button>
    </form>
</div>
<% } else { %>
    <p style="color: green;"><strong>You’ve already submitted a record for today (<%= today %>).</strong></p>
<% } %>

<a href="ParticipatedCampaigns" class="back-btn">← Back to Campaigns</a>

</body>
</html>
