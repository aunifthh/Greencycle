package Greencycle.dao;

import Greencycle.db.DBConnection;
import Greencycle.model.PickupBean;
import Greencycle.model.PickupItemBean;
import Greencycle.model.AddressBean;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PickupDao {

    private PickupItemDao pickupItemDao = new PickupItemDao();
    private AddressDao addressDao = new AddressDao();

    // Generate next requestID
    private String generateNextID(Connection conn) throws SQLException {
        String sql = "SELECT MAX(requestID) FROM PickupRequest";
        String nextID = "REQ001";

        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next() && rs.getString(1) != null) {
                int num = Integer.parseInt(rs.getString(1).substring(3)) + 1;
                nextID = String.format("REQ%03d", num);
            }
        }
        return nextID;
    }

    // Add Pickup with items
    public boolean addPickup(PickupBean pickup) {
        String sql = "INSERT INTO PickupRequest " +
                     "(requestID, customerID, addressID, pickup_date, pickup_time, remarks, total_price, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String requestID = generateNextID(conn);
            pickup.setRequestID(requestID);

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, requestID);
                ps.setString(2, pickup.getCustomerID());
                ps.setString(3, pickup.getAddressID());
                ps.setDate(4, Date.valueOf(pickup.getPickupDate()));
                ps.setString(5, pickup.getPickupTime());
                ps.setString(6, pickup.getRemarks());
                ps.setDouble(7, pickup.getTotalPrice());
                ps.setString(8, "Pending");
                ps.executeUpdate();
            }

            // Insert items
            pickupItemDao.addItems(requestID, pickup.getItems(), conn);

            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            return false;
        } finally {
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    // Fetch all pickups for a customer
    public List<PickupBean> getAllPickups(String customerID) {
        List<PickupBean> list = new ArrayList<>();
        String sql = "SELECT * FROM PickupRequest WHERE customerID=? ORDER BY requestID DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, customerID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                PickupBean p = new PickupBean();
                p.setRequestID(rs.getString("requestID"));
                p.setCustomerID(customerID);
                p.setAddressID(rs.getString("addressID"));
                p.setPickupDate(rs.getDate("pickup_date").toString());
                p.setPickupTime(rs.getString("pickup_time"));
                p.setRemarks(rs.getString("remarks"));
                p.setTotalPrice(rs.getDouble("total_price"));
                p.setStatus(rs.getString("status"));

                // Fetch pickup items with category names
                p.setItems(pickupItemDao.getItemsByRequestID(p.getRequestID()));

                // Fetch address object
                AddressBean addr = addressDao.getAddressByID(p.getAddressID());
                if (addr != null) p.setAddress(addr);

                list.add(p);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public List<PickupItemBean> getItemsByRequestID(String requestID) {
    List<PickupItemBean> items = new ArrayList<>();
    String sql = "SELECT categoryID, quantity, subtotal FROM PickupItems WHERE requestID=?";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setString(1, requestID);
        ResultSet rs = ps.executeQuery();

        CategoryDao categoryDao = new CategoryDao(); // to get category name

        while (rs.next()) {
            PickupItemBean item = new PickupItemBean();
            item.setCategoryID(rs.getString("categoryID"));
            item.setQuantity(rs.getDouble("quantity"));
            item.setSubtotal(rs.getDouble("subtotal"));

            // set human-readable category name
            item.setCategoryName(categoryDao.getCategoryNameByID(item.getCategoryID()));

            items.add(item);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return items;
}

}
