package Greencycle.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class AddressBean implements Serializable {
    private int addressID;
    private String categoryOfAddress; // e.g., "Home", "Office"
    private String addressLine1;
    private String addressLine2;
    private String poscode;
    private String city;
    private String state;
    private String remarks;
    private Timestamp createdAt;
    private String customerID;

    // Constructors
    public AddressBean() {}

    // Getters and Setters
    public int getAddressID() { return addressID; }
    public String getCategoryOfAddress() { return categoryOfAddress; }
    public String getAddressLine1() { return addressLine1; }
    public String getAddressLine2() { return addressLine2; }
    public String getPoscode() { return poscode; }
    public String getCity() { return city; }
    public String getState() { return state; }
    public String getRemarks() { return remarks; }
    public Timestamp getCreatedAt() { return createdAt; }
    public String getCustomerID() { return customerID; }
    
    public void setAddressID(int addressID) { this.addressID = addressID; }
    public void setCategoryOfAddress(String categoryOfAddress) { this.categoryOfAddress = categoryOfAddress; }
    public void setAddressLine1(String addressLine1) { this.addressLine1 = addressLine1; }
    public void setAddressLine2(String addressLine2) { this.addressLine2 = addressLine2; }
    public void setPoscode(String poscode) { this.poscode = poscode; }
    public void setCity(String city) { this.city = city; }
    public void setState(String state) { this.state = state; }
    public void setRemarks(String remarks) { this.remarks = remarks; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public void setCustomerID(String customerID) { this.customerID = customerID; }
}