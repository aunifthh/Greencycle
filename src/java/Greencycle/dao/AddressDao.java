package Greencycle.dao;

import Greencycle.model.AddressBean;
import Greencycle.db.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AddressDao {

    // Generate next addressID (e.g., ADD001 → ADD002)
    public String generateNextID() {
        String nextID = "ADD001";
        String sql = "SELECT MAX(addressID) FROM Address";

        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next() && rs.getString(1) != null) {
                String lastID = rs.getString(1); // e.g., "ADD005"
                int num = Integer.parseInt(lastID.substring(3)); // "005" → 5
                num++;
                nextID = String.format("ADD%03d", num); // → "ADD006"
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return nextID;
    }

    // Get all addresses for a customer
    public List<AddressBean> getAddressesByCustomerID(String customerID) {
        List<AddressBean> addresses = new ArrayList<>();
        String sql = "SELECT * FROM Address WHERE customerID = ? ORDER BY createdAt DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, customerID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                AddressBean addr = new AddressBean();
                addr.setAddressID(rs.getString("addressID"));
                addr.setCategoryOfAddress(rs.getString("categoryOfAddress"));
                addr.setAddressLine1(rs.getString("addressLine1"));
                addr.setAddressLine2(rs.getString("addressLine2"));
                addr.setPoscode(rs.getString("poscode"));
                addr.setCity(rs.getString("city"));
                addr.setState(rs.getString("state"));
                addr.setRemarks(rs.getString("remarks"));
                addr.setCreatedAt(rs.getTimestamp("createdAt"));
                addr.setCustomerID(rs.getString("customerID"));
                addresses.add(addr);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return addresses;
    }

    // Save new address
    public boolean saveAddress(AddressBean address) {
        String sql = "INSERT INTO Address (addressID, categoryOfAddress, addressLine1, addressLine2, poscode, city, state, remarks, customerID) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, address.getAddressID());
            ps.setString(2, address.getCategoryOfAddress());
            ps.setString(3, address.getAddressLine1());
            ps.setString(4, address.getAddressLine2());
            ps.setString(5, address.getPoscode());
            ps.setString(6, address.getCity());
            ps.setString(7, address.getState());
            ps.setString(8, address.getRemarks());
            ps.setString(9, address.getCustomerID());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update address
    public boolean updateAddress(AddressBean address) {
        String sql = "UPDATE Address SET categoryOfAddress = ?, addressLine1 = ?, addressLine2 = ?, poscode = ?, city = ?, state = ?, remarks = ? WHERE addressID = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, address.getCategoryOfAddress());
            ps.setString(2, address.getAddressLine1());
            ps.setString(3, address.getAddressLine2());
            ps.setString(4, address.getPoscode());
            ps.setString(5, address.getCity());
            ps.setString(6, address.getState());
            ps.setString(7, address.getRemarks());
            ps.setString(8, address.getAddressID());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete address
    public boolean deleteAddress(String addressID) {
        String sql = "DELETE FROM Address WHERE addressID = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, addressID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
