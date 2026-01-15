package Greencycle.dao;

import Greencycle.model.CustomerBean;
import Greencycle.db.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

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
            if (rows > 0) {
                success = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    // Add this method to Greencycle/dao/CustomerDao.java
    public CustomerBean getCustomerById(String customerID) {
        CustomerBean customer = null;
        String sql = "SELECT * FROM Customer WHERE customerID = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, customerID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                customer = new CustomerBean();
                customer.setCustomerID(rs.getString("customerID"));
                customer.setFullName(rs.getString("fullName"));
                customer.setEmail(rs.getString("email"));
                customer.setPhoneNo(rs.getString("phoneNo"));
                customer.setBankName(rs.getString("bankName"));
                customer.setBankAccountNo(rs.getString("bankAccountNo"));
                customer.setCreatedAt(rs.getTimestamp("createdAt"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customer;
    }

    // Update basic profile info
    public boolean updateCustomer(String customerID, String fullName, String email, String phoneNo, String password) {
        String sql;
        if (password != null && !password.trim().isEmpty()) {
            sql = "UPDATE Customer SET fullName = ?, email = ?, phoneNo = ?, password = ? WHERE customerID = ?";
        } else {
            sql = " UPDATE Customer SET fullName = ?, email = ?, phoneNo = ? WHERE customerID = ?";
        }

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, phoneNo);
            if (password != null && !password.trim().isEmpty()) {
                ps.setString(4, password);
                ps.setString(5, customerID);
            } else {
                ps.setString(4, customerID);
            }
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update bank info only
    public boolean updateBankInfo(String customerID, String bankName, String bankAccountNo) {
        String sql = "UPDATE Customer SET bankName = ?, bankAccountNo = ? WHERE customerID = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, bankName);
            ps.setString(2, bankAccountNo);
            ps.setString(3, customerID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // READ: Get all customers
    public List<CustomerBean> getAllCustomers() {
        List<CustomerBean> list = new ArrayList<>();
        String sql = "SELECT * FROM Customer ORDER BY customerID ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                CustomerBean c = new CustomerBean();
                c.setCustomerID(rs.getString("customerID"));
                c.setFullName(rs.getString("fullName"));
                c.setEmail(rs.getString("email"));
                c.setPhoneNo(rs.getString("phoneNo"));
                c.setBankName(rs.getString("bankName"));
                c.setBankAccountNo(rs.getString("bankAccountNo"));
                list.add(c);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // UPDATE: Edit Customer (including Bank Details)
    public boolean updateCustomer(CustomerBean c) {
        String sql = "UPDATE Customer SET fullName=?, email=?, phoneNo=?, bankName=?, bankAccountNo=? WHERE customerID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getFullName());
            ps.setString(2, c.getEmail());
            ps.setString(3, c.getPhoneNo());
            ps.setString(4, c.getBankName());
            ps.setString(5, c.getBankAccountNo());
            ps.setString(6, c.getCustomerID());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // DELETE: Remove Customer
    public boolean deleteCustomer(String id) {
        String sql = "DELETE FROM Customer WHERE customerID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}
