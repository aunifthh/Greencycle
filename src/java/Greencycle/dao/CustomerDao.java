package Greencycle.dao;

import Greencycle.model.CustomerBean;
import Greencycle.db.DBConnection;
import java.sql.*;

public class CustomerDao {
    
    private String generateNextID() {
        String nextID = "CUS001"; // Default for first user
        String sql = "SELECT MAX(customerID) FROM Customer";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next() && rs.getString(1) != null) {
                String lastID = rs.getString(1); // e.g., "CUS005"
                int numericPart = Integer.parseInt(lastID.substring(3)); // gets 5
                numericPart++; // increment to 6
                nextID = String.format("CUS%03d", numericPart); // formats back to "CUS006"
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return nextID;
    }

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
                customer.setCustomerID(rs.getString("customerID"));
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
        String newID = generateNextID(); // Generate CUSXXX here

        String sql = "INSERT INTO Customer (customerID, fullName, email, password, phoneNo) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newID); // Set the generated String ID
            ps.setString(2, customer.getFullName());
            ps.setString(3, customer.getEmail());
            ps.setString(4, customer.getPassword());
            ps.setString(5, customer.getPhoneNo());

            int rows = ps.executeUpdate();
            if (rows > 0) success = true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }
}
