<%@ page import="java.sql.*, java.text.*, java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Integer trackerId = (Integer) session.getAttribute("staff_id");
    if (trackerId == null) {
        response.sendRedirect("login.jsp?error=Please login first");
        return;
    }

    String campaignType = "";
    String campaignTitle = "";
    int campaignId = -1;
    ResultSet rs = null;

    try {
        String campaignIdParam = request.getParameter("campaign_id");
        if (campaignIdParam != null && !campaignIdParam.isEmpty()) {
            campaignId = Integer.parseInt(campaignIdParam);
        }

        if (campaignId == -1) {
            response.sendRedirect("tracker_dashboard.jsp?error=Invalid campaign ID");
            return;
        }

        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/yourdatabase", "root", "password");

        PreparedStatement ps = conn.prepareStatement("SELECT title, campaign_type FROM campaigns WHERE campaign_id = ?");
        ps.setInt(1, campaignId);
        rs = ps.executeQuery();

        if (rs.next()) {
            campaignTitle = rs.getString("title");
            campaignType = rs.getString("campaign_type");
        } else {
            response.sendRedirect("tracker_dashboard.jsp?error=Campaign not found");
            return;
        }
        rs.close();
        ps.close();
        conn.close();

    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }
%>

<html>
<head>
    <title>View Report</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f4f4f4;
        }

        .form-box {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .form-box h2 {
            color: #333;
        }

        .form-box label {
            font-weight: bold;
            margin-top: 10px;
            display: block;
            color: #555;
        }

        .report-container {
            margin-top: 20px;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .report-item {
            background-color: #e9f7f9;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }

        .report-item label {
            display: inline-block;
            width: 200px;
            font-weight: normal;
            color: #555;
        }

        .form-box img {
            display: none;
            margin-top: 10px;
            width: 200px;
        }

        .form-box img.show {
            display: block;
        }

        .view-photo-btn {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 10px;
            cursor: pointer;
            margin-top: 10px;
        }

        .view-photo-btn:hover {
            background-color: #45a049;
        }

        .form-box p {
            color: red;
        }

    </style>
    <script>
        function toggleImage(reportId) {
            var img = document.getElementById("uploadedPhoto_" + reportId);
            img.classList.toggle("show");
        }
    </script>
</head>
<body>
    <div class="form-box">
        <h2>📋 View Report - <%= campaignTitle %> (<%= campaignType %>)</h2>

        <form action="TrackerReport" method="post" enctype="multipart/form-data">
            <input type="hidden" name="campaign_id" value="<%= campaignId %>">
            <input type="hidden" name="campaign_type" value="<%= campaignType %>">
        </form>
    </div>

    <div class="form-box report-container">
        <% 
            // Fetch all reports for the tracker for the specific campaign (including all dates)
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/greenguardians", "root", "Sakshi@3565");
            PreparedStatement reportQuery = conn.prepareStatement("SELECT * FROM tracker_records WHERE campaign_id = ? AND staff_id = ? ORDER BY date DESC");
            reportQuery.setInt(1, campaignId);
            reportQuery.setInt(2, trackerId);
            rs = reportQuery.executeQuery();
            
            if (!rs.isBeforeFirst()) { 
        %>
            <p>No reports found for this campaign.</p>
        <% } else { 
                while (rs.next()) { 
                    String reportId = rs.getString("record_id");
        %>
        <div class="report-item">
            <div>
                <label>Date of Report:</label>
                <%= new SimpleDateFormat("MMMM dd, yyyy").format(rs.getDate("date")) %>
            </div>

            <% if ("Planting".equalsIgnoreCase(campaignType)) { %>
            <div>
                <label>Trees Planted:</label>
                <%= rs.getInt("trees_planted") %>
            </div>

            <div>
                <label>Saplings Damaged:</label>
                <%= rs.getInt("saplings_damaged") %>
            </div>

            <div>
                <label>Area Covered:</label>
                <%= rs.getString("area_covered") %>
            </div>
            <% } else if ("Awareness".equalsIgnoreCase(campaignType)) { %>
            <div>
                <label>Number of Attendees:</label>
                <%= rs.getInt("attendees") %>
            </div>

            <div>
                <label>Activities Conducted:</label>
                <%= rs.getString("activities_conducted") %>
            </div>

            <div>
                <label>Feedback:</label>
                <%= rs.getString("feedback") %>
            </div>

            <div>
                <label>Challenges Faced:</label>
                <%= rs.getString("challenges") %>
            </div>

            <div>
                <label>Suggestions for Improvement:</label>
                <%= rs.getString("suggestions") %>
            </div>

            <div>
                <label>Uploaded Photos:</label>
                <% if (rs.getString("photo_path") != null) { %>
                    <button type="button" class="view-photo-btn" onclick="toggleImage('<%= reportId %>')">View Photo</button>
                    <img id="uploadedPhoto_<%= reportId %>" src="<%= rs.getString("photo_path") %>" alt="Uploaded Photo">
                <% } else { %>
                    No photos uploaded.
                <% } %>
            </div>
            <% } %>

            <div>
                <label>Additional Notes:</label>
                <%= rs.getString("notes") %>
            </div>
        </div>
        <% } 
            }
            rs.close();
            conn.close();
        %>
    </div>
</body>
</html>
