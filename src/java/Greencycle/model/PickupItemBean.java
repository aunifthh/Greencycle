package Greencycle.model;

import java.io.Serializable;

public class PickupItemBean implements Serializable {
    private int itemID;
    private String requestID;
    private String categoryID;
    private double quantity;
    private double subtotal;
     private String categoryName;

    public PickupItemBean() {}

    public int getItemID() { return itemID; }
    public void setItemID(int itemID) { this.itemID = itemID; }

    public String getRequestID() { return requestID; }
    public void setRequestID(String requestID) { this.requestID = requestID; }

    public String getCategoryID() { return categoryID; }
    public void setCategoryID(String categoryID) { this.categoryID = categoryID; }

    public double getQuantity() { return quantity; }
    public void setQuantity(double quantity) { this.quantity = quantity; }

    public double getSubtotal() { return subtotal; }
    public void setSubtotal(double subtotal) { this.subtotal = subtotal; }
    
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
}

