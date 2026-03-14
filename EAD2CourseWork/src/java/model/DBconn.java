/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import static java.lang.System.out;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author gayan
 */
public class DBconn {
    public Connection con;

    public DBconn() {
        try {
            out.println("1");
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/forum_db?zeroDateTimeBehavior=CONVERT_TO_NULL","root", "");
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBconn.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
}
