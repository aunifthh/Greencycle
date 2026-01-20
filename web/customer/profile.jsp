<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="Greencycle.model.CustomerBean, Greencycle.model.AddressBean, java.util.List" %>

<%
    // Retrieve session data
    CustomerBean customer = (CustomerBean) session.getAttribute("user");
    String role = (String) session.getAttribute("role");

    // Redirect if not logged in as customer
    if (customer == null || !"customer".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp?error=1");
        return;
    }

    // Set current page for sidebar highlighting
    request.setAttribute("currentPage", "profile");
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Profile Management</title>
        <link rel="icon" type="image/png" href="<%= request.getContextPath()%>/images/truck.png">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/app/plugins/fontawesome-free/css/all.min.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/app/dist/css/adminlte.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.min.css  ">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11  "></script>
        <style>
            .address-card {
                border-left: 4px solid #007bff;
                padding: 14px;
                border-radius: 6px;
                margin-bottom: 16px;
                background-color: #fafafa;
            }
            .address-card.default {
                border-left-color: #28a745;
                background-color: #f0f9f2;
            }
        </style>
    </head>
    <body class="hold-transition sidebar-mini layout-fixed">
        <div class="wrapper">

            <jsp:include page="/navbar/customernavbar.jsp" />
            <jsp:include page="/sidebar/customersidebar.jsp" />

            <div class="content-wrapper">
                <section class="content-header">
                    <div class="container-fluid">
                        <h1>Profile Management</h1>
                    </div>
                </section>

                <section class="content">
                    <div class="container-fluid">
                        <div class="row">
                            <div class="col-md-6">
                                <jsp:include page="fragments/profile-form.jsp" />
                            </div>
                            <div class="col-md-6">
                                <jsp:include page="fragments/address-list.jsp" />
                            </div>
                        </div>
                    </div>
                </section>
            </div>

            <jsp:include page="fragments/address-modal.jsp" />

            <jsp:include page="/footer/footer.jsp" />
        </div>

        <script src="<%= request.getContextPath()%>/app/plugins/jquery/jquery.min.js"></script>
        <script src="<%= request.getContextPath()%>/app/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
        <script src="<%= request.getContextPath()%>/app/dist/js/adminlte.min.js"></script>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                let editingId = null;

                // ===== ALERTS =====
                const showAlert = (icon, title, text, timer = 2000) => {
                    Swal.fire({icon, title, text, timer, showConfirmButton: false});
                };

                const confirmAction = (title, text, callback) => {
                    Swal.fire({
                        title,
                        text,
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#d33',
                        confirmButtonText: 'Yes'
                    }).then(result => {
                        if (result.isConfirmed)
                            callback();
                    });
                };

                const post = (action, data) => {
                    const body = new URLSearchParams({action, ...data});
                    return fetch('<%= request.getContextPath()%>/customer/profile', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                        body: body
                    });
                };

                // ===== PROFILE SAVE =====
                const saveProfileBtn = document.getElementById('saveProfileBtn');
                if (saveProfileBtn) {
                    saveProfileBtn.addEventListener('click', () => {
                        const name = document.getElementById('nameInput').value.trim();
                        const email = document.getElementById('emailInput').value.trim();
                        const phone = document.getElementById('phoneInput').value.trim();
                        const password = document.getElementById('passwordInput').value.trim();

                        if (!name || !email || !phone) {
                            showAlert('warning', 'Missing Information', 'Please fill in all required fields.');
                            return;
                        }

                        post('updateProfile', {fullName: name, email, phoneNo: phone, ...(password ? {password} : {})})
                                .then(r => {
                                    if (r.ok)
                                        showAlert('success', 'Profile Updated!', 'Your profile has been successfully updated.');
                                    else
                                        showAlert('error', 'Update Failed', 'Failed to update profile.');
                                });
                    });
                }

                // ===== BANK SAVE =====
                const saveBankBtn = document.getElementById('saveBankBtn');
                if (saveBankBtn) {
                    saveBankBtn.addEventListener('click', () => {
                        const bankName = document.getElementById('bankNameInput').value.trim();
                        const bankAccount = document.getElementById('bankAccountInput').value.trim();

                        if (!bankName || !bankAccount) {
                            showAlert('warning', 'Missing Info', 'Please fill in bank name and account number.');
                            return;
                        }

                        if (!/^[0-9\s]+$/.test(bankAccount)) {
                            showAlert('warning', 'Invalid Account', 'Only digits and spaces allowed.');
                            return;
                        }

                        post('updateBank', {bankName, bankAccountNo: bankAccount})
                                .then(r => {
                                    if (r.ok)
                                        showAlert('success', 'Bank Info Saved!', 'Your bank details have been updated.');
                                    else
                                        showAlert('error', 'Update Failed', 'Failed to save bank info.');
                                });
                    });
                }

                // ===== PASSWORD TOGGLE =====
                const togglePassword = document.getElementById('togglePassword');
                if (togglePassword) {
                    togglePassword.addEventListener('click', function () {
                        const pwd = document.getElementById('passwordInput');
                        if (pwd.type === 'password') {
                            pwd.type = 'text';
                            this.classList.replace('bi-eye-slash', 'bi-eye');
                        } else {
                            pwd.type = 'password';
                            this.classList.replace('bi-eye', 'bi-eye-slash');
                        }
                    });
                }

                // ===== ADDRESS FUNCTIONS =====
                const resetAddressForm = () => {
                    ['addressLabel', 'addressLine1', 'addressLine2', 'poscode', 'city', 'state', 'remarks']
                            .forEach(id => document.getElementById(id).value = '');
                    document.getElementById('addressDefault').checked = false;
                };

                const openAddressModal = (isEdit = false, addressData = null) => {
                    const modalTitle = document.getElementById('modalTitle');
                    if (isEdit && addressData) {
                        modalTitle.textContent = 'Edit Address';
                        editingId = addressData.id;
                        document.getElementById('addressLabel').value = addressData.label || '';
                        document.getElementById('addressLine1').value = addressData.line1 || '';
                        document.getElementById('addressLine2').value = addressData.line2 || '';
                        document.getElementById('poscode').value = addressData.poscode || '';
                        document.getElementById('city').value = addressData.city || '';
                        document.getElementById('state').value = addressData.state || '';
                        document.getElementById('remarks').value = addressData.remarks || '';
                        document.getElementById('addressDefault').checked = addressData.isDefault || false;
                    } else {
                        modalTitle.textContent = 'Add New Address';
                        editingId = null;
                        resetAddressForm();
                    }
                    $('#addressModal').modal('show');
                };

                const saveAddressBtn = document.getElementById('saveAddressBtn');
                if (saveAddressBtn) {
                    saveAddressBtn.addEventListener('click', () => {
                        const label = document.getElementById('addressLabel').value.trim();
                        const line1 = document.getElementById('addressLine1').value.trim();
                        const poscode = document.getElementById('poscode').value.trim();
                        const city = document.getElementById('city').value.trim();
                        const state = document.getElementById('state').value.trim();

                        if (!label || !line1 || !poscode || !city || !state) {
                            showAlert('warning', 'Incomplete Form', 'Please fill in all required fields.');
                            return;
                        }

                        const data = {
                            label,
                            addressLine1: line1,
                            addressLine2: document.getElementById('addressLine2').value.trim(),
                            poscode,
                            city,
                            state,
                            remarks: document.getElementById('remarks').value.trim(),
                            isDefault: document.getElementById('addressDefault').checked ? 'on' : ''
                        };

                        if (editingId)
                            data.addressID = editingId;

                        post('saveAddress', data).then(r => {
                            if (r.ok) {
                                $('#addressModal').modal('hide');
                                showAlert('success', 'Address Saved!', 'The address has been successfully saved.');
                                setTimeout(() => window.location.reload(), 1000);
                            } else {
                                showAlert('error', 'Save Failed', 'Failed to save address.');
                            }
                        });
                    });
                }

                // ===== SET DEFAULT ADDRESS =====
                window.setDefault = function (addressID) {
                    post('setDefault', {addressID}).then(r => {
                        if (r.ok) {
                            showAlert('success', 'Default Set', 'This address is now the default.');
                            setTimeout(() => window.location.reload(), 1000);
                        } else {
                            showAlert('error', 'Failed', 'Cannot set default address.');
                        }
                    });
                };

                // ===== DELETE ADDRESS =====
                window.deleteAddress = function (addressID) {
                    confirmAction('Delete Address?', "This action cannot be undone.", () => {
                        post('deleteAddress', {addressID}).then(r => {
                            if (r.ok) {
                                showAlert('success', 'Deleted', 'Address has been deleted.');
                                setTimeout(() => window.location.reload(), 1000);
                            } else {
                                showAlert('error', 'Failed', 'Failed to delete address.');
                            }
                        });
                    });
                };

                // ===== OPEN ADD ADDRESS MODAL =====
                const openAddAddressBtn = document.getElementById('openAddAddressBtn');
                if (openAddAddressBtn) {
                    openAddAddressBtn.addEventListener('click', () => openAddressModal(false));
                }
            });
        </script>

    </body>
</html>