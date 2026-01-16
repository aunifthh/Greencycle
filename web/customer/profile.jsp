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

                            <!-- LEFT COLUMN: Profile & Bank -->
                            <div class="col-md-6">
                                <!-- Profile Section -->
                                <div class="card card-primary">
                                    <div class="card-header">
                                        <h3 class="card-title"><i class="fas fa-user-edit mr-1"></i> Edit Profile</h3>
                                    </div>
                                    <div class="card-body">
                                        <%
                                            // Get full customer data from request attribute (loaded from DB by servlet)
                                            CustomerBean fullCustomer = (CustomerBean) request.getAttribute("customer");
                                            if (fullCustomer == null) {
                                                fullCustomer = customer; // fallback to session data
                                            }
                                        %>
                                        <div class="input-group mb-3">
                                            <input type="text" id="nameInput" class="form-control" 
                                                   value="<%= fullCustomer.getFullName() != null ? fullCustomer.getFullName() : ""%>" 
                                                   placeholder="Full Name" required>
                                            <div class="input-group-text"><i class="bi bi-person"></i></div>
                                        </div>
                                        <div class="input-group mb-3">
                                            <input type="email" id="emailInput" class="form-control" 
                                                   value="<%= fullCustomer.getEmail() != null ? fullCustomer.getEmail() : ""%>" 
                                                   placeholder="Email" required>
                                            <div class="input-group-text"><i class="bi bi-envelope"></i></div>
                                        </div>
                                        <div class="input-group mb-3">
                                            <input type="tel" id="phoneInput" class="form-control" 
                                                   value="<%= fullCustomer.getPhoneNo() != null ? fullCustomer.getPhoneNo() : ""%>" 
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
                                                   value="<%= fullCustomer.getBankName() != null ? fullCustomer.getBankName() : ""%>" 
                                                   placeholder="Bank Name">
                                            <div class="input-group-text"><i class="fas fa-university"></i></div>
                                        </div>
                                        <div class="input-group mb-3">
                                            <input type="text" id="bankAccountInput" class="form-control" 
                                                   value="<%= fullCustomer.getBankAccountNo() != null ? fullCustomer.getBankAccountNo() : ""%>" 
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
                            </div>

                            <!-- RIGHT COLUMN: Addresses -->
                            <div class="col-md-6">
                                <div class="card card-success">
                                    <div class="card-header">
                                        <h3 class="card-title"><i class="fas fa-map-marker-alt mr-1"></i> Saved Addresses</h3>
                                    </div>
                                    <div class="card-body">
                                        <div class="mb-4">
                                            <button id="openAddAddressBtn" class="btn btn-success btn-lg w-100">
                                                <i class="fas fa-plus-circle mr-2"></i><strong>Add New Pickup Address</strong>
                                            </button>
                                            <p class="text-muted text-sm mt-2">Save home, office, or other locations for recycling pickups.</p>
                                        </div>

                                        <!-- ADDRESS LIST (Server-rendered) -->
                                        <div id="addressesList">
                                            <%
                                                @SuppressWarnings("unchecked")
                                                List<AddressBean> addresses = (List<AddressBean>) request.getAttribute("addresses");
                                                Integer defaultAddressID = null;
                                                Object defaultAttr = session.getAttribute("defaultAddressID");
                                                if (defaultAttr instanceof Integer) {
                                                    defaultAddressID = (Integer) defaultAttr;
                                                }

                                                if (addresses == null || addresses.isEmpty()) {
                                            %>
                                            <div class="text-center text-muted py-3">No saved addresses yet.</div>
                                            <%
                                            } else {
                                                for (AddressBean addr : addresses) {
                                                    boolean isDefault = defaultAddressID != null && defaultAddressID.equals(addr.getAddressID());
                                                    String fullAddr = String.join(", ",
                                                            addr.getAddressLine1() != null ? addr.getAddressLine1() : "",
                                                            addr.getAddressLine2() != null ? addr.getAddressLine2() : "",
                                                            addr.getPoscode() != null ? addr.getPoscode() : "",
                                                            addr.getCity() != null ? addr.getCity() : "",
                                                            addr.getState() != null ? addr.getState() : ""
                                                    ).replaceAll(", ,", ",").replaceAll("^,|,$", "");

                                                    if (addr.getRemarks() != null && !addr.getRemarks().trim().isEmpty()) {
                                                        fullAddr += " • " + addr.getRemarks();
                                                    }
                                            %>
                                            <div class="address-card <%= isDefault ? "default" : ""%>">
                                                <div class="d-flex justify-content-between align-items-start">
                                                    <div style="flex: 1; min-width: 0;">
                                                        <strong><%= addr.getCategoryOfAddress()%></strong><br>
                                                        <small class="text-muted"><%= fullAddr%></small>
                                                    </div>
                                                    <div class="ml-3 text-right" style="white-space: nowrap;">
                                                        <% if (!isDefault) {%>
                                                        <button class="btn btn-sm btn-outline-success mb-1" onclick="setDefault('<%= addr.getAddressID()%>')">
                                                            Set Default
                                                        </button><br>
                                                        <% } else { %>
                                                        <span class="badge badge-success">Default</span><br>
                                                        <% }%>
                                                        <button class="btn btn-sm btn-warning mb-1 edit-btn"
                                                                data-id="<%= addr.getAddressID()%>"
                                                                data-label="<%= addr.getCategoryOfAddress()%>"
                                                                data-line1="<%= addr.getAddressLine1()%>"
                                                                data-line2="<%= addr.getAddressLine2()%>"
                                                                data-poscode="<%= addr.getPoscode()%>"
                                                                data-city="<%= addr.getCity()%>"
                                                                data-state="<%= addr.getState()%>"
                                                                data-remarks="<%= addr.getRemarks()%>"
                                                                data-default="<%= isDefault%>">
                                                            Edit
                                                        </button><br>
                                                        <button class="btn btn-sm btn-danger" onclick="deleteAddress('<%= addr.getAddressID()%>')">Delete</button>
                                                    </div>
                                                </div>
                                            </div>
                                            <%
                                                    }
                                                }
                                            %>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </section>
            </div>

            <!-- Add/Edit Address Modal -->
            <div class="modal fade" id="addressModal" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="modalTitle">Add New Address</h5>
                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label>Address Label</label>
                                <input type="text" id="addressLabel" class="form-control" placeholder="Home" required>
                            </div>
                            <div class="mb-3">
                                <label>Address Line 1</label>
                                <input type="text" id="addressLine1" class="form-control" placeholder="Street name and number" required>
                            </div>
                            <div class="mb-3">
                                <label>Address Line 2</label>
                                <input type="text" id="addressLine2" class="form-control" placeholder="Unit, floor, building (optional)">
                            </div>
                            <div class="mb-3">
                                <label>Poscode</label>
                                <input type="text" id="poscode" class="form-control" placeholder="50000" required>
                            </div>
                            <div class="mb-3">
                                <label>City</label>
                                <input type="text" id="city" class="form-control" placeholder="Kuala Lumpur" required>
                            </div>
                            <div class="mb-3">
                                <label>State</label>
                                <input type="text" id="state" class="form-control" placeholder="Selangor" required>
                            </div>
                            <div class="mb-3">
                                <label>Remarks (Optional)</label>
                                <textarea id="remarks" class="form-control" rows="2" placeholder="E.g., Near blue gate"></textarea>
                            </div>
                            <div class="form-check">
                                <input type="checkbox" id="addressDefault" class="form-check-input">
                                <label class="form-check-label">Set as default pickup address</label>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                            <button type="button" class="btn btn-success" id="saveAddressBtn">Save Address</button>
                        </div>
                    </div>
                </div>
            </div>

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
            if (result.isConfirmed) callback();
        });
    };

    const post = (action, data) => {
        const body = new URLSearchParams({ action, ...data });
        return fetch('<%= request.getContextPath()%>/customer/profile', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
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

            post('updateProfile', { fullName: name, email, phoneNo: phone, ...(password ? {password} : {}) })
                .then(r => {
                    if (r.ok) showAlert('success', 'Profile Updated!', 'Your profile has been successfully updated.');
                    else showAlert('error', 'Update Failed', 'Failed to update profile.');
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

            post('updateBank', { bankName, bankAccountNo: bankAccount })
                .then(r => {
                    if (r.ok) showAlert('success', 'Bank Info Saved!', 'Your bank details have been updated.');
                    else showAlert('error', 'Update Failed', 'Failed to save bank info.');
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

            if (editingId) data.addressID = editingId;

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
    window.setDefault = function(addressID) {
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
    window.deleteAddress = function(addressID) {
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