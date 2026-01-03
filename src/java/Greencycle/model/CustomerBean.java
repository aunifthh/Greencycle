package Greencycle.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class CustomerBean implements Serializable {
    private String customerID;
    private String fullName;
    private String email;
    private String password;
    private String phoneNo;
    private String bankName;
    private String bankAccountNo;
    private Timestamp createdAt;
    
    public CustomerBean(){}
    
    public String getCustomerID() { return customerID; }
    public String getFullName() { return fullName; }
    public String getEmail() { return email; }
    public String getPassword() { return password; }
    public String getPhoneNo() { return phoneNo; }
    public String getBankName() { return bankName; }
    public String getBankAccountNo() { return bankAccountNo; }
    public Timestamp getCreatedAt() { return createdAt; }
     
    public void setCustomerID(String customerID) { this.customerID = customerID; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public void setEmail(String email) { this.email = email; }
    public void setPassword(String password) { this.password = password; }
    public void setPhoneNo(String phoneNo) { this.phoneNo = phoneNo; }
    public void setBankName(String bankName) { this.bankName = bankName; }
    public void setBankAccountNo(String bankAccountNo) { this.bankAccountNo = bankAccountNo; }
    public void setCreatedAt(Timestamp createdAt) {this.createdAt = createdAt;}
    
    
}
