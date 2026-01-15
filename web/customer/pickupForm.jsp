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

                             <jsp:include page="../navbar/usernavbar.jsp" />
                             <jsp:include page="../sidebar/usersidebar.jsp" />

                        <div class="content-wrapper">
                        <section class="content-header">
                            <div class="container-fluid d-flex justify-content-between align-items-center">
                            <h3 class="mb-2">Pickup Request / Add Request</h3>
                            <a href="pickups.php" class="btn btn-secondary"><i class="fas fa-arrow-left"></i> Back</a>
                            </div>
                        </section>

                        <section class="content">
                            <div class="container-fluid">
                            <div class="card shadow-lg">
                            <div class="card-header bg-success text-white">
                            <h4 class="card-title mb-0"><i class="fas fa-recycle"></i> Create Pickup Request</h4>
                            </div>

                        <!-- FORM -->
                            <form method="post" action="${pageContext.request.contextPath}/pickups">
                            <div class="card-body">
                            <input type="hidden" id="totalPriceInput" name="totalPrice" value="0.00">

                        <!-- ADD ITEM -->
                        <div class="form-row align-items-end">
                                <div class="col-md-4">
                                    <label>Recyclable Category <span class="required">*</span></label>
                                    <select id="categorySelect" class="form-control">
                                        <option value="" disabled selected>-- Select Category --</option>
                                        <c:forEach var="cat" items="${categories}">
                                            <option value="${cat.categoryID}" data-rate="${cat.rate}">
                                                ${cat.categoryName} — RM${cat.rate} / KG
                                            </option>
                                        </c:forEach>

                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label>Quantity (KG) <span class="required">*</span></label>
                                    <input type="number" id="itemQty" class="form-control" min="0" step="0.01" placeholder="0.00">
                                </div>
                                <div class="col-md-2">
                                    <label>Subtotal (RM)</label>
                                    <input type="text" id="itemSubtotal" class="form-control" readonly value="0.00">
                                </div>
                                <div class="col-md-3">
                                    <button type="button" id="addItemBtn" class="btn btn-success btn-block">
                                    <i class="fas fa-plus"></i> Add Item
                                </button>
                            </div>
                        </div>

                        <!-- ITEMS TABLE -->
                        <div class="mt-4">
                            <table class="table table-bordered item-table">
                                <thead class="thead-light">
                                <tr>
                                <th>#</th><th>Category</th><th>Quantity (KG)</th><th>Subtotal (RM)</th><th>Action</th>
                                </tr>
                                </thead>
                                  <tbody id="itemsBody"></tbody>
                                <tfoot>
                                    <tr>
                                    <th colspan="3" class="text-right">Total Price (RM):</th>
                                    <th id="totalPrice">0.00</th><th></th>
                                    </tr>
                                </tfoot>
                            <small><strong>Please note: Estimated weight/price may differ from actual quotation. Weigh accurately for exact quote.</strong></small>
                            </table>
                        </div>
                        
                        <!-- PICKUP ADDRESS -->
                        <select id="pickupAddress" class="form-control" name="pickupAddress" required>
                            <option value="" disabled selected>-- Select Pickup Address --</option>
                            <c:forEach var="addr" items="${addresses}">
                                <option value="${addr.addressID}">
                                    ${addr.categoryOfAddress} — ${addr.addressLine1}, ${addr.city}, ${addr.state}
                                </option>
                            </c:forEach>
                        </select>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                <label for="pickupDate"><i class="fas fa-calendar-alt"></i> Pickup Date <span class="required">*</span></label>
                                <input type="text" id="pickupDate" class="form-control" placeholder="Select pickup date" readonly required name="pickupDate">
                                    <small class="form-text text-muted">
                                    Pickup requests start <strong>2 days from today</strong>. Monday – Friday only. Cancellation ≥ 2 days before pickup.
                                    </small>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="pickupTime"><i class="fas fa-clock"></i> Pickup Time <span class="required">*</span></label>
                                     <select id="pickupTime" class="form-control" required name="pickupTime">
                                            <option value="" disabled selected>-- Select Time --</option>
                                            <option value="09:00">09:00</option>
                                            <option value="11:00">11:00</option>
                                            <option value="13:00">13:00</option>
                                            <option value="15:00">15:00</option>
                                            <option value="17:00">17:00</option>
                                        </select>
                                    <small class="form-text text-muted">Each time slot can be booked only once.</small>
                                </div>
                            </div>
                        </div>

                        <div class="form-group mt-2">
                            <label>Remark</label>
                            <textarea id="remarks" class="form-control" placeholder="Optional" name="remarks"></textarea>
                        </div>

                    </div>

                        <div class="card-footer text-right">
                             <button type="submit" class="btn btn-success"><i class="fas fa-paper-plane"></i> Submit Request</button>
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
let total = 0;
let itemIndex = 0;

$('#itemQty, #categorySelect').on('input change', function () {
    let rate = $('#categorySelect option:selected').data('rate') || 0;
    let qty = parseFloat($('#itemQty').val()) || 0;

    if (qty < 3) { $('#itemSubtotal').val('0.00'); return; }

    $('#itemSubtotal').val((rate * qty).toFixed(2));
});

$('#addItemBtn').click(function () {
    let catName = $('#categorySelect option:selected').text();
    let cat = $('#categorySelect').val();
    let qty = parseFloat($('#itemQty').val()) || 0;
    let sub = parseFloat($('#itemSubtotal').val()) || 0;

    if (!cat || qty < 3) { alert('Select category & minimum 3 kg'); return; }

    $('#itemsBody').append(`
        <tr data-subtotal="${sub}">
            <td></td>
            <td>${catName}<input type="hidden" name="category[]" value="${cat}"></td>
            <td>${qty}<input type="hidden" name="quantity[]" value="${qty}"></td>
            <td>${sub.toFixed(2)}<input type="hidden" name="subtotal[]" value="${sub}"></td>
            <td><button type="button" class="btn btn-danger removeBtn">X</button></td>
        </tr>
    `);

    updateTotal();
    resetInputs();
});

function updateTotal() {
    let total = 0;
    $('#itemsBody tr').each(function () {
        total += parseFloat($(this).data('subtotal'));
    });
    $('#totalPrice').text(total.toFixed(2));
    $('#totalPriceInput').val(total.toFixed(2));
}

$(document).on('click', '.removeBtn', function () {
    $(this).closest('tr').remove();
    updateTotal();
});

flatpickr("#pickupDate", {
    minDate: new Date().fp_incr(2),
    dateFormat: "Y-m-d",
    disable: [
        function(date) { return date.getDay() === 0 || date.getDay() === 6; }
    ]
});


</script>


</body>
</html>
