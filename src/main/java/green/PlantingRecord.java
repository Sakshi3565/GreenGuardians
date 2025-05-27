package green;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/PlantingRecords")
public class PlantingRecord extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            response.sendRedirect("User_Login.jsp?error=Please login first");
            return;
        }

        String email = (String) session.getAttribute("email");
        int userId = -1;

    
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/greenguardians", "root", "Sakshi@3565");

            String query = "SELECT user_id FROM users WHERE email = ?";
            ps = conn.prepareStatement(query);
            ps.setString(1, email);
            rs = ps.executeQuery();

            if (rs.next()) {
                userId = rs.getInt("user_id");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("PlantingRecord.jsp?error=UserNotFound");
            return;
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }

        if (userId == -1) {
            response.sendRedirect("PlantingRecord.jsp?error=UserNotFound");
            return;
        }

        String campaignId = request.getParameter("campaign_id");
        String treesPlanted = request.getParameter("trees_planted");
        String notes = request.getParameter("notes");
        String todayDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());

        try {
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/greenguardians", "root", "Sakshi@3565");
            String insertQuery = "INSERT INTO planting_records (campaign_id, user_id, date, trees_planted, notes) VALUES (?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(insertQuery);

            ps.setString(1, campaignId);
            ps.setInt(2, userId);
            ps.setString(3, todayDate);
            ps.setInt(4, Integer.parseInt(treesPlanted));
            ps.setString(5, notes);

            int rowsInserted = ps.executeUpdate();
            if (rowsInserted > 0) {
                response.sendRedirect("PlantingRecord.jsp?success=RecordSubmitted&campaign_id=" + campaignId);
            } else {
                response.sendRedirect("PlantingRecord.jsp?error=SubmitFailed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("PlantingRecord.jsp?error=DatabaseError");
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}
