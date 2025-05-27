package green;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/ParticipatedCampaigns")
public class Participated_Campaigns extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String email = (String) session.getAttribute("email"); // Get email from session

        if (email == null) {
            response.sendRedirect("User_Login.jsp?error=Please login first");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
                        String getUserIdSql = "SELECT user_id FROM users WHERE email = ?";
            PreparedStatement userStmt = conn.prepareStatement(getUserIdSql);
            userStmt.setString(1, email);
            ResultSet userRs = userStmt.executeQuery();
            if (!userRs.next()) {
                response.sendRedirect("User_Dashboard.jsp?error=User not found");
                return;
            }
            int userId = userRs.getInt("user_id");

            String sql = "SELECT c.campaign_id, c.title, c.location, c.start_date, c.end_date, c.status "
                       + "FROM campaigns c "
                       + "JOIN campaign_participation p ON c.campaign_id = p.campaign_id "
                       + "WHERE p.user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            ArrayList<String[]> participatedCampaigns = new ArrayList<>();
            while (rs.next()) {
                String[] campaign = {
                    rs.getString("campaign_id"),
                    rs.getString("title"),
                    rs.getString("location"),
                    rs.getString("start_date"),
                    rs.getString("end_date"),
                    rs.getString("status")
                };
                participatedCampaigns.add(campaign);
            }

            request.setAttribute("participatedCampaigns", participatedCampaigns);
            request.getRequestDispatcher("Participated_Campaigns.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("User_Dashboard.jsp?error=Database error");
        }
    }
}
