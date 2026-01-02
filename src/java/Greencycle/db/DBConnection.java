/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Greencycle.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Note: localhost:1527 is the default port for Java DB/Derby
    // We add ;create=true so it creates the DB if it doesn't exist
    private static final String URL = "jdbc:derby://localhost:1527/Greencycle;create=true";
    private static final String USER = "app"; 
    private static final String PASS = "app"; 

    public static Connection getConnection() {
        Connection conn = null;
        try {
            // Use the Derby Client Driver
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(URL, USER, PASS);
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("Connection Error: " + e.getMessage());
            e.printStackTrace();
        }
        return conn;
    }
}
