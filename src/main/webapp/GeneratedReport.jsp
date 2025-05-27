<%@ page import="java.sql.*, java.text.*, java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    ResultSet campaignRs = null;

    try {
      
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/yourdatabase", "root", "password");
        stmt = conn.createStatement();
        String query = "SELECT c.campaign_id, c.title, c.campaign_type, c.status FROM campaigns c WHERE c.status = 'Completed'";
        campaignRs = stmt.executeQuery(query);
        String reportQuery = "SELECT * FROM campaign_manager_reports WHERE campaign_id = ?";
        
        while (campaignRs.next()) {
            int campaignId = campaignRs.getInt("campaign_id");
            String campaignTitle = campaignRs.getString("title");
            String campaignType = campaignRs.getString("campaign_type");
            PreparedStatement ps = conn.prepareStatement(reportQuery);
            ps.setInt(1, campaignId);
            rs = ps.executeQuery();

            if (rs.next()) {
                // Extract report data
                int totalTreesPlanted = rs.getInt("total_trees_planted");
                int totalSaplingsDamaged = rs.getInt("total_saplings_damaged");
                String areaCovered = rs.getString("area_covered");
                int attendees = rs.getInt("attendees");
                String activitiesConducted = rs.getString("activities_conducted");
                String feedback = rs.getString("feedback");
                String challenges = rs.getString("challenges");
                String suggestions = rs.getString("suggestions");
                String photoPath = rs.getString("final_photo_path");
                String notes = rs.getString("notes");
                out.println("<div class='campaign-report'>");
                out.println("<h3>" + campaignTitle + " (" + campaignType + ")</h3>");
                
                if ("Planting".equalsIgnoreCase(campaignType)) {
                    out.println("<p><strong>Total Trees Planted:</strong> " + totalTreesPlanted + "</p>");
                    out.println("<p><strong>Total Saplings Damaged:</strong> " + totalSaplingsDamaged + "</p>");
                    out.println("<p><strong>Area Covered:</strong> " + areaCovered + "</p>");
                } else if ("Awareness".equalsIgnoreCase(campaignType)) {
                    out.println("<p><strong>Number of Attendees:</strong> " + attendees + "</p>");
                    out.println("<p><strong>Activities Conducted:</strong> " + activitiesConducted + "</p>");
                    out.println("<p><strong>Feedback Summary:</strong> " + feedback + "</p>");
                    out.println("<p><strong>Challenges Faced:</strong> " + challenges + "</p>");
                    out.println("<p><strong>Suggestions for Improvement:</strong> " + suggestions + "</p>");
                }
                out.println("<p><strong>Final Photo:</strong> <img src='" + photoPath + "' alt='Final Photo' width='200' /></p>");
                out.println("<p><strong>Additional Notes:</strong> " + notes + "</p>");
                out.println("</div>");
            }
        }
        
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        try {
            if (rs != null) rs.close();
            if (campaignRs != null) campaignRs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException ex) {
            out.println("<p style='color:red;'>Error closing resources: " + ex.getMessage() + "</p>");
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Completed Campaign Reports</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 20px;
        }

        .campaign-report {
            background-color: #fff;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .campaign-report h3 {
            margin-top: 0;
            color: #2c3e50;
        }

        .campaign-report p {
            font-size: 14px;
            color: #34495e;
        }

        .campaign-report img {
            border-radius: 4px;
        }

        .campaign-report p strong {
            color: #16a085;
        }

        .btn {
            background-color: #3498db;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
        }

        .btn:hover {
            background-color: #2980b9;
        }
    </style>
</head>
<body>

<h2>Admin Dashboard - Completed Campaign Reports</h2>


</body>
</html>
