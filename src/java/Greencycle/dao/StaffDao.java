package Greencycle.dao;

import Greencycle.model.StaffBean;
import Greencycle.db.DBConnection;
import java.sql.*;

public class StaffDao {
    
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
                staff.setStaffID(rs.getInt("staffID"));
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
