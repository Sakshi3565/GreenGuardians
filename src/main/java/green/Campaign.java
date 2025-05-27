package green;

public class Campaign {
    private int id;
    private String title;
    private String status;

    public Campaign(int id, String title, String status) {
        this.id = id;
        this.title = title;
        this.status = status;
    }

    public int getId() { return id; }
    public String getTitle() { return title; }
    public String getStatus() { return status; }
}
