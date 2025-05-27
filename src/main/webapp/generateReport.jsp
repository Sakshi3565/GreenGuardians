<%@ page import="java.sql.*, java.text.*, java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.ArrayList" %>

<%
HttpSession sessionObj = request.getSession(false); 
if (sessionObj == null || sessionObj.getAttribute("username") == null) {
    response.sendRedirect("login.jsp?error=Please login first");
    return; 
}

List<String> campaigns = new ArrayList<>();
try {
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/greenguardians", "root", "Sakshi@3565");

    PreparedStatement ps = conn.prepareStatement("SELECT campaign_id, title FROM campaigns WHERE status = 'Completed'");
    ResultSet rs = ps.executeQuery();

    while (rs.next()) {
        campaigns.add("ID: " + rs.getInt("campaign_id") + " - " + rs.getString("title"));
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
    <title>Admin - View Completed Campaigns</title>
    <style>
    
    /* Body Styles */
    body {
        font-family: 'Arial', sans-serif;
        background-color: #f1f6f9;
        margin: 0;
        padding: 0;
        color: #333;
    }

    h2 {
        color: #2e3d49;
        text-align: center;
        margin-top: 40px;
    }

    h3 {
        color: #2e3d49;
        margin-bottom: 20px;
    }

    /* Main Form Box Styles */
    .form-box {
        max-width: 900px;
        margin: 40px auto;
        background: #fff;
        padding: 30px;
        border-radius: 10px;
        box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        border-top: 5px solid #4e73df;
    }

    /* Button Styles */
    .btn {
        background-color: #4e73df;
        color: white;
        padding: 12px 24px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-size: 16px;
        transition: background-color 0.3s ease;
        margin-top: 10px;
        display: inline-block;
    }

    .btn:hover {
        background-color: #2e59d9;
    }

    .btn:focus {
        outline: none;
    }

    /* Message Styles */
    .message {
        padding: 15px;
        margin-bottom: 25px;
        border-radius: 6px;
    }

    .info {
        background-color: #e1f4ff;
        color: #4e73df;
        border: 1px solid #d6e9f9;
    }

    .error {
        background-color: #ffdddd;
        color: #a94442;
        border: 1px solid #ebccd1;
    }

    .success {
        background-color: #d4edda;
        color: #155724;
        border: 1px solid #c3e6cb;
    }

    /* Completed Campaign List */
    .campaign-list {
        margin-top: 30px;
    }

    .campaign-item {
        padding: 15px;
        margin-bottom: 20px;
        background: #f9fafc;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
        display: flex;
        justify-content: space-between;
        align-items: center;
        transition: box-shadow 0.3s ease;
    }

    .campaign-item:hover {
        box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
    }

    .campaign-item a {
        color: #4e73df;
        text-decoration: none;
        font-weight: bold;
        font-size: 18px;
    }

    .campaign-item a:hover {
        text-decoration: underline;
    }

    .campaign-id {
        font-size: 14px;
        color: #6c757d;
    }

    /* Spacer Between Campaigns */
    .campaign-item + .campaign-item {
        margin-top: 10px;
    }

    /* Mobile Responsive */
    @media (max-width: 768px) {
        .form-box {
            padding: 20px;
        }

        .campaign-item {
            flex-direction: column;
            align-items: flex-start;
        }

        .btn {
            width: 100%;
            text-align: center;
        }
    }

    
    </style>
</head>
<body>

<h2>Admin - View Completed Campaigns</h2>

<%
    if (campaigns.isEmpty()) {
%>
    <div class="message info">
        No completed campaigns found.
    </div>
<%
    } else {
%>
    <div class="form-box">
        <h3>Completed Campaigns</h3>

        <%-- Display completed campaigns as a list --%>
        <div class="campaign-list">
            <%
                for (String campaign : campaigns) {
            %>
                <div class="campaign-item">
                    <span class="campaign-id"><%= campaign.split(" - ")[0] %></span>
                    <span><%= campaign.split(" - ")[1] %></span>
                    <form action="GeneratedReport.jsp" method="get" style="display:inline;">
                        <input type="hidden" name="campaign_id" value="<%= campaign.split(" - ")[0].replace("ID: ", "") %>">
                        <button class="btn" type="submit">Generate Report</button>
                    </form>
                </div>
            <%
                }
            %>
        </div>
    </div>
<%
    }
%>

</body>
</html>
