package Greencycle.dao;

import Greencycle.model.RequestBean;
import Greencycle.db.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class RequestDao {

    // Retrieve all requests (for Admin) - Joined with Customer and Address
    public List<RequestBean> getAllRequests() {
        List<RequestBean> list = new ArrayList<>();
        String sql = "SELECT r.*, c.fullName, a.addressLine1, a.city " +
                "FROM PickupRequest r " +
                "JOIN Customer c ON r.customerID = c.customerID " +
                "LEFT JOIN Address a ON r.addressID = a.addressID " +
                "ORDER BY r.requestID DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                RequestBean bean = new RequestBean();
                bean.setRequestID(rs.getInt("requestID"));
                bean.setCustomerID(rs.getString("customerID"));
                bean.setAddressID(rs.getString("addressID")); // Changed to String
                bean.setStatus(rs.getString("status"));
                bean.setRequestedDate(rs.getDate("requestedDate"));
                bean.setEstimatedWeight(rs.getDouble("estimatedWeight"));

                // Joined fields
                bean.setCustomerName(rs.getString("fullName"));
                String addr = rs.getString("addressLine1");
                if (rs.getString("city") != null) {
                    addr += ", " + rs.getString("city");
                }
                bean.setFullAddress(addr);

                // Populate missing fields
                bean.setPickupDate(rs.getDate("pickupDate"));
                bean.setPickupTime(rs.getString("pickupTime"));
                bean.setPlasticWeight(rs.getDouble("plasticWeight"));
                bean.setPaperWeight(rs.getDouble("paperWeight"));
                bean.setMetalWeight(rs.getDouble("metalWeight"));

                list.add(bean);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Retrieve requests by Status (e.g., 'Pending', 'Pending Pickup')
    public List<RequestBean> getRequestsByStatus(String status) {
        List<RequestBean> list = new ArrayList<>();
        String sql = "SELECT r.*, c.fullName, a.addressLine1, a.city " +
                "FROM PickupRequest r " +
                "JOIN Customer c ON r.customerID = c.customerID " +
                "LEFT JOIN Address a ON r.addressID = a.addressID " +
                "WHERE r.status = ? " +
                "ORDER BY r.requestID ASC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                RequestBean bean = new RequestBean();
                bean.setRequestID(rs.getInt("requestID"));
                bean.setCustomerID(rs.getString("customerID"));
                bean.setAddressID(rs.getString("addressID")); // Changed to String
                bean.setStatus(rs.getString("status"));
                bean.setRequestedDate(rs.getDate("requestedDate"));
                bean.setEstimatedWeight(rs.getDouble("estimatedWeight"));

                bean.setCustomerName(rs.getString("fullName"));
                String addr = rs.getString("addressLine1");
                if (rs.getString("city") != null) {
                    addr += ", " + rs.getString("city");
                }
                bean.setFullAddress(addr);

                // Populate missing fields
                bean.setPickupDate(rs.getDate("pickupDate"));
                bean.setPickupTime(rs.getString("pickupTime"));
                bean.setPlasticWeight(rs.getDouble("plasticWeight"));
                bean.setPaperWeight(rs.getDouble("paperWeight"));
                bean.setMetalWeight(rs.getDouble("metalWeight"));

                list.add(bean);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Update Status (Admin or Staff actions)
    public boolean updateStatus(int requestID, String newStatus) {
        String sql = "UPDATE PickupRequest SET status = ? WHERE requestID = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newStatus);
            ps.setInt(2, requestID);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean createQuotation(int requestID, String staffID, double weight, double totalAmount) {
        String sql = "INSERT INTO Quotation (requestID, staffID, actualWeight, totalAmount) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, requestID);
            ps.setString(2, staffID);
            ps.setDouble(3, weight);
            ps.setDouble(4, totalAmount);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // NEW METHODS FOR COMPLETE WORKFLOW

    // Customer creates pickup request with material weights
    public int createRequest(String customerID, String addressID, double plasticWeight, double paperWeight,
            double metalWeight, Date pickupDate, String pickupTime) { // Changed addressID to String
        String sql = "INSERT INTO PickupRequest (customerID, addressID, status, requestedDate, plasticWeight, paperWeight, metalWeight, estimatedWeight, pickupDate, pickupTime) "
                +
                "VALUES (?, ?, 'Pending Pickup', CURRENT_DATE, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            double totalWeight = plasticWeight + paperWeight + metalWeight;
            ps.setString(1, customerID);
            ps.setString(2, addressID); // Changed to setString
            ps.setDouble(3, plasticWeight);
            ps.setDouble(4, paperWeight);
            ps.setDouble(5, metalWeight);
            ps.setDouble(6, totalWeight);
            ps.setDate(7, pickupDate);
            ps.setString(8, pickupTime);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1); // Return generated requestID
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    // Create initial quotation (customer self-weigh)
    public boolean createInitialQuotation(int requestID, double plasticWeight, double paperWeight, double metalWeight,
            double plasticRate, double paperRate, double metalRate) {
        double totalAmount = (plasticWeight * plasticRate) + (paperWeight * paperRate) + (metalWeight * metalRate);
        String sql = "INSERT INTO Quotation (requestID, actualWeight, totalAmount, quotationType) VALUES (?, ?, ?, 'INITIAL')";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, requestID);
            ps.setDouble(2, plasticWeight + paperWeight + metalWeight);
            ps.setDouble(3, totalAmount);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update pickup schedule (customer accepts quotation)
    public boolean updatePickupSchedule(int requestID, Date pickupDate, String pickupTime) {
        String sql = "UPDATE PickupRequest SET pickupDate = ?, pickupTime = ?, status = 'Pending Pickup' WHERE requestID = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, pickupDate);
            ps.setString(2, pickupTime);
            ps.setInt(3, requestID);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Cancel request (customer rejects quotation)
    public boolean cancelRequest(int requestID) {
        return updateStatus(requestID, "Rejected");
    }

    // Staff updates with verified weight
    public boolean updateVerifiedWeight(int requestID, double plasticWeight, double paperWeight, double metalWeight,
            double plasticRate, double paperRate, double metalRate, String staffID) {
        // Update request with actual weights (Use these columns for the STAFF's values
        // now)
        // NOTE: We are NOT updating estimatedWeight, preserving the customer's original
        // input.
        String updateSql = "UPDATE PickupRequest SET plasticWeight = ?, paperWeight = ?, metalWeight = ? WHERE requestID = ?";
        double totalWeight = plasticWeight + paperWeight + metalWeight;
        double totalAmount = (plasticWeight * plasticRate) + (paperWeight * paperRate) + (metalWeight * metalRate);

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps1 = conn.prepareStatement(updateSql)) {

            ps1.setDouble(1, plasticWeight);
            ps1.setDouble(2, paperWeight);
            ps1.setDouble(3, metalWeight);
            ps1.setInt(4, requestID);
            ps1.executeUpdate();

            // Create INITIAL quotation (Staff sets the initial quote based on their weigh)
            String quoteSql = "INSERT INTO Quotation (requestID, staffID, actualWeight, totalAmount, quotationType) VALUES (?, ?, ?, ?, 'INITIAL')";

            PreparedStatement ps2 = conn.prepareStatement(quoteSql);
            ps2.setInt(1, requestID);
            ps2.setString(2, staffID);
            ps2.setDouble(3, totalWeight);
            ps2.setDouble(4, totalAmount);
            ps2.executeUpdate();

            // Update status to Quoted (waiting for customer acceptance)
            updateStatus(requestID, "Quoted");

            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Customer accepts verified weight on-site
    public boolean acceptVerifiedQuotation(int requestID) {
        // Update status to Pending Payment
        boolean statusUpdated = updateStatus(requestID, "Pending Payment");

        if (statusUpdated) {
            // Update the latest quotation to VERIFIED
            // Simpler approach: Update the most recent quotation for this request or just
            // all INITIALs (since there should be only one active chain).

            String genericUpdate = "UPDATE Quotation SET quotationType = 'VERIFIED' WHERE requestID = ?";
            try (Connection conn = DBConnection.getConnection();
                    PreparedStatement ps = conn.prepareStatement(genericUpdate)) {
                ps.setInt(1, requestID);
                ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return statusUpdated;
    }

    // Admin releases payment
    public boolean releasePayment(int requestID) {
        return updateStatus(requestID, "Payment Completed");
    }

    // Get request by ID (for viewing details)
    public RequestBean getRequestById(int requestID) {
        String sql = "SELECT r.*, c.fullName, a.addressLine1, a.city " +
                "FROM PickupRequest r " +
                "JOIN Customer c ON r.customerID = c.customerID " +
                "LEFT JOIN Address a ON r.addressID = a.addressID " +
                "WHERE r.requestID = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, requestID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                RequestBean bean = new RequestBean();
                bean.setRequestID(rs.getInt("requestID"));
                bean.setCustomerID(rs.getString("customerID"));
                bean.setAddressID(rs.getString("addressID")); // Changed to String
                bean.setStatus(rs.getString("status"));
                bean.setRequestedDate(rs.getDate("requestedDate"));
                bean.setEstimatedWeight(rs.getDouble("estimatedWeight"));
                bean.setPlasticWeight(rs.getDouble("plasticWeight"));
                bean.setPaperWeight(rs.getDouble("paperWeight"));
                bean.setMetalWeight(rs.getDouble("metalWeight"));
                bean.setPickupDate(rs.getDate("pickupDate"));
                bean.setPickupTime(rs.getString("pickupTime"));

                bean.setCustomerName(rs.getString("fullName"));
                String addr = rs.getString("addressLine1");
                if (rs.getString("city") != null) {
                    addr += ", " + rs.getString("city");
                }
                bean.setFullAddress(addr);

                return bean;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get quotation for a request
    public double getQuotationAmount(int requestID) {
        String sql = "SELECT totalAmount FROM Quotation WHERE requestID = ? ORDER BY quotationID DESC FETCH FIRST 1 ROWS ONLY";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, requestID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                double val = rs.getDouble("totalAmount");
                System.out.println("DEBUG: getQuotationAmount for " + requestID + " returned: " + val);
                return val;
            } else {
                System.out.println("DEBUG: getQuotationAmount for " + requestID + " returned NO RESULT");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    // Get requests by customer
    public List<RequestBean> getRequestsByCustomer(String customerID) {
        List<RequestBean> list = new ArrayList<>();
        String sql = "SELECT r.*, a.addressLine1, a.city " +
                "FROM PickupRequest r " +
                "LEFT JOIN Address a ON r.addressID = a.addressID " +
                "WHERE r.customerID = ? " +
                "ORDER BY r.requestID DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, customerID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                RequestBean bean = new RequestBean();
                bean.setRequestID(rs.getInt("requestID"));
                bean.setCustomerID(rs.getString("customerID"));
                bean.setAddressID(rs.getString("addressID")); // Changed to String
                bean.setStatus(rs.getString("status"));
                bean.setRequestedDate(rs.getDate("requestedDate"));
                bean.setEstimatedWeight(rs.getDouble("estimatedWeight"));
                bean.setPlasticWeight(rs.getDouble("plasticWeight"));
                bean.setPaperWeight(rs.getDouble("paperWeight"));
                bean.setMetalWeight(rs.getDouble("metalWeight"));
                bean.setPickupDate(rs.getDate("pickupDate"));
                bean.setPickupTime(rs.getString("pickupTime"));

                String addr = rs.getString("addressLine1");
                if (rs.getString("city") != null) {
                    addr += ", " + rs.getString("city");
                }
                bean.setFullAddress(addr);

                list.add(bean);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<String, Integer> getPickupCountsByDate(Date pickupDate) {
        Map<String, Integer> counts = new HashMap<>();
        String sql = "SELECT pickupTime, COUNT(*) AS count FROM PickupRequest WHERE pickupDate = ? GROUP BY pickupTime";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, pickupDate);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                counts.put(rs.getString("pickupTime"), rs.getInt("count"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return counts;
    }

}
