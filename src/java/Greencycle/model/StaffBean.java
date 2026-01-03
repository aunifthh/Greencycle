/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Greencycle.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class StaffBean implements Serializable{
    private String staffID;
    private String staffName;
    private String staffEmail;
    private String staffPassword;
    private String staffPhoneNo;
    private String role; // e.g., 'Admin' or 'Staff'
    private Timestamp createdAt;

    public StaffBean() {}

    public String getStaffID() { return staffID;}
    public String getStaffName() { return staffName; }
    public String getStaffEmail() { return staffEmail; }
    public String getStaffPassword() { return staffPassword; }
    public String getStaffPhoneNo() { return staffPhoneNo; }
    public String getRole() { return role; }
    public Timestamp getCreatedAt() { return createdAt; }
    

    public void setStaffID(String staffID) { this.staffID = staffID; }
    public void setStaffName(String staffName) { this.staffName = staffName; }
    public void setStaffEmail(String staffEmail) { this.staffEmail = staffEmail; }
    public void setStaffPassword(String staffPassword) { this.staffPassword = staffPassword; }
    public void setStaffPhoneNo(String staffPhoneNo) { this.staffPhoneNo = staffPhoneNo; }
    public void setRole(String role) { this.role = role; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
}
