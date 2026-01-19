package Greencycle.model;

import java.io.Serializable;

public class RecyclableItemBean implements Serializable {
    private String recyclableItemID;
    private String recyclableItemName;
    private double ratePerKg;

    public RecyclableItemBean() {}

    public String getRecyclableItemID() { return recyclableItemID; }
    public void setRecyclableItemID(String recyclableItemID) { this.recyclableItemID = recyclableItemID; }

    public String getRecyclableItemName() { return recyclableItemName; }
    public void setRecyclableItemName(String recyclableItemName) { this.recyclableItemName = recyclableItemName; }

    public double getRatePerKg() { return ratePerKg; }
    public void setRatePerKg(double ratePerKg) { this.ratePerKg = ratePerKg; }
}