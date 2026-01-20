<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@page import="Greencycle.model.StaffBean" %>
        <% String role=(String) session.getAttribute("role"); if (role==null || (!role.equals("staff") &&
            !role.equals("admin"))) { response.sendRedirect("../index.jsp"); return; } StaffBean staff=(StaffBean)
            request.getAttribute("staff"); if (staff==null) { response.sendRedirect("../index.jsp"); return; } %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <title>My Profile | Greencycle</title>
                <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/truck.png">
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/app/plugins/fontawesome-free/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/app/dist/css/adminlte.min.css">
            </head>

            <body class="hold-transition sidebar-mini">
                <div class="wrapper">

                    <jsp:include page="/navbar/staffnavbar.jsp" />
                    <jsp:include page="/sidebar/staffsidebar.jsp" />

                    <div class="content-wrapper">
                        <section class="content-header">
                            <div class="container-fluid">
                                <h1>My Profile</h1>
                            </div>
                        </section>

                        <section class="content">
                            <div class="container-fluid">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="card card-primary">
                                            <div class="card-header">
                                                <h3 class="card-title">Personal Information</h3>
                                            </div>
                                            <form action="${pageContext.request.contextPath}/StaffProfileServlet"
                                                method="post">
                                                <div class="card-body">
                                                    <div class="form-group">
                                                        <label>Staff ID</label>
                                                        <input type="text" class="form-control"
                                                            value="<%= staff.getStaffID() %>" readonly>
                                                    </div>
                                                    <div class="form-group">
                                                        <label>Full Name</label>
                                                        <input type="text" name="name" class="form-control"
                                                            value="<%= staff.getStaffName() %>" required>
                                                    </div>
                                                    <div class="form-group">
                                                        <label>Email</label>
                                                        <input type="email" name="email" class="form-control"
                                                            value="<%= staff.getStaffEmail() %>" required>
                                                    </div>
                                                    <div class="form-group">
                                                        <label>Phone Number</label>
                                                        <input type="text" name="phone" class="form-control"
                                                            value="<%= staff.getStaffPhoneNo() != null ? staff.getStaffPhoneNo() : "" %>">
                                                    </div>
                                                    <div class="form-group">
                                                        <label>Role</label>
                                                        <input type="text" class="form-control"
                                                            value="<%= staff.getRole() %>" readonly>
                                                    </div>
                                                </div>
                                                <div class="card-footer">
                                                    <button type="submit" class="btn btn-primary">Save Changes</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="card card-warning">
                                            <div class="card-header">
                                                <h3 class="card-title">Change Password</h3>
                                            </div>
                                            <form action="${pageContext.request.contextPath}/StaffProfileServlet"
                                                method="post">
                                                <input type="hidden" name="name" value="<%= staff.getStaffName() %>">
                                                <input type="hidden" name="email" value="<%= staff.getStaffEmail() %>">
                                                <input type="hidden" name="phone"
                                                    value="<%= staff.getStaffPhoneNo() != null ? staff.getStaffPhoneNo() : "" %>">

                                                <div class="card-body">
                                                    <div class="form-group">
                                                        <label>Current Password</label>
                                                        <input type="password" name="currentPassword"
                                                            class="form-control">
                                                    </div>
                                                    <div class="form-group">
                                                        <label>New Password</label>
                                                        <input type="password" name="newPassword" class="form-control">
                                                    </div>
                                                    <div class="form-group">
                                                        <label>Confirm New Password</label>
                                                        <input type="password" name="confirmPassword"
                                                            class="form-control">
                                                    </div>
                                                </div>
                                                <div class="card-footer">
                                                    <button type="submit" class="btn btn-warning">Update
                                                        Password</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </section>
                    </div>

                    <jsp:include page="/footer/footer.jsp" />
                </div>

                <script src="${pageContext.request.contextPath}/app/plugins/jquery/jquery.min.js"></script>
                <script
                    src="${pageContext.request.contextPath}/app/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
                <script src="${pageContext.request.contextPath}/app/dist/js/adminlte.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

                <script>
                    const params = new URLSearchParams(window.location.search);
                    if (params.has('status')) {
                        const status = params.get('status');
                        const msg = params.get('msg');

                        if (status === 'updated') {
                            Swal.fire({ icon: 'success', title: 'Success!', text: 'Profile updated successfully', timer: 2000 });
                        } else if (status === 'password_mismatch') {
                            Swal.fire({ icon: 'error', title: 'Error', text: 'New passwords do not match' });
                        } else if (status === 'error') {
                            // Decode URL encoded message or show default
                            const errorText = msg ? decodeURIComponent(msg.replace(/\+/g, ' ')) : 'Failed to update profile. Please check that input data is valid.';
                            Swal.fire({ icon: 'error', title: 'Update Failed', text: errorText });
                        }
                    }
                </script>
            </body>

            </html>