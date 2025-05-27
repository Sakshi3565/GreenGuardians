// File: StaffInfo.java (place in package green)
package green;

public class StaffInfo {
    private int id;
    private String role;
    private String email;

    public StaffInfo(int id, String role, String email) {
        this.id = id;
        this.role = role;
        this.email = email;
    }

    public int getId() {
        return id;
    }

    public String getRole() {
        return role;
    }

    public String getEmail() {
        return email;
    }
}
