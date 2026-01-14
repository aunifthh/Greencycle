package Greencycle;

import Greencycle.db.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DB_DIAG {
    public static void main(String[] args) {
        // Change this ID if needed, user mentioned Request ID 10 in logs
        int requestID = 10;

        System.out.println("Checking Quotation for Request ID: " + requestID);
        String sql = "SELECT * FROM Quotation WHERE requestID = ? ORDER BY quotationID DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, requestID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                System.out.println("--- Row ---");
                System.out.println("quotationID: " + rs.getInt("quotationID"));
                System.out.println("requestID: " + rs.getInt("requestID"));
                // System.out.println("staffID: " + rs.getString("staffID"));
                System.out.println("actualWeight: " + rs.getDouble("actualWeight"));
                System.out.println("totalAmount: " + rs.getDouble("totalAmount"));
                System.out.println("quotationType: " + rs.getString("quotationType"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
