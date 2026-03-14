/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 *
 * @author gayan
 */
public class registerInsert {
    private String lastError = "";

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

