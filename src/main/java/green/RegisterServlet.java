package green;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String gender = request.getParameter("gender");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO users (name, email, password, phone, address, gender) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, password);
            stmt.setString(4, phone);
            stmt.setString(5, address);
            stmt.setString(6, gender);

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                out.println("<h3>Registration Successful!</h3>");
                response.sendRedirect("User_Login.jsp");
            } else {
                out.println("<h3> Registration Failed!</h3>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<h3> Error: " + e.getMessage() + "</h3>");
        }
    }
}
