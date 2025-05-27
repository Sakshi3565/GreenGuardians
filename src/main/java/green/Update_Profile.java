package green;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/Update_Profile")
public class Update_Profile extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            response.sendRedirect("User_Login.jsp?error=Please login first");
            return;
        }
        System.out.println("hello");
        String email = (String) session.getAttribute("email");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String gender = request.getParameter("gender");
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                 "UPDATE users SET name = ?, phone = ?, address = ?, gender = ? WHERE email = ?"
             )) {
            
            stmt.setString(1, name);
            stmt.setString(2, phone);
            stmt.setString(3, address);
            stmt.setString(4, gender);
            stmt.setString(5, email);
            
            int updated = stmt.executeUpdate();
            
            if (updated > 0) {
                request.setAttribute("success", "Profile updated successfully.");
            } else {
                request.setAttribute("error", "Failed to update profile.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error.");
        }
        
        request.getRequestDispatcher("Profile.jsp").forward(request, response);
    }
}
