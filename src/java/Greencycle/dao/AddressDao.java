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
    // Get all addresses for a customer
    public List<AddressBean> getAddressesByCustomerID(String customerID) {
        List<AddressBean> addresses = new ArrayList<>();
        // Fetch addresses owned by customer
        String sql = "SELECT * FROM APP.ADDRESS WHERE CUSTOMERID = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, customerID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                AddressBean addr = new AddressBean();
                addr.setAddressID(rs.getString("ADDRESSID"));
                // addr.setCategoryOfAddress(rs.getString("CATEGORYOFADDRESS"));
                addr.setAddressLine1(rs.getString("ADDRESSLINE1"));
                addr.setAddressLine2(rs.getString("ADDRESSLINE2"));
                addr.setPoscode(rs.getString("POSTCODE")); // Fixed column name
                addr.setCity(rs.getString("CITY"));
                addr.setState(rs.getString("STATE"));
                // addr.setRemarks(rs.getString("REMARKS")); // Column appears missing
                // addr.setCreatedAt(rs.getTimestamp("CREATEDAT")); // Column appears missing
                addr.setCustomerID(rs.getString("CUSTOMERID"));
                addresses.add(addr);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return addresses;
    }

    // Save new address
    public boolean saveAddress(AddressBean address) {
        String sql = "INSERT INTO Address (addressID, addressLine1, addressLine2, poscode, city, state, remarks, customerID) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, address.getAddressID());
            // ps.setString(2, address.getCategoryOfAddress());
            ps.setString(2, address.getAddressLine1());
            ps.setString(3, address.getAddressLine2());
            ps.setString(4, address.getPoscode());
            ps.setString(5, address.getCity());
            ps.setString(6, address.getState());
            ps.setString(7, address.getRemarks());
            ps.setString(8, address.getCustomerID());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update address
    public boolean updateAddress(AddressBean address) {
        String sql = "UPDATE Address SET addressLine1 = ?, addressLine2 = ?, poscode = ?, city = ?, state = ?, remarks = ? WHERE addressID = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, address.getAddressLine1());
            ps.setString(2, address.getAddressLine2());
            ps.setString(3, address.getPoscode());
            ps.setString(4, address.getCity());
            ps.setString(5, address.getState());
            ps.setString(6, address.getRemarks());
            ps.setString(7, address.getAddressID());

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

    // Debug method to diagnose connection and query issues
    public String getDebugInfo(String customerID) {
        StringBuilder sb = new StringBuilder();
        sb.append("Debug Log: ");

        try (Connection conn = DBConnection.getConnection()) {
            sb.append("DB Connected. ");

            // Check total rows
            try (Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM APP.ADDRESS")) {
                if (rs.next()) {
                    sb.append("Total Rows in APP.ADDRESS: " + rs.getInt(1) + ". ");
                }
            } catch (Exception e) {
                sb.append("Error counting rows: " + e.getMessage() + ". ");
            }

            // Check specific user query
            String sql = "SELECT * FROM APP.ADDRESS WHERE CUSTOMERID = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, customerID);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        sb.append("Rows Found. Columns: ");
                        java.sql.ResultSetMetaData md = rs.getMetaData();
                        int count = md.getColumnCount();
                        for (int i = 1; i <= count; i++) {
                            sb.append(md.getColumnName(i) + ", ");
                        }
                        sb.append(". ");
                    } else {
                        sb.append("No rows found for user. ");
                    }
                }
            } catch (Exception e) {
                sb.append("Error querying user: " + e.getMessage() + ". ");
            }

        } catch (SQLException e) {
            sb.append("DB Connection Failed: " + e.getMessage());
        }

        return sb.toString();
    }
}
