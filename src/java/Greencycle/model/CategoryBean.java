/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Greencycle.model;

/**
 *
 * @author arnie
 */
public class CategoryBean {
    private int categoryID;
    private String categoryName;
    private double rate;

    public int getCategoryID() { return categoryID; }
    public void setCategoryID(int categoryID) { this.categoryID = categoryID; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public double getRate() { return rate; }
    public void setRate(double rate) { this.rate = rate; }
}
