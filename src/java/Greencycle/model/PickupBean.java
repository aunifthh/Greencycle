package Greencycle.model;

import java.io.Serializable;
import java.util.List;

public class PickupBean implements Serializable {
    private String requestID;
    private String customerID;
    private String addressID;
    private String pickupDate;
    private String pickupTime;
    private String remarks;
    private double totalPrice;
    private String status;

    private AddressBean address; // for display
    private List<PickupItemBean> items;

    public PickupBean() {}

    public String getRequestID() { return requestID; }
    public void setRequestID(String requestID) { this.requestID = requestID; }

    public String getCustomerID() { return customerID; }
    public void setCustomerID(String customerID) { this.customerID = customerID; }

    public String getAddressID() { return addressID; }
    public void setAddressID(String addressID) { this.addressID = addressID; }

    public String getPickupDate() { return pickupDate; }
    public void setPickupDate(String pickupDate) { this.pickupDate = pickupDate; }

    public String getPickupTime() { return pickupTime; }
    public void setPickupTime(String pickupTime) { this.pickupTime = pickupTime; }

    public String getRemarks() { return remarks; }
    public void setRemarks(String remarks) { this.remarks = remarks; }

    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public List<PickupItemBean> getItems() { return items; }
    public void setItems(List<PickupItemBean> items) { this.items = items; }

    public AddressBean getAddress() { return address; }
    public void setAddress(AddressBean address) { this.address = address; }

    // Helper
    public double getTotalQuantity() {
        if (items == null) return 0.0;
        return items.stream().mapToDouble(PickupItemBean::getQuantity).sum();
    }
}
