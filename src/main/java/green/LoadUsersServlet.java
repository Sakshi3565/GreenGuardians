package green;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
@WebServlet("/loadUsers")
public class LoadUsersServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<StaffInfo> staffList = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT staff_id, role, email FROM staff");
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                staffList.add(new StaffInfo(rs.getInt("staff_id"), rs.getString("role"), rs.getString("email")));
            }

            request.setAttribute("staffList", staffList);
        } catch (Exception e) {
            request.setAttribute("error", "Error loading staff: " + e.getMessage());
        }

        request.getRequestDispatcher("sendNotification.jsp").forward(request, response);
    }
}


