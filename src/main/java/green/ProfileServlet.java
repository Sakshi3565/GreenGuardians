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
import javax.servlet.http.HttpSession;

@WebServlet("/ProfileServlet") 
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
       
        HttpSession sessionob = request.getSession(false);
        if (sessionob == null || sessionob.getAttribute("email") == null) { 
            response.sendRedirect("User_Login.jsp?error=Please login first");
            return;
        }
        

        String email = (String) sessionob.getAttribute("email"); 

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                 "SELECT name, email, phone, address, gender, created_at FROM users WHERE email = ?"
             )) {
            
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                  
                    request.setAttribute("name", rs.getString("name"));
                    request.setAttribute("email", rs.getString("email"));
                    request.setAttribute("phone", rs.getString("phone"));
                    request.setAttribute("address", rs.getString("address"));
                    request.setAttribute("gender", rs.getString("gender"));
                    request.setAttribute("created_at", rs.getTimestamp("created_at"));
                }
            }

            request.getRequestDispatcher("Profile.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?error=Database error");
        }
    }
}
