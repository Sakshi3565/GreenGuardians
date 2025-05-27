package green;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/TrackProgress")
public class TrackProgress extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public class TrackerReport {
        public Date date;
        public int treesPlanted;
        public int saplingsDamaged;
        public String areaCovered;
        public int attendees;
        public String activities;
        public String feedback;
        public String challenges;
        public String suggestions;
        public String photoPath;
        public String notes;
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int campaignId = Integer.parseInt(request.getParameter("campaign_id"));
        String campaignType = "";
        ArrayList<TrackerReport> reports = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement campaignStmt = conn.prepareStatement("SELECT campaign_type FROM campaigns WHERE campaign_id = ?");
            campaignStmt.setInt(1, campaignId);
            ResultSet campaignRs = campaignStmt.executeQuery();
            if (campaignRs.next()) {
                campaignType = campaignRs.getString("campaign_type");
            }

            String sql = "SELECT * FROM tracker_records WHERE campaign_id = ? ORDER BY date DESC";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, campaignId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                TrackerReport report = new TrackerReport();
                report.date = rs.getDate("date");
                report.treesPlanted = rs.getInt("trees_planted");
                report.saplingsDamaged = rs.getInt("saplings_damaged");
                report.areaCovered = rs.getString("area_covered");
                report.attendees = rs.getInt("attendees");
                report.activities = rs.getString("activities_conducted");
                report.feedback = rs.getString("feedback");
                report.challenges = rs.getString("challenges");
                report.suggestions = rs.getString("suggestions");
                report.photoPath = rs.getString("photo_path");
                report.notes = rs.getString("notes");
                reports.add(report);
            }

            request.setAttribute("campaignType", campaignType);
            request.setAttribute("trackerReports", reports);
            RequestDispatcher dispatcher = request.getRequestDispatcher("TrackProgress.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Unable to fetch progress.");
            request.getRequestDispatcher("Campaigns.jsp").forward(request, response);
        }
    }
}
