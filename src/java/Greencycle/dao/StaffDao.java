package Greencycle.dao;

import Greencycle.model.StaffBean;
import Greencycle.db.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StaffDao {
    
    private String generateNextID() {
        String nextID = "STF001"; // Default for first user
        String sql = "SELECT MAX(staffID) FROM Staff";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next() && rs.getString(1) != null) {
                String lastID = rs.getString(1); // e.g., "CUS005"
                int numericPart = Integer.parseInt(lastID.substring(3)); // gets 5
                numericPart++; // increment to 6
                nextID = String.format("STF%03d", numericPart); // formats back to "CUS006"
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return nextID;
    }
    
    public StaffBean authenticateStaff(String email, String password) {
        StaffBean staff = null;
        String sql = "SELECT * FROM Staff WHERE staffEmail = ? AND staffPassword = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                staff = new StaffBean();
                staff.setStaffID(rs.getString("staffID"));
                staff.setStaffName(rs.getString("staffName"));
                staff.setStaffEmail(rs.getString("staffEmail"));
                staff.setRole(rs.getString("role"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return staff;
    }
    
    // READ: Get all staff
    public List<StaffBean> getAllStaff() {
        List<StaffBean> list = new ArrayList<>();
        String sql = "SELECT * FROM Staff ORDER BY staffID ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                StaffBean s = new StaffBean();
                s.setStaffID(rs.getString("staffID"));
                s.setStaffName(rs.getString("staffName"));
                s.setStaffEmail(rs.getString("staffEmail"));
                s.setStaffPhoneNo(rs.getString("staffPhoneNo"));
                s.setRole(rs.getString("role"));
                list.add(s);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // CREATE: Add Staff
    public boolean addStaff(StaffBean s) {
        String newID = generateNextID();
        String sql = "INSERT INTO Staff (staffID, staffName, staffEmail, staffPassword, staffPhoneNo, role) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newID);
            ps.setString(2, s.getStaffName());
            ps.setString(3, s.getStaffEmail());
            ps.setString(4, "staff123"); // Default password
            ps.setString(5, s.getStaffPhoneNo());
            ps.setString(6, "staff");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // UPDATE: Edit Staff
    public boolean updateStaff(StaffBean s) {
        String sql = "UPDATE Staff SET staffName=?, staffEmail=?, staffPhoneNo=? WHERE staffID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getStaffName());
            ps.setString(2, s.getStaffEmail());
            ps.setString(3, s.getStaffPhoneNo());
            ps.setString(4, s.getStaffID());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // DELETE: Remove Staff
    public boolean deleteStaff(String id) {
        String sql = "DELETE FROM Staff WHERE staffID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}
