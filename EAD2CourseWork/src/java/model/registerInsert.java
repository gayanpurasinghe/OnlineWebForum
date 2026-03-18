/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class registerInsert {
    private String lastError = ""; 
    
    public boolean isUsernameExists(String username) {
    DBconn cn = new DBconn();
    String sql = "SELECT username FROM users WHERE username = ?";
    try (PreparedStatement stmt = cn.con.prepareStatement(sql)) {
        stmt.setString(1, username);
        try (ResultSet rs = stmt.executeQuery()) {
            return rs.next();
        }
    } catch (SQLException ex) {
        lastError = ex.getMessage();
        return false;
    }
}

    // New method to check for existing email
    public boolean isEmailExists(String email) {
        DBconn cn = new DBconn();
        String sql = "SELECT email FROM users WHERE email = ?";
        try (PreparedStatement stmt = cn.con.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next(); // Returns true if a record is found
            }
        } catch (SQLException ex) {
            lastError = ex.getMessage();
            return false;
        }
    }

    public boolean register(String username, String email, String password) {
        DBconn cn = new DBconn();
        if (cn.con == null) {
            lastError = "Database connection failed: " + cn.lastError;
            return false;
        }
        
        String sql = "INSERT INTO users (username, email, password) VALUES (?, ?, SHA2(?, 256))";
        try (PreparedStatement stmt = cn.con.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setString(2, email);
            stmt.setString(3, password);
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException ex) {
            lastError = ex.getMessage();
            return false;
        }
    }

    public String getLastError() {
        return lastError;
    }
}



