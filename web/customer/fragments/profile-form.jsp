<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Profile Section -->
<div class="card card-primary">
    <div class="card-header">
        <h3 class="card-title"><i class="fas fa-user-edit mr-1"></i> Edit Profile</h3>
    </div>
    <div class="card-body">
        <div class="input-group mb-3">
            <input type="text" id="nameInput" class="form-control" 
                   value="${customer.fullName}" 
                   placeholder="Full Name" required>
            <div class="input-group-text"><i class="bi bi-person"></i></div>
        </div>
        <div class="input-group mb-3">
            <input type="email" id="emailInput" class="form-control" 
                   value="${customer.email}" 
                   placeholder="Email" required>
            <div class="input-group-text"><i class="bi bi-envelope"></i></div>
        </div>
        <div class="input-group mb-3">
            <input type="tel" id="phoneInput" class="form-control" 
                   value="${customer.phoneNo}" 
                   placeholder="Phone Number" required>
            <div class="input-group-text"><i class="bi bi-telephone"></i></div>
        </div>
        <div class="input-group mb-3">
            <input type="password" id="passwordInput" class="form-control" placeholder="New Password (optional)">
            <div class="input-group-text">
                <i class="bi bi-eye-slash" id="togglePassword" style="cursor:pointer;"></i>
            </div>
        </div>
    </div>
    <div class="card-footer">
        <button id="saveProfileBtn" class="btn btn-primary">
            <i class="fas fa-save"></i> Save Profile
        </button>
    </div>
</div>

<!-- Bank Account -->
<div class="card card-primary mt-4">
    <div class="card-header">
        <h3 class="card-title"><i class="fas fa-credit-card mr-1"></i> Bank Account</h3>
    </div>
    <div class="card-body">
        <div class="input-group mb-3">
            <input type="text" id="bankNameInput" class="form-control" 
                   value="${customer.bankName}" 
                   placeholder="Bank Name">
            <div class="input-group-text"><i class="fas fa-university"></i></div>
        </div>
        <div class="input-group mb-3">
            <input type="text" id="bankAccountInput" class="form-control" 
                   value="${customer.bankAccountNo}" 
                   placeholder="Account Number">
            <div class="input-group-text"><i class="fas fa-sort-numeric-up"></i></div>
        </div>
    </div>
    <div class="card-footer">
        <button id="saveBankBtn" class="btn btn-primary">
            <i class="fas fa-save"></i> Save Bank Info
        </button>
    </div>
</div>