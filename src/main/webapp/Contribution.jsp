<%@ page import="java.sql.*, java.util.*, javax.servlet.http.HttpSession" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("email") == null) {
        response.sendRedirect("User_Login.jsp?error=Please login first");
        return;
    }

    String email = (String) sessionObj.getAttribute("email");
    int userId = -1;

    List<String[]> contributions = new ArrayList<>();

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/yourdatabase", "root", "password");

        // Get user ID from email
        ps = conn.prepareStatement("SELECT user_id FROM users WHERE email = ?");
        ps.setString(1, email);
        rs = ps.executeQuery();
        if (rs.next()) {
            userId = rs.getInt("user_id");
        }
        rs.close();
        ps.close();

        // Fetch contributions
        String query = "SELECT c.title, c.location, c.start_date, c.end_date, c.status, COUNT(cp.id) AS days_present " +
                       "FROM campaigns c " +
                       "JOIN campaign_participation cp ON c.campaign_id = cp.campaign_id " +
                       "WHERE cp.user_id = ? " +
                       "GROUP BY c.campaign_id";
        ps = conn.prepareStatement(query);
        ps.setInt(1, userId);
        rs = ps.executeQuery();

        while (rs.next()) {
            String[] row = new String[6];
            row[0] = rs.getString("title");
            row[1] = rs.getString("location");
            row[2] = rs.getString("start_date");
            row[3] = rs.getString("end_date");
            row[4] = rs.getString("status");
            row[5] = rs.getString("days_present");
            contributions.add(row);
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
    <title>Your Contributions</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f4f6f8;
            margin: 40px;
            color: #34495e;
        }

        .container {
            max-width: 900px;
            margin: auto;
            background-color: #ffffff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.08);
        }

        h2 {
            text-align: center;
            color: #2f4858;
            margin-bottom: 30px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        th, td {
            padding: 14px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #dde8f0;
            color: #2f4858;
        }

        tr:hover {
            background-color: #f1f5f9;
        }

        .back-btn {
            display: block;
            margin: 30px auto 0;
            padding: 10px 20px;
            background-color: #5c6f7b;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            text-align: center;
            width: fit-content;
        }

        .back-btn:hover {
            background-color: #46535d;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>🌱 Your Contributions</h2>

    <% if (contributions.isEmpty()) { %>
        <p style="text-align:center;">You haven’t participated in any campaigns yet.</p>
    <% } else { %>
        <table>
            <thead>
                <tr>
                    <th>Campaign Title</th>
                    <th>Location</th>
                    <th>Start Date</th>
                    <th>End Date</th>
                    <th>Status</th>
                    <th>Days Present</th>
                </tr>
            </thead>
            <tbody>
                <% for (String[] row : contributions) { %>
                    <tr>
                        <td><%= row[0] %></td>
                        <td><%= row[1] %></td>
                        <td><%= row[2] %></td>
                        <td><%= row[3] %></td>
                        <td><%= row[4] %></td>
                        <td><%= row[5] %></td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    <% } %>

    <a href="User_Dashboard.jsp" class="back-btn">← Back to Dashboard</a>
</div>

</body>
</html>
