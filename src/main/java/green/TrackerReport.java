package green;

import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import java.io.*;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.*;
import javax.servlet.http.*;

@WebServlet("/TrackerReport")
@MultipartConfig
public class TrackerReport extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer staffId = (Integer) session.getAttribute("staff_id");

        if (staffId == null) {
            response.sendRedirect("login.jsp?error=Please login first");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        int campaignId = Integer.parseInt(request.getParameter("campaign_id"));
        String campaignType = request.getParameter("campaign_type");
        String reportDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
        String notes = request.getParameter("notes");

        int treesPlanted = 0, saplingsDamaged = 0, attendees = 0;
        String areaCovered = null, activities = null, feedback = null, challenges = null, suggestions = null, photoPath = null;

        if ("Planting".equalsIgnoreCase(campaignType)) {
            treesPlanted = Integer.parseInt(request.getParameter("trees_planted"));
            saplingsDamaged = Integer.parseInt(request.getParameter("saplings_damaged"));
            areaCovered = request.getParameter("area_covered");
        } else if ("Awareness".equalsIgnoreCase(campaignType)) {
            attendees = Integer.parseInt(request.getParameter("attendees"));
            activities = request.getParameter("activities_conducted");
            feedback = request.getParameter("feedback");
            challenges = request.getParameter("challenges");
            suggestions = request.getParameter("suggestions");

            Part filePart = request.getPart("photo");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                String uploadPath = getServletContext().getRealPath("/image"); // Change to images folder

                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                filePart.write(uploadPath + File.separator + fileName);
                photoPath = "image/" + fileName; // Update path for DB and frontend use
                System.out.println("Upload path: " + getServletContext().getRealPath("/image"));


            }
        }

        try (Connection conn = DBConnection.getConnection()) {

            PreparedStatement checkStmt = conn.prepareStatement(
                    "SELECT COUNT(*) FROM tracker_records WHERE campaign_id = ? AND staff_id = ? AND date = CURDATE()");
            checkStmt.setInt(1, campaignId);
            checkStmt.setInt(2, staffId);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                response.sendRedirect("TrackerDashboard.jsp?error=You have already submitted today’s report.");
                return;
            }

            rs.close();
            checkStmt.close();

            PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO tracker_records (campaign_id, staff_id, date, trees_planted, saplings_damaged, area_covered, " +
                            "attendees, activities_conducted, feedback, challenges, suggestions, photo_path, notes) " +
                            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

            ps.setInt(1, campaignId);
            ps.setInt(2, staffId);
            ps.setDate(3, java.sql.Date.valueOf(reportDate));
            ps.setInt(4, treesPlanted);
            ps.setInt(5, saplingsDamaged);
            ps.setString(6, areaCovered);
            ps.setInt(7, attendees);
            ps.setString(8, activities);
            ps.setString(9, feedback);
            ps.setString(10, challenges);
            ps.setString(11, suggestions);
            ps.setString(12, photoPath);
            ps.setString(13, notes);

            int result = ps.executeUpdate();
            ps.close();

            String message = (result > 0) ? "✅ Report submitted successfully!" : "❌ Failed to submit report.";
            request.setAttribute("message", message);

            RequestDispatcher dispatcher = request.getRequestDispatcher("my_report.jsp?campaign_id=" + campaignId);
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("TrackerDashboard.jsp?error=Error: " + e.getMessage());
        }
    }
}
