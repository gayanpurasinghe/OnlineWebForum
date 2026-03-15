package model;

public class User {
    private int userId;
    private String username;
    private String email;
    private String role;
    private String profilePicUrl;
    private boolean isBanned;

    public User() {}

    public User(int userId, String username, String email, String role, String profilePicUrl, boolean isBanned) {
        this.userId = userId;
        this.username = username;
        this.email = email;
        this.role = role;
        this.profilePicUrl = profilePicUrl;
        this.isBanned = isBanned;
    }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getProfilePicUrl() { return profilePicUrl; }
    public void setProfilePicUrl(String profilePicUrl) { this.profilePicUrl = profilePicUrl; }

    public boolean isBanned() { return isBanned; }
    public void setBanned(boolean isBanned) { this.isBanned = isBanned; }
}
