<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="green.DBConnection" %> 
<%@ page import="java.sql.*" %>
<%
    String campaignId = request.getParameter("campaignId");
    String campaignName = "";

    if (campaignId != null) {
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("SELECT campaign_title FROM campaigns WHERE campaign_id = ?");
            stmt.setInt(1, Integer.parseInt(campaignId));
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                campaignName = rs.getString("campaign_title");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    if (campaignName == null || campaignName.isEmpty()) {
        campaignName = "the campaign";
    }
%>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Donation Successful</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f7f7f7;
            color: #333;
        }

        /* Main Container Styling */
        .message-container {
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
            padding: 40px;
            width: 80%;
            max-width: 700px;
            margin: 50px auto;
            text-align: center;
        }

        /* Header Message */
        .thank-you-msg {
            font-size: 30px;
            color: #2c3e50;
            font-weight: 600;
            margin-bottom: 25px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* Campaign Name Styling */
        .campaign-name {
            font-size: 26px;
            font-weight: 700;
            color: #27ae60;
            margin-top: 20px;
        }

        /* Details Styling */
        .details {
            font-size: 18px;
            color: #7f8c8d;
            line-height: 1.8;
            margin-top: 20px;
        }

        /* Button Styling */
        .btn {
            display: inline-block;
            background-color: #2980b9;
            color: white;
            padding: 14px 28px;
            text-decoration: none;
            font-size: 18px;
            border-radius: 6px;
            margin-top: 30px;
            transition: background-color 0.3s ease;
        }

        .btn:hover {
            background-color: #3498db;
        }

        /* Footer Section */
        .footer {
            font-size: 14px;
            color: #bdc3c7;
            margin-top: 50px;
        }

        .footer a {
            color: #2980b9;
            text-decoration: none;
        }

        .footer a:hover {
            text-decoration: underline;
        }

    </style>
</head>
<body>

    <div class="message-container">
        <h1 class="thank-you-msg">Thank You for Your Donation!</h1>
        <p>Your generous donation has been successfully processed. We are truly grateful for your support!</p>

        <p class="campaign-name">You have donated to the <%= campaignName %> campaign!</p>

        <div class="details">
            <p>We are thrilled to have you as a part of this effort. Together, we can make a real difference!</p>
            <p>Stay tuned for updates on the campaign's progress.</p>
        </div>

        <a href="index.jsp" class="btn">Return to Homepage</a> <!-- Button to go back to homepage or another page -->

        <div class="footer">
            <p>&copy; 2025 GreenGuardians. All Rights Reserved.</p>
            <p>Want to learn more about us? <a href="about.jsp">Click here</a></p>
        </div>
    </div>

</body>
</html>
