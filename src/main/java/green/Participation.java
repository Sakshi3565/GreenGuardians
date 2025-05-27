package green;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.RequestDispatcher;

@WebServlet("/Participate")
public class Participation extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email"); 
        String campaignId = request.getParameter("campaignId");

        if (email == null || campaignId == null) {
            request.setAttribute("error", "Please login first");
            RequestDispatcher dispatcher = request.getRequestDispatcher("User_Login.jsp");
            dispatcher.forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            String getUserIdSql = "SELECT user_id FROM users WHERE email = ?";
            PreparedStatement userStmt = conn.prepareStatement(getUserIdSql);
            userStmt.setString(1, email);
            ResultSet userRs = userStmt.executeQuery();
            if (!userRs.next()) {
                request.setAttribute("error", "User not found.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("User_Dashboard.jsp?id=" + campaignId);
                dispatcher.forward(request, response);
                return;
            }
            int userId = userRs.getInt("user_id");

           
            String dateCheckSql = "SELECT start_date FROM campaigns WHERE campaign_id = ?";
            PreparedStatement dateStmt = conn.prepareStatement(dateCheckSql);
            dateStmt.setInt(1, Integer.parseInt(campaignId));
            ResultSet rs = dateStmt.executeQuery();

            if (rs.next()) {
                LocalDate startDate = rs.getDate("start_date").toLocalDate();
                LocalDate currentDate = LocalDate.now();

                if (currentDate.isAfter(startDate)) {
                    request.setAttribute("error", "Campaign already started. Participation closed.");
                    RequestDispatcher dispatcher = request.getRequestDispatcher("User_Dashboard.jsp?id=" + campaignId);
                    dispatcher.forward(request, response);
                    return;
                }
            }

                      String sql = "INSERT INTO campaign_participation (user_id, campaign_id) VALUES (?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setInt(2, Integer.parseInt(campaignId));
            stmt.executeUpdate();

            request.setAttribute("success", "Participation successful!");
        } catch (SQLException e) {
            request.setAttribute("error", "Already participated or database error.");
        }

       
        RequestDispatcher dispatcher = request.getRequestDispatcher("User_Dashboard.jsp?id=" + campaignId);
        dispatcher.forward(request, response);
    }
}
