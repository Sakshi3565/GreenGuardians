package green;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/Login")
public class Login extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (Connection conn = DBConnection.getConnection()) {

           
            String adminQuery = "SELECT * FROM admin WHERE username = ? AND password = ?";
            try (PreparedStatement ps = conn.prepareStatement(adminQuery)) {
                ps.setString(1, username);
                ps.setString(2, password);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    HttpSession session = request.getSession();
                    session.setAttribute("username", username);
                    response.sendRedirect("Admin_Dashboard.jsp");
                    return;
                }
            }

            String staffQuery = "SELECT sl.staff_id, s.role FROM staff_login sl " +
                                "JOIN staff s ON sl.staff_id = s.staff_id " +
                                "WHERE sl.username = ? AND sl.password = ?";
            try (PreparedStatement ps = conn.prepareStatement(staffQuery)) {
                ps.setString(1, username);
                ps.setString(2, password);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    int staffId = rs.getInt("staff_id");
                    String role = rs.getString("role");

                    HttpSession session = request.getSession();
                    session.setAttribute("username", username);
                    session.setAttribute("staff_id", staffId);

                    if ("Campaign Manager".equalsIgnoreCase(role)) {
                        response.sendRedirect("ManagerDashboard.jsp");
                    } else if ("Tracker".equalsIgnoreCase(role)) {
                        response.sendRedirect("TrackerDashboard.jsp");
                    } else {
                        response.sendRedirect("login.jsp?error=Unknown staff role");
                        
                    }
                    return;
                }
            }

            response.sendRedirect("login.jsp?error=Invalid username or password");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=Database error");
        }
    }
}
