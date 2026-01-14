package Greencycle.dao;

import Greencycle.db.DBConnection;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;

public class RateDao {

    // Get all rates as a Map (ItemName -> Price)
    public Map<String, Double> getAllRates() {
        Map<String, Double> rates = new HashMap<>();
        String sql = "SELECT itemName, pricePerKg FROM RecyclableItem";

        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                rates.put(rs.getString("itemName"), rs.getDouble("pricePerKg"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rates;
    }

    // Update a specific rate
    public boolean updateRate(String itemName, double newPrice) {
        String sql = "UPDATE RecyclableItem SET pricePerKg = ? WHERE itemName = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDouble(1, newPrice);
            ps.setString(2, itemName);

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
