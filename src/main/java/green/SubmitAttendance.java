package green;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/SubmitAttendance")
public class SubmitAttendance extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int campaignId = Integer.parseInt(request.getParameter("campaign_id"));
        String[] userIds = request.getParameterValues("user_ids");

        try (Connection conn = DBConnection.getConnection()) {

            String checkQuery = "SELECT COUNT(*) FROM campaign_attendance WHERE campaign_id = ? AND attendance_date = CURDATE()";
            PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
            checkStmt.setInt(1, campaignId);
            ResultSet rs = checkStmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                response.sendRedirect("MarkAttendance?campaign_id=" + campaignId + "&error=Attendance already marked for today.");
                return;
            }

            String sql = """
                INSERT INTO campaign_attendance (campaign_id, user_id, attendance_date, status)
                VALUES (?, ?, CURDATE(), ?)
                ON DUPLICATE KEY UPDATE status = VALUES(status)
            """;

            PreparedStatement ps = conn.prepareStatement(sql);

            if (userIds != null) {
                for (String uidStr : userIds) {
                    int userId = Integer.parseInt(uidStr);
                    String status = request.getParameter("attendance_" + userId);

                    if (status != null) {
                        ps.setInt(1, campaignId);
                        ps.setInt(2, userId);
                        ps.setString(3, status);
                        ps.addBatch();
                    }
                }
            }

            ps.executeBatch();
            response.sendRedirect("MarkAttendance?campaign_id=" + campaignId + "&success=Attendance submitted successfully.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("MarkAttendance?campaign_id=" + campaignId + "&error=" + e.getMessage());
        }
    }
}
