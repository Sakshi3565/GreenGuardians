package green;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RemoveParticipant")
public class RemoveParticipant extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int userId = Integer.parseInt(request.getParameter("user_id"));
        int campaignId = Integer.parseInt(request.getParameter("campaign_id"));

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn1 = DBConnection.getConnection();
            String deleteQuery = "DELETE FROM campaign_participation WHERE campaign_id = ? AND user_id = ?";
            ps = conn1.prepareStatement(deleteQuery);
            ps.setInt(1, campaignId);
            ps.setInt(2, userId);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                String notifyQuery = "INSERT INTO user_notifications (user_id, message) VALUES (?, ?)";
                PreparedStatement notifyStmt = conn1.prepareStatement(notifyQuery);
                notifyStmt.setInt(1, userId);
                notifyStmt.setString(2, "You have been removed from campaign ID: " + campaignId + " by the Campaign Manager.");
                notifyStmt.executeUpdate();
                notifyStmt.close();
                response.sendRedirect("ManageParticipant.jsp?campaign_id=" + campaignId + "&msg=Participant removed");
            } else {
                response.sendRedirect("ManageParticipant.jsp?campaign_id=" + campaignId + "&error=Participant not found");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ManageParticipant.jsp?campaign_id=" + campaignId + "&error=Error removing participant");
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
}
