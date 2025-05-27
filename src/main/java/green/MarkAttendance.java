package green;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/MarkAttendance")
public class MarkAttendance extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
  
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    int campaignId = Integer.parseInt(request.getParameter("campaign_id"));
	    int managerId = (Integer) request.getSession().getAttribute("staff_id");

	    try (Connection conn = DBConnection.getConnection()) {

	        String statusQuery = "SELECT status FROM campaigns WHERE campaign_id = ?";
	        PreparedStatement psStatus = conn.prepareStatement(statusQuery);
	        psStatus.setInt(1, campaignId);
	        ResultSet rsStatus = psStatus.executeQuery();

	        if (!rsStatus.next() || !rsStatus.getString("status").equals("Ongoing")) {
	            response.getWriter().write("Attendance can only be marked for ongoing campaigns.");
	            return;
	        }

	       	        String participantsQuery = """
	            SELECT u.user_id, u.name,
	                (SELECT status FROM campaign_attendance ca 
	                 WHERE ca.campaign_id = ? AND ca.user_id = u.user_id AND attendance_date = CURDATE()) AS attendance
	            FROM campaign_participation pp
	            JOIN users u ON pp.user_id = u.user_id
	            WHERE pp.campaign_id = ?
	        """;

	        PreparedStatement ps = conn.prepareStatement(participantsQuery);
	        ps.setInt(1, campaignId);
	        ps.setInt(2, campaignId);
	        ResultSet rs = ps.executeQuery();

	        List<Map<String, String>> participants = new ArrayList<>();
	        while (rs.next()) {
	            Map<String, String> p = new HashMap<>();
	            p.put("user_id", rs.getString("user_id"));
	            p.put("name", rs.getString("name"));
	            p.put("attendance", rs.getString("attendance"));
	            participants.add(p);
	        }

	        request.setAttribute("participants", participants);
	        request.setAttribute("campaign_id", campaignId);
	        request.getRequestDispatcher("MarkAttendance.jsp").forward(request, response);

	    } catch (Exception e) {
	        e.printStackTrace();
	        response.getWriter().write("Error: " + e.getMessage());
	    }
	}}
