package green;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/loadAssignmentForm")
public class LoadAssignment extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); 
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Map<String, Object>> staffList = new ArrayList<>();
        List<Map<String, Object>> campaignList = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
         
            PreparedStatement ps1 = conn.prepareStatement("SELECT staff_id, name, role FROM staff");
            ResultSet rs1 = ps1.executeQuery();
            while (rs1.next()) {
                Map<String, Object> staff = new HashMap<>();
                staff.put("staffId", rs1.getInt("staff_id"));
                staff.put("name", rs1.getString("name"));
                staff.put("role", rs1.getString("role"));
                staffList.add(staff);
            }

            
            PreparedStatement ps2 = conn.prepareStatement("SELECT campaign_id, title FROM campaigns");
            ResultSet rs2 = ps2.executeQuery();
            while (rs2.next()) {
                Map<String, Object> campaign = new HashMap<>();
                campaign.put("campaignId", rs2.getInt("campaign_id"));
                campaign.put("title", rs2.getString("title"));
                campaignList.add(campaign);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("staffList", staffList);
        request.setAttribute("campaignList", campaignList);
        request.getRequestDispatcher("assignStaff.jsp").forward(request, response);
    }
}
