package model;

import java.sql.Timestamp;
import java.util.ArrayList;

import java.util.List;

public class Comment {
    private int commentId;
    private int postId;
    private int userId;
    private String username;
    private String userProfilePic;
    private String commentText;
    private Timestamp createdDate;
    private Integer parentCommentId; // Normal comment ekak nam meka null
    private int likesCount;          // Like ganana
    private List<Comment> replies = new ArrayList<>(); // Reply list eka

    public Comment() {}

    public int getCommentId() { return commentId; }
    public void setCommentId(int commentId) { this.commentId = commentId; }

    public int getPostId() { return postId; }
    public void setPostId(int postId) { this.postId = postId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getUserProfilePic() { return userProfilePic; }
    public void setUserProfilePic(String userProfilePic) { this.userProfilePic = userProfilePic; }

    public String getCommentText() { return commentText; }
    public void setCommentText(String commentText) { this.commentText = commentText; }

    public Timestamp getCreatedDate() { return createdDate; }
    public void setCreatedDate(Timestamp createdDate) { this.createdDate = createdDate; }
    
    public Integer getParentCommentId() { return parentCommentId; }
    public void setParentCommentId(Integer parentCommentId) { this.parentCommentId = parentCommentId; }

    public int getLikesCount() { return likesCount; }
    public void setLikesCount(int likesCount) { this.likesCount = likesCount; }

    public List<Comment> getReplies() { return replies; }
    public void setReplies(List<Comment> replies) { this.replies = replies; }
    
    // Reply ekak add karanna loku lesiyata podi method ekak
    public void addReply(Comment reply) {
        this.replies.add(reply);
    }
}
