package green;
import java.sql.Connection;
import java.sql.SQLException;
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

public class DBConnection {
    private static HikariDataSource dataSource;

    static {
        try {
            HikariConfig config = new HikariConfig();
            config.setJdbcUrl("jdbc:mysql://localhost:3306/your database");
            config.setUsername("root");
            config.setPassword("password");
            config.setDriverClassName("com.mysql.cj.jdbc.Driver");

          
            config.setMaximumPoolSize(20); 
            config.setMinimumIdle(5);       
            config.setIdleTimeout(60000); 
            config.setMaxLifetime(1800000); 
            config.setConnectionTimeout(10000); 

            dataSource = new HikariDataSource(config);
            System.out.println("Database Connection Pool Initialized!");
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to initialize DB pool", e);
        }
    }

   
    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    public static void closePool() {
        if (dataSource != null) {
            dataSource.close();
        }
    }
}
