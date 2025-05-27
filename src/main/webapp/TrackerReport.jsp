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
    boolean alreadySubmitted = false;

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

        // Fetch campaign details
        PreparedStatement ps = conn.prepareStatement("SELECT title, campaign_type FROM campaigns WHERE campaign_id = ?");
        ps.setInt(1, campaignId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            campaignTitle = rs.getString("title");
            campaignType = rs.getString("campaign_type");
        } else {
            response.sendRedirect("tracker_dashboard.jsp?error=Campaign not found");
            return;
        }
        rs.close();
        ps.close();

        // ✅ Check if today's report already exists
        PreparedStatement check = conn.prepareStatement(
            "SELECT COUNT(*) FROM tracker_records WHERE campaign_id = ? AND staff_id = ? AND date = CURDATE()");
        check.setInt(1, campaignId);
        check.setInt(2, trackerId);
        ResultSet rcheck = check.executeQuery();
        if (rcheck.next() && rcheck.getInt(1) > 0) {
            alreadySubmitted = true;
        }
        rcheck.close();
        check.close();
        conn.close();

    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }
%>

<html>
<head>
    <title>Submit Report</title>
    <style>
        body { font-family: Arial; background-color: #f0f5f0; padding: 20px; }
        label { font-weight: bold; }
        input, textarea, select { width: 100%; padding: 8px; margin-bottom: 15px; border: 1px solid #ccc; border-radius: 4px; }
        .btn { background-color: #4CAF50; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; }
        .form-box { max-width: 700px; margin: auto; background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .disabled { background-color: #aaa; cursor: not-allowed; }
        .message { padding: 10px; margin-bottom: 15px; border-radius: 5px; }
        .info { background-color: #e7f3fe; color: #31708f; border: 1px solid #bce8f1; }
    </style>
    <script>
    function showFields() {
        var type = '<%= campaignType %>';
        var planting = document.getElementById('plantingFields');
        var awareness = document.getElementById('awarenessFields');

        if (type === 'Planting') {
            planting.style.display = 'block';
            awareness.style.display = 'none';
            toggleRequired(planting, true);
            toggleRequired(awareness, false);
        } else if (type === 'Awareness') {
            planting.style.display = 'none';
            awareness.style.display = 'block';
            toggleRequired(planting, false);
            toggleRequired(awareness, true);
        }
    }

    function toggleRequired(section, isRequired) {
        var inputs = section.querySelectorAll("input, textarea");
        inputs.forEach(function(el) {
            if (isRequired) {
                el.setAttribute("required", "true");
            } else {
                el.removeAttribute("required");
            }
        });
    }

    // Run on page load
    window.onload = showFields;
</script>
    
</head>
<body onload="showFields()">
<%
    String message = (String) request.getAttribute("message");
    if (message != null) {
%>
    <div style="background-color: #e0ffe0; color: green; border-left: 4px solid green; padding: 10px; margin-bottom: 15px; border-radius: 4px;">
        <%= message %>
    </div>
<% } %>

    <div class="form-box">
        <h2>📋 Submit Report - <%= campaignTitle %> (<%= campaignType %>)</h2>

        <% if (alreadySubmitted) { %>
            <div class="message info">
                ✅ You have already submitted your report for today. Thank you!
            </div>
        <% } else { %>
            <form action="TrackerReport" method="post" enctype="multipart/form-data">
                <input type="hidden" name="campaign_id" value="<%= campaignId %>">
                <input type="hidden" name="campaign_type" value="<%= campaignType %>">

                <!-- Planting Fields -->
                <div id="plantingFields">
                    <label>Trees Planted:</label>
                    <input type="number" name="trees_planted" min="0" required>

                    <label>Saplings Damaged:</label>
                    <input type="number" name="saplings_damaged" min="0" required>

                    <label>Area Covered (sq. meters):</label>
                    <input type="text" name="area_covered" required>
                </div>

                <!-- Awareness Fields -->
                <div id="awarenessFields">
                    <label>Number of Attendees:</label>
                    <input type="number" name="attendees" min="0" required>

                    <label>Activities Conducted:</label>
                    <textarea name="activities_conducted" rows="3" required></textarea>

                    <label>Feedback Summary:</label>
                    <textarea name="feedback" rows="3" required></textarea>

                    <label>Challenges Faced:</label>
                    <textarea name="challenges" rows="2"></textarea>

                    <label>Suggestions for Improvement:</label>
                    <textarea name="suggestions" rows="2"></textarea>

                    <label>Upload Photos:</label>
                    <input type="file" name="photo" accept="image/*">
                </div>

                <!-- Common -->
                <label>Additional Notes:</label>
                <textarea name="notes" rows="2"></textarea>

                <button class="btn" type="submit">Submit Report</button>
            </form>
        <% } %>
    </div>
</body>
</html>
