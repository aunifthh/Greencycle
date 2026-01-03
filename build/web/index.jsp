<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Greencycle - Login</title>
    <!-- Use contextPath to ensure links work even if we move folders -->
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/truck.png">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Icons + Bootstrap -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        body.login-page { 
            background-color: #f8f9fa; display: flex; justify-content: center; align-items: center; min-height: 100vh; 
        }
        .login-box { 
            width: 360px; 
        }
        .login-logo { 
            text-align: center; margin-bottom: 1.5rem; 
        }
        .login-logo h3 { 
            font-weight: 600; color: #28a745; 
        }
        .card-wider { 
            border-radius: 10px; box-shadow: 0 0 20px rgba(0, 0, 0, 0.11); 
        }
        .recycle-icon { 
            font-size: 4rem; display: block; text-align: center; margin-bottom: 1rem; color: #28a745; 
        }
        .shield-icon { 
            font-size: 4rem; display: block; text-align: center; margin-bottom: 1rem; color: #0d6efd; 
        }
        button.user-btn { 
            background: #28a745; color: white; border: none; 
        }
        button.admin-btn { 
            background: #0d6efd; color: white; border: none; 
        }
    </style>
</head>
<body class="login-page">

    <div class="login-box">
        <div class="login-logo">
            <div class="d-flex justify-content-center align-items-center gap-2">
                <img src="${pageContext.request.contextPath}/images/truck.png" alt="Logo" width="40">
                <h3 class="mb-0">Greencycle</h3>
            </div>
            <small class="text-muted d-block mt-1">Community Recycling Collection System</small>
        </div>

        <%-- Display error message if login fails --%>
        <% if(request.getParameter("error") != null) { %>
            <div class="alert alert-danger text-center">Invalid Email or Password</div>
        <% } %>

        <div class="card card-wider">
            <div class="card-body login-card-body">
                <div class="accordion" id="loginAccordion">

                    <!-- USER LOGIN (CUSTOMER) -->
                    <div class="accordion-item">
                        <h2 class="accordion-header" id="userHeading">
                            <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#userLogin">
                                Customer Login
                            </button>
                        </h2>
                        <div id="userLogin" class="accordion-collapse collapse show" data-bs-parent="#loginAccordion">
                            <div class="accordion-body">
                                <i class="bi bi-recycle recycle-icon"></i>
                                <form action="LoginServlet" method="POST">
                                    <input type="hidden" name="userType" value="customer">
                                    <div class="input-group mb-3">
                                        <input type="email" name="email" class="form-control" placeholder="Email" required>
                                        <div class="input-group-text"><i class="bi bi-envelope"></i></div>
                                    </div>
                                    <div class="input-group mb-3">
                                        <input type="password" name="password" class="form-control" id="uPass" placeholder="Password" required>
                                        <div class="input-group-text"><i class="bi bi-eye-slash" onclick="toggle('uPass', this)" style="cursor:pointer;"></i></div>
                                    </div>
                                    <div class="text-end"><button type="submit" class="btn user-btn rounded-pill px-4 py-2">Login</button></div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- STAFF LOGIN -->
                    <div class="accordion-item">
                        <h2 class="accordion-header" id="adminHeading">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#adminLogin">
                                Staff Login
                            </button>
                        </h2>
                        <div id="adminLogin" class="accordion-collapse collapse" data-bs-parent="#loginAccordion">
                            <div class="accordion-body">
                                <i class="bi bi-shield-lock shield-icon"></i>
                                <form action="LoginServlet" method="POST">
                                    <input type="hidden" name="userType" value="staff">
                                    <div class="input-group mb-3">
                                        <input type="text" name="email" class="form-control" placeholder="Staff Email" required>
                                        <div class="input-group-text"><i class="bi bi-person-lock"></i></div>
                                    </div>
                                    <div class="input-group mb-3">
                                        <input type="password" name="password" class="form-control" id="sPass" placeholder="Password" required>
                                        <div class="input-group-text"><i class="bi bi-eye-slash" onclick="toggle('sPass', this)" style="cursor:pointer;"></i></div>
                                    </div>
                                    <div class="text-end"><button type="submit" class="btn admin-btn rounded-pill px-4 py-2">Login</button></div>
                                </form>
                            </div>
                        </div>
                    </div>

                </div> <!-- End accordion -->

                <div class="text-center mt-3">
                    <p>Don't have an account? <a href="signup.jsp">Sign Up</a></p>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function toggle(id, el) {
            const pw = document.getElementById(id);
            pw.type = pw.type === "password" ? "text" : "password";
            el.classList.toggle("bi-eye");
            el.classList.toggle("bi-eye-slash");
        }
    </script>
   <%-- SweetAlert2 Library --%>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const urlParams = new URLSearchParams(window.location.search);
        
        // Define shared configuration (Greencycle Green)
        const greenColor = '#28a745';

        // 1. Handle Login Errors
        if (urlParams.get('error') === '1') {
            Swal.fire({
                icon: 'error',
                title: 'Login Failed',
                text: 'Invalid email or password. Please try again.',
                confirmButtonColor: greenColor,
                timer: 3500 // Automatically closes after 3.5 seconds
            });
        }

        // 2. Handle Successful Registration
        if (urlParams.get('status') === 'registered') {
            Swal.fire({
                icon: 'success',
                title: 'Sign Up Successful!',
                text: 'Your account has been created. You can now log in.',
                confirmButtonColor: greenColor,
                timer: 4000
            });
        }
        
        // 3. Optional: Handle Logout (if you add this later)
        if (urlParams.get('status') === 'logout') {
            Swal.fire({
                icon: 'info',
                title: 'Logged Out',
                text: 'You have been successfully logged out.',
                confirmButtonColor: greenColor,
                timer: 3000
            });
        }
        
        // Cleanup: Remove the parameters from the URL without refreshing the page
        // This prevents the alert from popping up again if the user hits F5/Refresh
        if (window.history.replaceState) {
            const newUrl = window.location.pathname;
            window.history.replaceState({}, document.title, newUrl);
        }
    });
</script>
</body>
</html>