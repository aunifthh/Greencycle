package Greencycle.dao;

import Greencycle.model.CustomerBean;
import Greencycle.db.DBConnection;
import java.sql.*;

public class CustomerDao {

    // For Login
    public CustomerBean authenticateCustomer(String email, String password) {
        CustomerBean customer = null;
        String sql = "SELECT * FROM Customer WHERE email = ? AND password = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                customer = new CustomerBean();
                customer.setCustomerID(rs.getInt("customerID"));
                customer.setFullName(rs.getString("fullName"));
                customer.setEmail(rs.getString("email"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customer;
    }

    // For Signup
    public boolean registerCustomer(CustomerBean customer) {
        boolean success = false;
        String sql = "INSERT INTO Customer (fullName, email, password, phoneNo) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, customer.getFullName());
            ps.setString(2, customer.getEmail());
            ps.setString(3, customer.getPassword());
            ps.setString(4, customer.getPhoneNo());
            
            int rows = ps.executeUpdate();
            if (rows > 0) success = true;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }
}
