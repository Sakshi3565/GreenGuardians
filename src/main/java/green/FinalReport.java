package green;

import java.io.File;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/CampaignManagerReport")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class FinalReport extends HttpServlet {

   
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int campaignId = Integer.parseInt(request.getParameter("campaign_id"));
        int managerId = (int) request.getSession().getAttribute("staff_id"); // Assuming manager_id is in session
        String campaignType = request.getParameter("campaign_type");
        String notes = request.getParameter("notes");
        String finalPhotoPath = null;

    
        Part filePart = request.getPart("photo");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = new File(filePart.getSubmittedFileName()).getName();
            String uploadPath = getServletContext().getRealPath("") + File.separator + "image";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            String filePath = uploadPath + File.separator + fileName;
            filePart.write(filePath);

            finalPhotoPath = "image/" + fileName;
        }

        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/your database", "root", "password")) {

            String sql = "INSERT INTO campaign_manager_reports (campaign_id, manager_id, date, notes, final_photo_path, " +
                         "total_trees_planted, total_saplings_damaged, area_covered, attendees, activities_conducted, feedback, challenges, suggestions) " +
                         "VALUES (?, ?, CURDATE(), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, campaignId);
            ps.setInt(2, managerId);
            ps.setString(3, notes);
            ps.setString(4, finalPhotoPath);

            if ("Planting".equalsIgnoreCase(campaignType)) {
                ps.setInt(5, Integer.parseInt(request.getParameter("total_trees_planted")));
                ps.setInt(6, Integer.parseInt(request.getParameter("total_saplings_damaged")));
                ps.setString(7, request.getParameter("area_covered"));
                ps.setNull(8, Types.INTEGER);
                ps.setNull(9, Types.VARCHAR);
                ps.setNull(10, Types.VARCHAR);
                ps.setNull(11, Types.VARCHAR);
                ps.setNull(12, Types.VARCHAR);
            } else if ("Awareness".equalsIgnoreCase(campaignType)) {
                ps.setNull(5, Types.INTEGER);
                ps.setNull(6, Types.INTEGER);
                ps.setNull(7, Types.VARCHAR);
                ps.setInt(8, Integer.parseInt(request.getParameter("attendees")));
                ps.setString(9, request.getParameter("activities_conducted"));
                ps.setString(10, request.getParameter("feedback"));
                ps.setString(11, request.getParameter("challenges"));
                ps.setString(12, request.getParameter("suggestions"));
            }

            int result = ps.executeUpdate();
            if (result > 0) {
                request.setAttribute("message", "Final report submitted successfully!");
            } else {
                request.setAttribute("message", "Failed to submit report.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error: " + e.getMessage());
        }

        request.getRequestDispatcher("FinalReport.jsp?campaign_id=" + campaignId).forward(request, response);
    }
}
