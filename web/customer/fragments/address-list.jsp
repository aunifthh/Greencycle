<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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

        <!-- ADDRESS LIST -->
        <div id="addressesList">
            <c:choose>
                <c:when test="${empty addresses}">
                    <div class="text-center text-muted py-3">No saved addresses yet.</div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${addresses}" var="addr">
                        <c:set var="isDefault" value="${addr.addressID == sessionScope.defaultAddressID}" />
                        
                        <c:set var="fullAddr" value="${addr.addressLine1}" />
                        <c:if test="${not empty addr.addressLine2}">
                            <c:set var="fullAddr" value="${fullAddr}, ${addr.addressLine2}" />
                        </c:if>
                        <c:if test="${not empty addr.poscode}">
                            <c:set var="fullAddr" value="${fullAddr}, ${addr.poscode}" />
                        </c:if>
                        <c:if test="${not empty addr.city}">
                            <c:set var="fullAddr" value="${fullAddr}, ${addr.city}" />
                        </c:if>
                        <c:if test="${not empty addr.state}">
                            <c:set var="fullAddr" value="${fullAddr}, ${addr.state}" />
                        </c:if>
                        <c:if test="${not empty addr.remarks}">
                            <c:set var="fullAddr" value="${fullAddr} • ${addr.remarks}" />
                        </c:if>

                        <div class="address-card ${isDefault ? 'default' : ''}">
                            <div class="d-flex justify-content-between align-items-start">
                                <div style="flex: 1; min-width: 0;">
                                    <strong>${addr.categoryOfAddress}</strong><br>
                                    <small class="text-muted">${fullAddr}</small>
                                </div>
                                <div class="ml-3 text-right" style="white-space: nowrap;">
                                    <c:if test="${not isDefault}">
                                        <button class="btn btn-sm btn-outline-success mb-1" onclick="setDefault('${addr.addressID}')">
                                            Set Default
                                        </button><br>
                                    </c:if>
                                    <c:if test="${isDefault}">
                                        <span class="badge badge-success">Default</span><br>
                                    </c:if>
                                    <button class="btn btn-sm btn-warning mb-1 edit-btn"
                                            data-id="${addr.addressID}"
                                            data-label="${addr.categoryOfAddress}"
                                            data-line1="${addr.addressLine1}"
                                            data-line2="${addr.addressLine2}"
                                            data-poscode="${addr.poscode}"
                                            data-city="${addr.city}"
                                            data-state="${addr.state}"
                                            data-remarks="${addr.remarks}"
                                            data-default="${isDefault}">
                                        Edit
                                    </button><br>
                                    <button class="btn btn-sm btn-danger" onclick="deleteAddress('${addr.addressID}')">Delete</button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>