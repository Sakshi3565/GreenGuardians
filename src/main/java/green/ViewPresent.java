package green;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ViewPresent")
public class ViewPresent extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String date = request.getParameter("attendance_date");
        int campaignId = Integer.parseInt(request.getParameter("campaign_id"));
        List<Map<String, String>> presentUsers = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            String sql = """
                SELECT u.user_id, u.name
                FROM campaign_attendance ca
                JOIN users u ON ca.user_id = u.user_id
                WHERE ca.campaign_id = ? AND ca.attendance_date = ? AND ca.status = 'Present'
            """;

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, campaignId);
            ps.setString(2, date);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, String> user = new HashMap<>();
                user.put("user_id", rs.getString("user_id"));
                user.put("name", rs.getString("name"));
                presentUsers.add(user);
            }

            request.setAttribute("presentUsers", presentUsers);
            request.setAttribute("attendanceDate", date);
            request.setAttribute("count", presentUsers.size());
            request.getRequestDispatcher("PresentAttendance.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        }
    }
}
