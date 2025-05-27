package green;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import com.google.gson.Gson;

@WebServlet("/getAssignedStaff")
public class GetAssignedStaff extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int campaignId = Integer.parseInt(request.getParameter("campaignId"));
        List<String> assignedStaff = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT s.name, s.role FROM campaign_assignment ca " +
                     "JOIN staff s ON ca.staff_id = s.staff_id " +
                     "WHERE ca.campaign_id = ?")) {

            ps.setInt(1, campaignId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                assignedStaff.add(rs.getString("name") + " (" + rs.getString("role") + ")");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(new Gson().toJson(assignedStaff));
    }
}
