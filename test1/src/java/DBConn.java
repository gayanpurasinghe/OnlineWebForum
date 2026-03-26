/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
/**
 *
 * @author gayan
 */
public class DBConn {
    public Connection con;

    public DBConn(){
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/school?zeroDateTimeBehavior=CONVERT_TO_NULL","root","");
        }catch(ClassNotFoundException | SQLException ex){
            System.out.println("Connection failed");
        }
    }
}
