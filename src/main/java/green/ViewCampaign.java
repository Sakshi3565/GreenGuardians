package green;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.RequestDispatcher;

@WebServlet("/ViewCampaign")
public class ViewCampaign extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");

        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("error.jsp"); 
            return;
        }

        int campaignId = 0;
        try {
            campaignId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect("error.jsp"); 
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM campaigns WHERE campaign_id = ?");
            stmt.setInt(1, campaignId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                request.setAttribute("campaignTitle", rs.getString("title"));
                request.setAttribute("startDate", rs.getDate("start_date"));
                request.setAttribute("endDate", rs.getDate("end_date"));
                request.setAttribute("campaignType", rs.getString("campaign_type"));
                request.setAttribute("description", rs.getString("description"));
                request.setAttribute("location", rs.getString("location"));
                request.setAttribute("status", rs.getString("status"));
                request.setAttribute("peopleRequired", rs.getInt("people_required"));
                request.setAttribute("donationRequired", rs.getDouble("donation_required"));
                
                if ("Planting".equals(rs.getString("campaign_type"))) {
                    request.setAttribute("treesToPlant", rs.getInt("trees_to_plant"));
                }

                RequestDispatcher dispatcher = request.getRequestDispatcher("ViewCampaign.jsp");
                dispatcher.forward(request, response);
            } else {
                response.sendRedirect("notfound.jsp");
            }

            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
