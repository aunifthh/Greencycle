package Greencycle.dao;


import Greencycle.db.DBConnection;
import Greencycle.model.CategoryBean;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class CategoryDao {

    public List<CategoryBean> getAll() {
        List<CategoryBean> list = new ArrayList<>();
        String sql = "SELECT categoryID, categoryName, rate FROM RecyclableCategory";

        try (Connection c = DBConnection.getConnection();
             Statement s = c.createStatement();
             ResultSet r = s.executeQuery(sql)) {

            while (r.next()) {
                CategoryBean b = new CategoryBean();
                b.setCategoryID(r.getInt("categoryID"));   
                b.setCategoryName(r.getString("categoryName"));
                b.setRate(r.getDouble("rate"));
                list.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
     public String getCategoryNameByID(String categoryID) {
        String name = "";
        String sql = "SELECT categoryName FROM RecyclableCategory WHERE categoryID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {

            pst.setString(1, categoryID);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                name = rs.getString("categoryName");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return name;
    }
}

