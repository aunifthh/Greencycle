package Greencycle.dao;

import Greencycle.model.StaffBean;
import Greencycle.db.DBConnection;
import java.sql.*;

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
}
