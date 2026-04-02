package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
    // Normal comment ekak hari Reply ekak hari database ekata danna
    public boolean addComment(int postId, int userId, String commentText, Integer parentCommentId) {
        String query = "INSERT INTO comments (post_id, user_id, comment_text, parent_comment_id) VALUES (?, ?, ?, ?)";
        try (PreparedStatement pstmt = db.con.prepareStatement(query)) {
            pstmt.setInt(1, postId);
            pstmt.setInt(2, userId);
            pstmt.setString(3, commentText);
            
            // Parent ID eka null nam meka normal comment ekak, naththam reply ekak
            if (parentCommentId == null) {
                pstmt.setNull(4, java.sql.Types.INTEGER);
            } else {
                pstmt.setInt(4, parentCommentId);
            }
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(PostDAO.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

   public List<Comment> getCommentsByPostId(int postId) {
        List<Comment> parentComments = new ArrayList<>();
        Map<Integer, Comment> commentMap = new HashMap<>(); 

        // SQL eken Likes count ekath ekkama okkoma comments gannawa
        String query = "SELECT c.*, u.username, u.profile_pic_url, " +
                       "(SELECT COUNT(*) FROM comment_likes cl WHERE cl.comment_id = c.comment_id) AS likes_count " +
                       "FROM comments c " +
                       "JOIN users u ON c.user_id = u.user_id " +
                       "WHERE c.post_id = ? " +
                       "ORDER BY c.created_date ASC";

        try (PreparedStatement pstmt = db.con.prepareStatement(query)) {
            pstmt.setInt(1, postId);
            try (ResultSet rs = pstmt.executeQuery()) {
                
                // 1. Piyawara: Okkoma comments load karagena Map ekata danawa
                while (rs.next()) {
                    Comment comment = new Comment();
                    comment.setCommentId(rs.getInt("comment_id"));
                    comment.setPostId(rs.getInt("post_id"));
                    comment.setUserId(rs.getInt("user_id"));
                    comment.setCommentText(rs.getString("comment_text"));
                    comment.setCreatedDate(rs.getTimestamp("created_date")); // Oyage parana code eke thibba widiyatama
                    comment.setUsername(rs.getString("username"));
                    comment.setUserProfilePic(rs.getString("profile_pic_url")); // Oyage parana code eke thibba widiyatama
                    
                    // Aluth properties tika set karanawa
                    comment.setLikesCount(rs.getInt("likes_count"));
                    int parentId = rs.getInt("parent_comment_id");
                    if (!rs.wasNull()) {
                        comment.setParentCommentId(parentId);
                    }

                    commentMap.put(comment.getCommentId(), comment);
                }

                // 2. Piyawara: Map eke thiyena ewa Parent and Reply widiyata wen karanawa
                for (Comment comment : commentMap.values()) {
                    if (comment.getParentCommentId() == null || comment.getParentCommentId() == 0) {
                        parentComments.add(comment);
                    } else {
                        Comment parent = commentMap.get(comment.getParentCommentId());
                        if (parent != null) {
                            parent.addReply(comment);
                        }
                    }
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(PostDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return parentComments;
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
    
    // Comment ekakata Like/Unlike kireema
    public void toggleCommentLike(int commentId, int userId) {
        DBconn cn = new DBconn();
        if (cn.con == null) return;

        try {
            // Mulinma balanawa kalin like karalada kiyala
            String checkSql = "SELECT * FROM comment_likes WHERE comment_id = ? AND user_id = ?";
            try (PreparedStatement checkStmt = cn.con.prepareStatement(checkSql)) {
                checkStmt.setInt(1, commentId);
                checkStmt.setInt(2, userId);
                ResultSet rs = checkStmt.executeQuery();

                if (rs.next()) {
                    // Kalin like karala nam, eka remove karanawa (Unlike)
                    String delSql = "DELETE FROM comment_likes WHERE comment_id = ? AND user_id = ?";
                    try (PreparedStatement delStmt = cn.con.prepareStatement(delSql)) {
                        delStmt.setInt(1, commentId);
                        delStmt.setInt(2, userId);
                        delStmt.executeUpdate();
                    }
                } else {
                    // Kalin like karala naththam, aluth like ekak add karanawa
                    String insertSql = "INSERT INTO comment_likes (comment_id, user_id) VALUES (?, ?)";
                    try (PreparedStatement inStmt = cn.con.prepareStatement(insertSql)) {
                        inStmt.setInt(1, commentId);
                        inStmt.setInt(2, userId);
                        inStmt.executeUpdate();
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
