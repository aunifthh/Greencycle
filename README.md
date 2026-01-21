# Greencycle: Community Recycling Collection System ♻️

**Greencycle** is a professional web-based recycling management platform designed to promote sustainability. It connects households with recycling collectors through a centralized digital system, facilitating the collection of Paper, Metal, and Plastics to minimize landfill waste.

🌐 **Live Domain:** [www.greencycle.site](http://www.greencycle.site)  
🔒 **Hosted via:** Cloudflare Tunnel (Secure HTTPS)

---

## 📖 Introduction
Greencycle supports a multi-role ecosystem involving **Customers, Staff, and Admins**. 

- **Customers** can register, manage profiles, and submit pickup requests. They can track their requests and accept/reject price quotations offered by the system.
- **Staff & Admins** utilize dedicated dashboards to manage daily operations.
- **Admins** have full authority over user management (Staff/Customers) and can update market recycling rates.

The system streamlines the recycling workflow, ensuring clarity and convenience for the community while promoting environmental responsibility.

---

## 🛠️ Technical Architecture
Greencycle is developed using the **Model-View-Controller (MVC)** architectural pattern and the **Data Access Object (DAO)** framework to ensure high maintainability and security.

### **The MVC Framework:**
- **Model:** Represented by **JavaBeans** (`CustomerBean`, `StaffBean`, etc.) that define the system's data structures.
- **View:** A responsive user interface built with **JavaServer Pages (JSP)** and integrated with the **AdminLTE 3** dashboard template.
- **Controller:** Managed by **Java Servlets**, which handle request processing and system navigation logic.

### **The DAO Layer:**
The **DAO (Data Access Object)** pattern is used to separate business logic from database logic. All SQL operations are encapsulated in DAO classes.

---

## 📂 Folder Structure
The project is organized into a clean directory structure to support modular development:

```text
Greencycle
├── Source Packages
│   ├── Greencycle.controller   # Servlets (Login, Signup, Management Logic)
│   ├── Greencycle.dao          # DAO Classes (SQL Queries & CRUD Logic)
│   ├── Greencycle.model        # JavaBeans (Data Objects)
│   └── Greencycle.db           # DBConnection utility for Apache Derby
│
├── Web Pages                   # Frontend (The View)
│   ├── app/                    # AdminLTE 3 assets (CSS, JS, Plugins)
│   ├── admin/                  # Admin Management JSPs
│   ├── staff/                  # Staff Dashboard JSPs
│   ├── customer/               # Customer Dashboard JSPs
│   ├── navbar/                 # Modular Navigation Bar fragments
│   ├── sidebar/                # Modular Sidebar fragments
│   ├── footer/                 # Standardized Footer fragment
│   ├── images/                 # System Logos (truck.png)
│   ├── index.jsp               # Main Login Page (SweetAlert2 integrated)
│   └── signup.jsp              # Customer Registration Page
