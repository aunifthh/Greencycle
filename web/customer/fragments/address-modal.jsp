<%@ page contentType="text/html" pageEncoding="UTF-8"%>

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