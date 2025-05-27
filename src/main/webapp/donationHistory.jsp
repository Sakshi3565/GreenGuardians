<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    HttpSession sessionObj = request.getSession(false); 
    if (sessionObj == null || sessionObj.getAttribute("email") == null) {
        response.sendRedirect("User_Login.jsp?error=Please login first");
        return; 
    }

    String email = (String) sessionObj.getAttribute("email");

    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
    List<Map<String, String>> donations = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/yourdatabase", "root", "password");
        stmt = conn.createStatement();
        rs = stmt.executeQuery("SELECT user_id FROM users WHERE email = '" + email + "'");
        int userId = -1;
        if (rs.next()) {
            userId = rs.getInt("user_id");
        }

        if (userId != -1) {
            rs = stmt.executeQuery("SELECT c.title, d.amount, d.donation_date, d.method, d.card_no, d.upi_id FROM donations d "
                    + "JOIN campaigns c ON d.campaign_id = c.campaign_id WHERE d.user_id = " + userId);

            while (rs.next()) {
                Map<String, String> donation = new HashMap<>();
                donation.put("title", rs.getString("title"));
                donation.put("amount", rs.getString("amount"));
                donation.put("date", sdf.format(rs.getTimestamp("donation_date")));
                donation.put("method", rs.getString("method"));
                donation.put("card_no", rs.getString("card_no"));
                donation.put("upi_id", rs.getString("upi_id"));
                donations.add(donation);
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>
<html>
<head>
    <title>Donation History</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f4f7f6;
            color: #333;
            padding: 20px;
        }
        h2 {
            text-align: center;
            color: #2b6cb0;
            margin-bottom: 30px;
        }
        .donation-table {
            width: 100%;
            border-collapse: collapse;
            margin: 0 auto;
        }
        .donation-table th, .donation-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        .donation-table th {
            background-color: #2b6cb0;
            color: white;
        }
        .donation-table tr:hover {
            background-color: #f1f1f1;
        }
        .no-donations {
            text-align: center;
            font-size: 18px;
            color: #888;
        }
    </style>
</head>
<body>

    <h2>Donation History</h2>

    <% if (donations.isEmpty()) { %>
        <p class="no-donations">You have not made any donations yet.</p>
    <% } else { %>
        <table class="donation-table">
            <thead>
                <tr>
                    <th>Campaign Title</th>
                    <th>Donation Amount</th>
                    <th>Donation Date</th>
                    <th>Payment Method</th>
                    <th>Card Number</th>
                    <th>UPI ID</th>
                </tr>
            </thead>
            <tbody>
                <% for (Map<String, String> donation : donations) { %>
                    <tr>
                        <td><%= donation.get("title") %></td>
                        <td><%= donation.get("amount") %></td>
                        <td><%= donation.get("date") %></td>
                        <td><%= donation.get("method") %></td>
                        <td><%= donation.get("card_no") != null ? donation.get("card_no") : "N/A" %></td>
                        <td><%= donation.get("upi_id") != null ? donation.get("upi_id") : "N/A" %></td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    <%  }  %>

</body>
</html>
