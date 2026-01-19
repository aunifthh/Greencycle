package Greencycle.dao;

import Greencycle.model.RecyclableItemBean;
import Greencycle.db.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RecyclableItemDao {

    // Generate ID format: ITM001
    private String generateNextID() {
        String nextID = "ITM001";
        String sql = "SELECT MAX(recyclableItemID) FROM RecyclableItem";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next() && rs.getString(1) != null) {
                String lastID = rs.getString(1);
                int numericPart = Integer.parseInt(lastID.substring(3));
                nextID = String.format("ITM%03d", ++numericPart);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return nextID;
    }

    public List<RecyclableItemBean> getAllItems() {
        List<RecyclableItemBean> list = new ArrayList<>();
        String sql = "SELECT * FROM RecyclableItem ORDER BY recyclableItemID ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                RecyclableItemBean item = new RecyclableItemBean();
                item.setRecyclableItemID(rs.getString("recyclableItemID"));
                item.setRecyclableItemName(rs.getString("recyclableItemName"));
                item.setRatePerKg(rs.getDouble("ratePerKg"));
                list.add(item);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean addItem(RecyclableItemBean item) {
        String sql = "INSERT INTO RecyclableItem (recyclableItemID, recyclableItemName, ratePerKg) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, generateNextID());
            ps.setString(2, item.getRecyclableItemName());
            ps.setDouble(3, item.getRatePerKg());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean updateItem(RecyclableItemBean item) {
        String sql = "UPDATE RecyclableItem SET recyclableItemName=?, ratePerKg=? WHERE recyclableItemID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, item.getRecyclableItemName());
            ps.setDouble(2, item.getRatePerKg());
            ps.setString(3, item.getRecyclableItemID());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean deleteItem(String id) {
        String sql = "DELETE FROM RecyclableItem WHERE recyclableItemID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}