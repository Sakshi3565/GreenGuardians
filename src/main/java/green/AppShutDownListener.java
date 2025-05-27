package green;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class AppShutDownListener implements ServletContextListener {
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("Shutting down HikariCP...");
        DBConnection.closePool(); 
    }

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("Application started. HikariCP is ready!");
    }
}
