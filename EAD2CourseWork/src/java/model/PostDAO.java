package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PostDAO {
    private DBconn db;

    public PostDAO() {
        db = new DBconn();
    }

    public boolean addPost(int userId, String title, String content, String imageUrl) {
        String query = "INSERT INTO posts (user_id, title, content, image_url) VALUES (?, ?, ?, ?)";
        try (PreparedStatement pstmt = db.con.prepareStatement(query)) {
            pstmt.setInt(1, userId);
            pstmt.setString(2, title);
            pstmt.setString(3, content);
            pstmt.setString(4, imageUrl);
            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException ex) {
            Logger.getLogger(PostDAO.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    public List<Post> getAllPosts() {
        List<Post> posts = new ArrayList<>();
        String query = "SELECT p.*, u.username, u.profile_pic_url FROM posts p " +
                       "JOIN users u ON p.user_id = u.user_id " +
                       "ORDER BY p.created_date DESC";
        try (PreparedStatement pstmt = db.con.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Post post = new Post();
                post.setPostId(rs.getInt("post_id"));
                post.setUserId(rs.getInt("user_id"));
                post.setTitle(rs.getString("title"));
                post.setContent(rs.getString("content"));
                post.setImageUrl(rs.getString("image_url"));
                post.setCreatedDate(rs.getTimestamp("created_date"));
                post.setUsername(rs.getString("username"));
                post.setUserProfilePic(rs.getString("profile_pic_url"));
                post.setComments(getCommentsByPostId(post.getPostId()));
                posts.add(post);
            }
        } catch (SQLException ex) {
            Logger.getLogger(PostDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return posts;
    }

    public List<Post> getPostsByUserId(int userId) {
        List<Post> posts = new ArrayList<>();
        String query = "SELECT p.*, u.username, u.profile_pic_url FROM posts p " +
                       "JOIN users u ON p.user_id = u.user_id " +
                       "WHERE p.user_id = ? ORDER BY p.created_date DESC";
        try (PreparedStatement pstmt = db.con.prepareStatement(query)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Post post = new Post();
                    post.setPostId(rs.getInt("post_id"));
                    post.setUserId(rs.getInt("user_id"));
                    post.setTitle(rs.getString("title"));
                    post.setContent(rs.getString("content"));
                    post.setImageUrl(rs.getString("image_url"));
                    post.setCreatedDate(rs.getTimestamp("created_date"));
                    post.setUsername(rs.getString("username"));
                    post.setUserProfilePic(rs.getString("profile_pic_url"));
                    post.setComments(getCommentsByPostId(post.getPostId()));
                    posts.add(post);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(PostDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return posts;
    }

    public boolean deletePost(int postId) {
        String query = "DELETE FROM posts WHERE post_id = ?";
        try (PreparedStatement pstmt = db.con.prepareStatement(query)) {
            pstmt.setInt(1, postId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(PostDAO.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    // Comment operations
    public boolean addComment(int postId, int userId, String commentText) {
        String query = "INSERT INTO comments (post_id, user_id, comment_text) VALUES (?, ?, ?)";
        try (PreparedStatement pstmt = db.con.prepareStatement(query)) {
            pstmt.setInt(1, postId);
            pstmt.setInt(2, userId);
            pstmt.setString(3, commentText);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(PostDAO.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    public List<Comment> getCommentsByPostId(int postId) {
        List<Comment> comments = new ArrayList<>();
        String query = "SELECT c.*, u.username, u.profile_pic_url FROM comments c " +
                       "JOIN users u ON c.user_id = u.user_id " +
                       "WHERE c.post_id = ? ORDER BY c.created_date ASC";
        try (PreparedStatement pstmt = db.con.prepareStatement(query)) {
            pstmt.setInt(1, postId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Comment comment = new Comment();
                    comment.setCommentId(rs.getInt("comment_id"));
                    comment.setPostId(rs.getInt("post_id"));
                    comment.setUserId(rs.getInt("user_id"));
                    comment.setCommentText(rs.getString("comment_text"));
                    comment.setCreatedDate(rs.getTimestamp("created_date"));
                    comment.setUsername(rs.getString("username"));
                    comment.setUserProfilePic(rs.getString("profile_pic_url"));
                    comments.add(comment);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(PostDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return comments;
    }

    public boolean deleteComment(int commentId) {
        String query = "DELETE FROM comments WHERE comment_id = ?";
        try (PreparedStatement pstmt = db.con.prepareStatement(query)) {
            pstmt.setInt(1, commentId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(PostDAO.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }
}
