<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ page isELIgnored="true" %>

        <% String customerJson=(String) request.getAttribute("customerJson"); String addressesJson=(String)
            request.getAttribute("addressesJson"); if (customerJson==null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=1" ); return; } %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <title>Profile Management</title>
                <link rel="icon" type="image/png" href="<%= request.getContextPath()%>/images/truck.png">
                <link rel="stylesheet"
                    href="<%= request.getContextPath()%>/app/plugins/fontawesome-free/css/all.min.css">
                <link rel="stylesheet" href="<%= request.getContextPath()%>/app/dist/css/adminlte.min.css">
                <link rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.min.css">
                <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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

                    .badge-default {
                        background-color: #28a745;
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
                                        <!-- Profile Section -->
                                        <div class="card card-primary">
                                            <div class="card-header">
                                                <h3 class="card-title"><i class="fas fa-user-edit mr-1"></i> Edit
                                                    Profile</h3>
                                            </div>
                                            <div class="card-body">
                                                <div class="input-group mb-3">
                                                    <input type="text" id="nameInput" class="form-control"
                                                        placeholder="Full Name" required>
                                                    <div class="input-group-text"><i class="bi bi-person"></i></div>
                                                </div>
                                                <div class="input-group mb-3">
                                                    <input type="email" id="emailInput" class="form-control"
                                                        placeholder="Email" required>
                                                    <div class="input-group-text"><i class="bi bi-envelope"></i></div>
                                                </div>
                                                <div class="input-group mb-3">
                                                    <input type="tel" id="phoneInput" class="form-control"
                                                        placeholder="Phone Number" required>
                                                    <div class="input-group-text"><i class="bi bi-telephone"></i></div>
                                                </div>
                                                <div class="input-group mb-3">
                                                    <input type="password" id="passwordInput" class="form-control"
                                                        placeholder="New Password (optional)">
                                                    <div class="input-group-text">
                                                        <i class="bi bi-eye-slash" id="togglePassword"
                                                            style="cursor:pointer;"></i>
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
                                                <h3 class="card-title"><i class="fas fa-credit-card mr-1"></i> Bank
                                                    Account</h3>
                                            </div>
                                            <div class="card-body">
                                                <div class="input-group mb-3">
                                                    <input type="text" id="bankNameInput" class="form-control"
                                                        placeholder="Bank Name">
                                                    <div class="input-group-text"><i class="fas fa-university"></i>
                                                    </div>
                                                </div>
                                                <div class="input-group mb-3">
                                                    <input type="text" id="bankAccountInput" class="form-control"
                                                        placeholder="Account Number">
                                                    <div class="input-group-text"><i class="fas fa-sort-numeric-up"></i>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="card-footer">
                                                <button id="saveBankBtn" class="btn btn-primary">
                                                    <i class="fas fa-save"></i> Save Bank Info
                                                </button>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="card card-success">
                                            <div class="card-header">
                                                <h3 class="card-title"><i class="fas fa-map-marker-alt mr-1"></i> Saved
                                                    Addresses</h3>
                                            </div>
                                            <div class="card-body">
                                                <div class="mb-4">
                                                    <button id="openAddAddressBtn" class="btn btn-success btn-lg w-100">
                                                        <i class="fas fa-plus-circle mr-2"></i><strong>Add New Pickup
                                                            Address</strong>
                                                    </button>
                                                    <p class="text-muted text-sm mt-2">Save home, office, or other
                                                        locations for recycling pickups.</p>
                                                </div>
                                                <div id="addressesList"></div>
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
                                    <!-- Address Label (Dropdown-style text input) -->
                                    <div class="mb-3">
                                        <label>Address Label (e.g., Home, Office)</label>
                                        <input type="text" id="addressLabel" class="form-control" placeholder="Home"
                                            required>
                                    </div>

                                    <!-- Address Line 1 -->
                                    <div class="mb-3">
                                        <label>Address Line 1</label>
                                        <input type="text" id="addressLine1" class="form-control"
                                            placeholder="Street name and number" required>
                                    </div>

                                    <!-- Address Line 2 -->
                                    <div class="mb-3">
                                        <label>Address Line 2</label>
                                        <input type="text" id="addressLine2" class="form-control"
                                            placeholder="Unit, floor, building (optional)">
                                    </div>

                                    <!-- Poscode -->
                                    <div class="mb-3">
                                        <label>Poscode</label>
                                        <input type="text" id="poscode" class="form-control" placeholder="50000"
                                            required>
                                    </div>

                                    <!-- City -->
                                    <div class="mb-3">
                                        <label>City</label>
                                        <input type="text" id="city" class="form-control" placeholder="Kuala Lumpur"
                                            required>
                                    </div>

                                    <!-- State -->
                                    <div class="mb-3">
                                        <label>State</label>
                                        <input type="text" id="state" class="form-control" placeholder="Selangor"
                                            required>
                                    </div>

                                    <!-- Remarks -->
                                    <div class="mb-3">
                                        <label>Remarks (Optional)</label>
                                        <textarea id="remarks" class="form-control" rows="2"
                                            placeholder="E.g., Near blue gate, ring bell twice"></textarea>
                                    </div>

                                    <!-- Set as Default -->
                                    <div class="form-check">
                                        <input type="checkbox" id="addressDefault" class="form-check-input">
                                        <label class="form-check-label">Set as default pickup address</label>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                                    <button type="button" class="btn btn-success" id="saveAddressBtn">Save
                                        Address</button>
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
                    const customer = <%= customerJson%>;
                    let addresses = <%= addressesJson%>;
                    let editingId = null;

                    // Populate fields
                    document.getElementById('nameInput').value = customer.fullName || '';
                    document.getElementById('emailInput').value = customer.email || '';
                    document.getElementById('phoneInput').value = customer.phoneNo || '';
                    document.getElementById('bankNameInput').value = customer.bankName || '';
                    document.getElementById('bankAccountInput').value = customer.bankAccountNo || '';

                    function escapeHtml(text) {
                        return String(text)
                            .replace(/&/g, '&amp;')
                            .replace(/</g, '&lt;')
                            .replace(/>/g, '&gt;')
                            .replace(/"/g, '&quot;')
                            .replace(/'/g, '&#039;');
                    }

                    function renderAddresses() {
                        const container = document.getElementById('addressesList');
                        if (addresses.length === 0) {
                            container.innerHTML = '<div class="text-center text-muted py-3">No saved addresses yet.</div>';
                            return;
                        }

                        container.innerHTML = addresses.map(addr => {
                            // ✅ Use LET instead of CONST for reassignment
                            let fullAddr = [
                                addr.addressLine1 || '',
                                addr.addressLine2 || '',
                                addr.poscode || '',
                                addr.city || '',
                                addr.state || ''
                            ].filter(part => part.trim() !== '').join(', ');

                            // Safely append remarks
                            if (addr.remarks && addr.remarks.trim()) {
                                fullAddr += ` • ${addr.remarks}`;
                            }

                            return `
            <div class="address-card">
                <div class="d-flex justify-content-between align-items-start">
                    <div style="flex: 1; min-width: 0;">
                        <strong>${escapeHtml(addr.categoryOfAddress)}</strong><br>
                        <small class="text-muted">${escapeHtml(fullAddr)}</small>
                    </div>
                    <div class="ml-3 text-right" style="white-space: nowrap;">
                        <button class="btn btn-sm btn-warning mb-1" onclick="editAddress('${addr.addressID}')">Edit</button><br>
                        <button class="btn btn-sm btn-danger" onclick="deleteAddress('${addr.addressID}')">Delete</button>
                    </div>
                </div>
            </div>
            `;
                        }).join('');
                    }

                    // ===== PROFILE SAVE (REAL DB UPDATE) =====
                    document.getElementById('saveProfileBtn').addEventListener('click', function () {
                        const name = document.getElementById('nameInput').value.trim();
                        const email = document.getElementById('emailInput').value.trim();
                        const phone = document.getElementById('phoneInput').value.trim();
                        const password = document.getElementById('passwordInput').value.trim();

                        if (!name || !email || !phone) {
                            Swal.fire({ icon: 'warning', title: 'Missing Information', text: 'Please fill in all required fields.', timer: 2000, showConfirmButton: false });
                            return;
                        }

                        fetch('<%= request.getContextPath()%>/customer/profile', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: `action=updateProfile&fullName=${encodeURIComponent(name)}&email=${encodeURIComponent(email)}&phoneNo=${encodeURIComponent(phone)}${password ? '&password=' + encodeURIComponent(password) : ''}`
                        })
                            .then(response => {
                                if (response.ok) {
                                    Swal.fire({ icon: 'success', title: 'Profile Updated!', text: 'Your profile has been successfully updated.', timer: 1500, showConfirmButton: false });
                                } else {
                                    Swal.fire({ icon: 'error', title: 'Update Failed', text: 'Failed to update profile.', timer: 2000, showConfirmButton: false });
                                }
                            })
                            .catch(() => {
                                Swal.fire({ icon: 'error', title: 'Error', text: 'Network error.', timer: 2000, showConfirmButton: false });
                            });
                    });

                    // ===== BANK SAVE (REAL DB UPDATE) =====
                    document.getElementById('saveBankBtn').addEventListener('click', function () {
                        const bankName = document.getElementById('bankNameInput').value.trim();
                        const bankAccount = document.getElementById('bankAccountInput').value.trim();

                        if (!bankName || !bankAccount) {
                            Swal.fire({ icon: 'warning', title: 'Missing Info', text: 'Fill in bank name and account.', timer: 2000, showConfirmButton: false });
                            return;
                        }
                        if (!/^[0-9\s]+$/.test(bankAccount)) {
                            Swal.fire({ icon: 'warning', title: 'Invalid Account', text: 'Only digits and spaces allowed.', timer: 2000, showConfirmButton: false });
                            return;
                        }

                        fetch('<%= request.getContextPath()%>/customer/profile', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: `action=updateBank&bankName=${encodeURIComponent(bankName)}&bankAccountNo=${encodeURIComponent(bankAccount)}`
                        })
                            .then(response => {
                                if (response.ok) {
                                    Swal.fire({ icon: 'success', title: 'Bank Info Saved!', text: 'Your bank details have been updated.', timer: 1500, showConfirmButton: false });
                                } else {
                                    Swal.fire({ icon: 'error', title: 'Save Failed', text: 'Failed to save bank info.', timer: 2000, showConfirmButton: false });
                                }
                            })
                            .catch(() => {
                                Swal.fire({ icon: 'error', title: 'Error', text: 'Network error.', timer: 2000, showConfirmButton: false });
                            });
                    });

                    // ===== PASSWORD TOGGLE =====
                    document.getElementById('togglePassword').addEventListener('click', function () {
                        const pwd = document.getElementById('passwordInput');
                        const icon = this;
                        if (pwd.type === 'password') {
                            pwd.type = 'text';
                            icon.classList.replace('bi-eye-slash', 'bi-eye');
                        } else {
                            pwd.type = 'password';
                            icon.classList.replace('bi-eye', 'bi-eye-slash');
                        }
                    });

                    // ===== OPEN ADD ADDRESS MODAL =====
                    function openAddAddressModal() {
                        editingId = null;
                        document.getElementById('modalTitle').textContent = 'Add New Address';
                        document.getElementById('addressLabel').value = '';
                        document.getElementById('addressLine1').value = '';
                        document.getElementById('addressLine2').value = '';
                        document.getElementById('poscode').value = '';
                        document.getElementById('city').value = '';
                        document.getElementById('state').value = '';
                        document.getElementById('remarks').value = '';
                        document.getElementById('addressDefault').checked = false;
                        $('#addressModal').modal('show');
                    }

                    // ===== SAVE ADDRESS (REAL DB) =====
                    function saveAddress() {
                        const label = document.getElementById('addressLabel').value.trim();
                        const line1 = document.getElementById('addressLine1').value.trim();
                        const line2 = document.getElementById('addressLine2').value.trim();
                        const poscode = document.getElementById('poscode').value.trim();
                        const city = document.getElementById('city').value.trim();
                        const state = document.getElementById('state').value.trim();
                        const remarks = document.getElementById('remarks').value.trim();

                        if (!label || !line1 || !poscode || !city || !state) {
                            Swal.fire({
                                icon: 'warning',
                                title: 'Incomplete Form',
                                text: 'Please fill in all required fields.',
                                timer: 2000,
                                showConfirmButton: false
                            });
                            return;
                        }

                        const data = {
                            action: 'saveAddress',
                            label: label,
                            addressLine1: line1,
                            addressLine2: line2,
                            poscode: poscode,
                            city: city,
                            state: state,
                            remarks: remarks
                        };

                        if (editingId) {
                            data.addressID = editingId;
                        }

                        const body = Object.keys(data)
                            .map(key => `${encodeURIComponent(key)}=${encodeURIComponent(data[key])}`)
                            .join('&');

                        fetch('<%= request.getContextPath()%>/customer/profile', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: body
                        })
                            .then(response => {
                                if (response.ok) {
                                    window.location.reload();
                                } else {
                                    Swal.fire({
                                        icon: 'error',
                                        title: 'Save Failed',
                                        text: 'Failed to save address.',
                                        timer: 2000,
                                        showConfirmButton: false
                                    });
                                }
                            })
                            .catch(() => {
                                Swal.fire({
                                    icon: 'error',
                                    title: 'Error',
                                    text: 'Network error.',
                                    timer: 2000,
                                    showConfirmButton: false
                                });
                            });
                    }

                    // ===== EDIT ADDRESS =====
                    function editAddress(id) {
                        const addr = addresses.find(a => a.addressID === id);
                        if (!addr)
                            return;
                        editingId = id;
                        document.getElementById('modalTitle').textContent = 'Edit Address';
                        document.getElementById('addressLabel').value = addr.categoryOfAddress || '';
                        document.getElementById('addressLine1').value = addr.addressLine1 || '';
                        document.getElementById('addressLine2').value = addr.addressLine2 || '';
                        document.getElementById('poscode').value = addr.poscode || '';
                        document.getElementById('city').value = addr.city || '';
                        document.getElementById('state').value = addr.state || '';
                        document.getElementById('remarks').value = addr.remarks || '';
                        document.getElementById('addressDefault').checked = addr.isDefault || false;
                        $('#addressModal').modal('show');
                    }

                    // ===== DELETE ADDRESS (REAL DB) =====
                    function deleteAddress(id) {
                        Swal.fire({
                            title: 'Delete Address?',
                            text: "This action cannot be undone.",
                            icon: 'warning',
                            showCancelButton: true,
                            confirmButtonColor: '#d33',
                            confirmButtonText: 'Yes, delete it!'
                        }).then((result) => {
                            if (result.isConfirmed) {
                                fetch('<%= request.getContextPath()%>/customer/profile', {
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                    body: `action=deleteAddress&addressID=${encodeURIComponent(id)}`
                                })
                                    .then(response => {
                                        if (response.ok) {
                                            window.location.reload();
                                        } else {
                                            Swal.fire({ icon: 'error', title: 'Delete Failed', text: 'Failed to delete address.', timer: 2000, showConfirmButton: false });
                                        }
                                    })
                                    .catch(() => {
                                        Swal.fire({ icon: 'error', title: 'Error', text: 'Network error.', timer: 2000, showConfirmButton: false });
                                    });
                            }
                        });
                    }

                    // ===== ADDRESS EVENT LISTENERS =====
                    document.getElementById('openAddAddressBtn').addEventListener('click', openAddAddressModal);
                    document.getElementById('saveAddressBtn').addEventListener('click', saveAddress);

                    // Initial render
                    renderAddresses();
                </script>
            </body>

            </html>