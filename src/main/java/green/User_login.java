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

@WebServlet("/User_login")
public class User_login extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM users WHERE email=? AND password=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
         
                HttpSession oldSession = request.getSession(false);
                if (oldSession != null) {
                    oldSession.invalidate();
                }


                HttpSession session = request.getSession(true);
                session.setMaxInactiveInterval(30 * 60); // 30 minutes
                session.setAttribute("email", email);
                response.sendRedirect("User_Dashboard.jsp");

            } else {
                response.sendRedirect("User_Login.jsp?error=Invalid email or password");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("User_Login.jsp?error=Database error");
        }
    }
}
