package green;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/UpdateCampaignStatus")
public class Update_status extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int campaignId = Integer.parseInt(request.getParameter("campaign_id"));
        String newStatus = request.getParameter("status");

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("UPDATE campaigns SET status = ? WHERE campaign_id = ?");
            ps.setString(1, newStatus);
            ps.setInt(2, campaignId);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                response.sendRedirect("ManagerDashboard.jsp?message=Status updated successfully");
            } else {
                response.sendRedirect("ManagerDashboard.jsp?error=Failed to update status");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ManagerDashboard.jsp?error=Error: " + e.getMessage());
        }
    }
}
