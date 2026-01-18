<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
    <html lang="en">
        <head>
            <meta charset="UTF-8">
                <title>Create Pickup Request | Greencycle</title>
                <link rel="icon" href="../images/truck.png">
                <link rel="stylesheet" href="../app/plugins/fontawesome-free/css/all.min.css">
                <link rel="stylesheet" href="../app/dist/css/adminlte.min.css">
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
                <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
                <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
                <style>
                .required { color:red; }
                .item-table th, .item-table td { vertical-align: middle; }
                #pickupDate[readonly] { background-color:#fff !important; cursor:pointer; }
                </style>
                </head>
                    <body class="hold-transition sidebar-mini layout-fixed">
                        <div class="wrapper">

            <jsp:include page="../navbar/customernavbar.jsp" />
            <jsp:include page="../sidebar/customersidebar.jsp" />

            <div class="content-wrapper">
                <section class="content-header">
                    <div class="container-fluid d-flex justify-content-between align-items-center">
                        <h3 class="mb-2">Pickup Request / Add Request</h3>
                        <a href="${pageContext.request.contextPath}/customer/pickups" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back
                        </a>
                    </div>
                </section>

                <section class="content">
                    <div class="container-fluid">
                        <div class="card shadow-lg">
                            <div class="card-header bg-success text-white">
                                <h4 class="card-title mb-0"><i class="fas fa-recycle"></i> Create Pickup Request</h4>
                            </div>

                            <!-- FORM -->
                            <form method="post" action="${pageContext.request.contextPath}/customer/pickups">
                                <div class="card-body">

                                    <!-- MATERIAL WEIGHTS -->
                                    <h5>Recyclable Items</h5>
                                    <p class="text-muted mb-2">
                                        Enter the estimated weight for each material. Rates are loaded from the current recyclable item table.
                                    </p>

                                    <c:set var="plasticRate" value="${rates['Plastic'] != null ? rates['Plastic'] : 0}" />
                                    <c:set var="paperRate" value="${rates['Paper'] != null ? rates['Paper'] : 0}" />
                                    <c:set var="metalRate" value="${rates['Metal'] != null ? rates['Metal'] : 0}" />

                                    <div class="row">
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label>Plastic (kg) <span class="required">*</span></label>
                                                <div class="input-group">
                                                    <input type="number" step="0.1" min="0" name="plasticWeight"
                                                           id="plasticWeight" class="form-control" value="0.0" required>
                                                    <div class="input-group-append">
                                                        <span class="input-group-text">
                                                            RM <span id="plasticRateSpan"><c:out value="${plasticRate}" /></span>/kg
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label>Paper (kg)</label>
                                                <div class="input-group">
                                                    <input type="number" step="0.1" min="0" name="paperWeight"
                                                           id="paperWeight" class="form-control" value="0.0">
                                                    <div class="input-group-append">
                                                        <span class="input-group-text">
                                                            RM <span id="paperRateSpan"><c:out value="${paperRate}" /></span>/kg
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label>Metal (kg)</label>
                                                <div class="input-group">
                                                    <input type="number" step="0.1" min="0" name="metalWeight"
                                                           id="metalWeight" class="form-control" value="0.0">
                                                    <div class="input-group-append">
                                                        <span class="input-group-text">
                                                            RM <span id="metalRateSpan"><c:out value="${metalRate}" /></span>/kg
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="alert alert-success">
                                        <strong>Estimated Total:</strong>
                                        RM <span id="estimatedTotal">0.00</span>
                                    </div>

                                    <!-- PICKUP ADDRESS -->
                                    <div class="form-group mt-3">
                                        <label for="addressID">Pickup Address <span class="required">*</span></label>
                                        <select id="addressID" class="form-control" name="addressID" required>
                                            <option value="" disabled selected>-- Select Pickup Address --</option>
                                            <c:forEach var="addr" items="${addresses}">
                                                <option value="${addr.addressID}">
                                                    ${addr.categoryOfAddress} — ${addr.addressLine1}, ${addr.city}, ${addr.state}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="pickupDate"><i class="fas fa-calendar-alt"></i> Pickup Date <span class="required">*</span></label>
                                                <input type="text" id="pickupDate" class="form-control"
                                                       placeholder="Select pickup date" readonly required name="pickupDate">
                                                <small class="form-text text-muted">
                                                    Pickup requests start <strong>2 days from today</strong>. Monday – Friday only.
                                                </small>
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="pickupTime"><i class="fas fa-clock"></i> Pickup Time <span class="required">*</span></label>
                                                <select id="pickupTime" class="form-control" required name="pickupTime">
                                                    <option value="" disabled selected>-- Select Time --</option>
                                                    <option value="09:00">09:00 AM</option>
                                                    <option value="11:00">11:00 AM</option>
                                                    <option value="13:00">13:00 PM</option>
                                                    <option value="15:00">15:00 PM</option>
                                                    <option value="17:00">17:00 PM</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-group mt-2">
                                        <label>Remark</label>
                                        <textarea id="remarks" class="form-control" placeholder="Optional" name="remarks"></textarea>
                                    </div>

                                </div>

                                <div class="card-footer text-right">
                                    <button type="submit" class="btn btn-success">
                                        <i class="fas fa-paper-plane"></i> Submit Request
                                    </button>
                                </div>
                            </form>

                        </div>
                    </div>
                </section>
            </div>

            <jsp:include page="/footer/footer.jsp" />

            <script src="../app/plugins/jquery/jquery.min.js"></script>
            <script src="../app/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

            <!-- ================= JS ================= -->
            <script>
                function recalcTotal() {
                    const plastic = parseFloat(document.getElementById('plasticWeight').value || '0');
                    const paper = parseFloat(document.getElementById('paperWeight').value || '0');
                    const metal = parseFloat(document.getElementById('metalWeight').value || '0');

                    const plasticRate = parseFloat(document.getElementById('plasticRateSpan').innerText || '0');
                    const paperRate = parseFloat(document.getElementById('paperRateSpan').innerText || '0');
                    const metalRate = parseFloat(document.getElementById('metalRateSpan').innerText || '0');

                    const total = (plastic * plasticRate) + (paper * paperRate) + (metal * metalRate);
                    document.getElementById('estimatedTotal').innerText = total.toFixed(2);
                }

                document.getElementById('plasticWeight').addEventListener('input', recalcTotal);
                document.getElementById('paperWeight').addEventListener('input', recalcTotal);
                document.getElementById('metalWeight').addEventListener('input', recalcTotal);

                flatpickr("#pickupDate", {
                    minDate: new Date().fp_incr(2),
                    dateFormat: "Y-m-d",
                    disable: [
                        function (date) { return date.getDay() === 0 || date.getDay() === 6; }
                    ]
                });
            </script>

        </div>
    </body>
</html>
