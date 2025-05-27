package green;

public class Staff{
    private int id;
    private String name;
    private String email;
    private boolean assigned;

    public Staff(int id, String name, String email, boolean assigned) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.assigned = assigned;
    }

    public int getId() { return id; }
    public String getName() { return name; }
    public String getEmail() { return email; }
    public boolean isAssigned() { return assigned; }
}
