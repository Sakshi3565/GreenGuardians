<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    int campaignId = Integer.parseInt(request.getParameter("campaign_id"));
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String campaignTitle = "", campaignType = "";
%>
<html>
<head>
    <title>Trackers for Campaign</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f0f4f8;
            padding: 30px;
            color: #333;
        }
        h2 {
            color: #3366cc;
            margin-bottom: 20px;
        }
        .tracker-card {
            background-color: #fff;
            padding: 20px;
            margin-bottom: 25px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
            border-radius: 10px;
        }
        .tracker-card h3 {
            color: #003366;
            margin-bottom: 10px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 12px;
        }
        th, td {
            border: 1px solid #ccc;
            padding: 10px 14px;
            text-align: left;
        }
        th {
            background-color: #e0ebff;
            color: #003366;
        }
        .no-data {
            color: #999;
            font-style: italic;
        }

        #photoDisplay {
            text-align: center;
            display: none; /* Hide by default */
            padding: 20px;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.5); /* Overlay effect */
            z-index: 1000;
        }

        #photoDisplay img {
            max-width: 90%;
            max-height: 80vh;
            border: 4px solid #fff;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.4);
            margin-bottom: 20px;
        }

        #closeButton {
            background-color: #ff4d4d;
            color: white;
            border: none;
            padding: 12px 24px;
            cursor: pointer;
            font-size: 16px;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        #closeButton:hover {
            background-color: #e60000;
        }
    </style>
    <script>
        function showPhoto(photoUrl) {
            const displayDiv = document.getElementById("photoDisplay");
            const imgElement = document.getElementById("photo");
            const closeButton = document.getElementById("closeButton");

           
            displayDiv.style.display = "block";
            imgElement.src = photoUrl;
        }

        function closePhoto() {
            const displayDiv = document.getElementById("photoDisplay");
            displayDiv.style.display = "none";
        }
    </script>
</head>
<body>

<%
try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/greenguardians", "root", "Sakshi@3565");

    PreparedStatement campaignPs = conn.prepareStatement("SELECT title, campaign_type FROM campaigns WHERE campaign_id = ?");
    campaignPs.setInt(1, campaignId);
    ResultSet campaignRs = campaignPs.executeQuery();
    if (campaignRs.next()) {
        campaignTitle = campaignRs.getString("title");
        campaignType = campaignRs.getString("campaign_type");
    }
    campaignRs.close();
    campaignPs.close();
%>

<h2>📋 Trackers for Campaign: <%= campaignTitle %> (<%= campaignType %>)</h2>

<%
    String trackerQuery = "SELECT s.staff_id, s.name FROM staff s " +
                          "JOIN campaign_assignment ca ON s.staff_id = ca.staff_id " +
                          "WHERE ca.campaign_id = ? AND s.role = 'Tracker'";
    ps = conn.prepareStatement(trackerQuery);
    ps.setInt(1, campaignId);
    rs = ps.executeQuery();

    boolean hasTrackers = false;
%>

<div id="photoDisplay">
    <img id="photo" alt="Report Photo">
    <button id="closeButton" onclick="closePhoto()">Close Photo</button>
</div>

<%
    while (rs.next()) {
        hasTrackers = true;
        int trackerId = rs.getInt("staff_id");
        String trackerName = rs.getString("name");
%>
    <div class="tracker-card">
        <h3>👤 <%= trackerName %> (ID: <%= trackerId %>)</h3>

        <%
            PreparedStatement reportPs = null;
            ResultSet reportRs = null;
            try {
                String reportQuery = "SELECT * FROM tracker_records WHERE campaign_id = ? AND staff_id = ? ORDER BY date DESC";
                reportPs = conn.prepareStatement(reportQuery);
                reportPs.setInt(1, campaignId);
                reportPs.setInt(2, trackerId);
                reportRs = reportPs.executeQuery();

                boolean hasReports = false;
        %>

        <table>
            <tr>
                <th>Date</th>
                <% if ("Planting".equalsIgnoreCase(campaignType)) { %>
                    <th>Trees Planted</th>
                    <th>Saplings Damaged</th>
                    <th>Area Covered</th>
                <% } else { %>
                    <th>Attendees</th>
                    <th>Activities</th>
                    <th>Feedback</th>
                    <th>Challenges</th>
                    <th>Suggestions</th>
                    <th>Photo</th>
                <% } %>
                <th>Notes</th>
                <th>Submitted At</th>
            </tr>

            <%
                while (reportRs.next()) {
                    hasReports = true;
            %>
                <tr>
                    <td><%= reportRs.getDate("date") %></td>

                    <% if ("Planting".equalsIgnoreCase(campaignType)) { %>
                        <td><%= reportRs.getInt("trees_planted") %></td>
                        <td><%= reportRs.getInt("saplings_damaged") %></td>
                        <td><%= reportRs.getString("area_covered") %></td>
                    <% } else { %>
                        <td><%= reportRs.getInt("attendees") %></td>
                        <td><%= reportRs.getString("activities_conducted") %></td>
                        <td><%= reportRs.getString("feedback") %></td>
                        <td><%= reportRs.getString("challenges") %></td>
                        <td><%= reportRs.getString("suggestions") %></td>
                        <td>
                            <%
                                String photoPath = reportRs.getString("photo_path");
                            %>
                            <% if (photoPath != null && !photoPath.trim().isEmpty()) { %>
                                <button onclick="showPhoto('<%= request.getContextPath() + "/" + photoPath %>')">View Photo</button>
                            <% } else { %>
                                <p>No photo uploaded.</p>
                            <% } %>
                        </td>
                    <% } %>

                    <td><%= reportRs.getString("notes") %></td>
                    <td><%= reportRs.getTimestamp("submitted_at") %></td>
                </tr>
            <%
                }

                if (!hasReports) {
            %>
                <tr><td colspan="10" class="no-data">No reports submitted yet.</td></tr>
            <%
                }

            } finally {
                if (reportRs != null) reportRs.close();
                if (reportPs != null) reportPs.close();
            }
        %>
        </table>
    </div>
<%
    }

    if (!hasTrackers) {
%>
    <p class="no-data">No trackers assigned to this campaign.</p>
<%
    }

} catch (Exception e) {
    out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
} finally {
    if (rs != null) rs.close();
    if (ps != null) ps.close();
    if (conn != null) conn.close();
}
%>

</body>
</html>
