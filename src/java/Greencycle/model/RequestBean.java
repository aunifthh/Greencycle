package Greencycle.model;

import java.sql.Date;

public class RequestBean {
    private int requestID;
    private String customerID;
    private String addressID;
    private String status;
    private Date requestedDate;
    private double estimatedWeight;

    // Material weights
    private double plasticWeight;
    private double paperWeight;
    private double metalWeight;

    // Pickup scheduling
    private Date pickupDate;
    private String pickupTime;

    // Optional: For display purposes (Joined data)
    private String customerName; // From Customer table
    private String fullAddress; // From Address table

    public RequestBean() {
    }

    public int getRequestID() {
        return requestID;
    }

    public void setRequestID(int requestID) {
        this.requestID = requestID;
    }

    public String getCustomerID() {
        return customerID;
    }

    public void setCustomerID(String customerID) {
        this.customerID = customerID;
    }

    public String getAddressID() {
        return addressID;
    }

    public void setAddressID(String addressID) {
        this.addressID = addressID;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getRequestedDate() {
        return requestedDate;
    }

    public void setRequestedDate(Date requestedDate) {
        this.requestedDate = requestedDate;
    }

    public double getEstimatedWeight() {
        return estimatedWeight;
    }

    public void setEstimatedWeight(double estimatedWeight) {
        this.estimatedWeight = estimatedWeight;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getFullAddress() {
        return fullAddress;
    }

    public void setFullAddress(String fullAddress) {
        this.fullAddress = fullAddress;
    }

    public double getPlasticWeight() {
        return plasticWeight;
    }

    public void setPlasticWeight(double plasticWeight) {
        this.plasticWeight = plasticWeight;
    }

    public double getPaperWeight() {
        return paperWeight;
    }

    public void setPaperWeight(double paperWeight) {
        this.paperWeight = paperWeight;
    }

    public double getMetalWeight() {
        return metalWeight;
    }

    public void setMetalWeight(double metalWeight) {
        this.metalWeight = metalWeight;
    }

    public Date getPickupDate() {
        return pickupDate;
    }

    public void setPickupDate(Date pickupDate) {
        this.pickupDate = pickupDate;
    }

    public String getPickupTime() {
        return pickupTime;
    }

    public void setPickupTime(String pickupTime) {
        this.pickupTime = pickupTime;
    }
}
