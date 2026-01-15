package Greencycle.dao;

import Greencycle.db.DBConnection;
import Greencycle.model.PickupItemBean;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PickupItemDao {

    // Add multiple items for a pickup
    public void addItems(String requestID, List<PickupItemBean> items, Connection conn) throws SQLException {
        String sql = "INSERT INTO PickupItems (requestID, categoryID, quantity, subtotal) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (PickupItemBean item : items) {
                ps.setString(1, requestID);
                ps.setString(2, item.getCategoryID());
                ps.setDouble(3, item.getQuantity());
                ps.setDouble(4, item.getSubtotal());
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    // Fetch items by requestID
    public List<PickupItemBean> getItemsByRequestID(String requestID) {
        List<PickupItemBean> items = new ArrayList<>();
        String sql = "SELECT pi.itemID, pi.requestID, pi.categoryID, pi.quantity, pi.subtotal, rc.categoryName " +
                     "FROM PickupItems pi " +
                     "JOIN RecyclableCategory rc ON pi.categoryID = rc.categoryID " +
                     "WHERE pi.requestID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, requestID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PickupItemBean item = new PickupItemBean();
                item.setItemID(rs.getInt("itemID"));
                item.setRequestID(rs.getString("requestID"));
                item.setCategoryID(rs.getString("categoryID"));
                item.setCategoryName(rs.getString("categoryName")); // human-readable
                item.setQuantity(rs.getDouble("quantity"));
                item.setSubtotal(rs.getDouble("subtotal"));
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }
}
