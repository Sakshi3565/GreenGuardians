<%@ page import="java.util.*, green.TrackProgress.TrackerReport" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String campaignType = (String) request.getAttribute("campaignType");
    List<TrackerReport> trackerReports = (List<TrackerReport>) request.getAttribute("trackerReports");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Campaign Progress</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5fc;
            color: #333;
            padding: 40px;
        }

        h2 {
            color: #4b3db7;
            text-align: center;
            margin-bottom: 30px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(90, 79, 207, 0.1);
            border-radius: 10px;
            overflow: hidden;
        }

        thead {
            background-color: #5a4fcf;
            color: white;
        }

        th, td {
            padding: 12px 15px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }

        tbody tr:hover {
            background-color: #eee9ff;
        }

        td img {
            border-radius: 6px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.2);
        }

        p {
            text-align: center;
            color: #777;
            font-style: italic;
        }
    </style>
</head>
<body>

<h2>Campaign Progress - <%= campaignType %></h2>

<% if (trackerReports == null || trackerReports.isEmpty()) { %>
    <p>No tracker reports available for this campaign.</p>
<% } else { %>
    <table>
        <thead>
        <tr>
            <th>Date</th>
            <% if ("Tree Plantation".equalsIgnoreCase(campaignType)) { %>
                <th>Trees Planted</th>
                <th>Saplings Damaged</th>
                <th>Area Covered</th>
            <% } else if ("Awareness".equalsIgnoreCase(campaignType)) { %>
                <th>Attendees</th>
                <th>Activities</th>
            <% } %>
            <th>Feedback</th>
            <th>Challenges</th>
            <th>Suggestions</th>
            <th>Notes</th>
            <th>Photo</th>
        </tr>
        </thead>
        <tbody>
        <% for (TrackerReport report : trackerReports) { %>
            <tr>
                <td><%= report.date %></td>
                <% if ("Tree Plantation".equalsIgnoreCase(campaignType)) { %>
                    <td><%= report.treesPlanted %></td>
                    <td><%= report.saplingsDamaged %></td>
                    <td><%= report.areaCovered %></td>
                <% } else if ("Awareness".equalsIgnoreCase(campaignType)) { %>
                    <td><%= report.attendees %></td>
                    <td><%= report.activities %></td>
                <% } %>
                <td><%= report.feedback %></td>
                <td><%= report.challenges %></td>
                <td><%= report.suggestions %></td>
                <td><%= report.notes %></td>
                <td>
                    <% if (report.photoPath != null) { %>
                        <img src="<%= report.photoPath %>" alt="Photo" width="100" />
                    <% } else { %>
                        N/A
                    <% } %>
                </td>
            </tr>
        <% } %>
        </tbody>
    </table>
<% } %>

</body>
</html>
