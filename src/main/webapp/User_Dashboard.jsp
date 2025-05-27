<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    HttpSession sessionObj = request.getSession(false); // Get existing session, don't create a new one
    if (sessionObj == null || sessionObj.getAttribute("email") == null) {
        response.sendRedirect("User_Login.jsp?error=Please login first");
        return; // Stop further execution
    }
    // Fetch messages from request attributes
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
%>
<html>
<head>
    <title>User Dashboard</title>
    <link rel="stylesheet" href="userdash.css">
</head>
<body>

   <script>
    window.onload = function () {
        <% if (error != null) { %>
            alert("<%= error %>");
        <% } else if (success != null) { %>
            alert("<%= success %>");
        <% } %>
    };
</script>

    <div class="header">
        <h2>User Dashboard</h2>
        <div class="profile-container">
            <div class="profile-icon">👤</div>
            <div class="dropdown-menu">
                <a href="ProfileServlet">My Profile</a>
                <a href="ParticipatedCampaigns">Participated Campaigns</a>
                <a href="donationHistory.jsp">Donation History</a>
                <a href="Contribution.jsp">My Contribution</a>
                <a href="logout.jsp">Logout</a>
            </div>
        </div>
    </div>

    <!-- Alerts for Error or Success -->
    <%
        if (error != null) {
            out.println("<div class='alert'>" + error + "</div>");
        } else if (success != null) {
            out.println("<div class='alert success'>" + success + "</div>");
        }
    %>

    <!-- Campaign List -->
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
        %>
        <div class="campaign-card">
            <span class="status"><%= rs.getString("status") %></span>
            <h3><%= rs.getString("title") %></h3>
            <p><strong>Start Date:</strong> <%= sdf.format(rs.getDate("start_date")) %></p>
            <p><strong>End Date:</strong> <%= sdf.format(rs.getDate("end_date")) %></p>
            <p><strong>Type:</strong> <%= rs.getString("campaign_type") %></p>
            <a href="ViewCampaign?id=<%= rs.getInt("campaign_id") %>" class="view-details">View Details</a>
        </div>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        %>
    </div>
</body>
</html>
