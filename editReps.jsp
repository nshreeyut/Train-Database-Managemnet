<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <style>
        body {
            background-color: lightblue;
            font-family: Arial, sans-serif;
            text-align: center;
            margin: 0;
            padding: 0;
        }
        h1 {
            color: black;
            text-align: center;
        }
        .center {
            display: block;
            margin-left: auto;
            margin-right: auto;
        }
        .form-container {
            width: 50%;
            padding: 20px;
            margin: 20px auto;
            text-align: center;
            background-color: lightgray;
            border: 2px solid black;
            border-radius: 25px;
        }
        input[type="text"], input[type="password"] {
            padding: 10px;
            margin: 10px 0;
            width: 80%;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        button {
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }
        button:hover {
            background-color: #0056b3;
        }
        .message {
            margin: 10px 0;
            font-size: 16px;
        }
        .success {
            color: green;
        }
        .error {
            color: red;
        }
    </style>
    <head>
        <title>Edit Customer Representatives</title>
    </head>
    <body>
        <h1>Edit Customer Representatives</h1>

       <!-- Add Representative Section -->
<div class="form-container">
    <h2>Add Representative</h2>
    <form method="post">
        <input type="hidden" name="action" value="add">
        <input type="text" name="fname" placeholder="First Name" required><br>
        <input type="text" name="lname" placeholder="Last Name" required><br>
        <input type="text" name="username" placeholder="Username" required><br>
        <input type="password" name="password" placeholder="Password" required><br>
        <input type="text" name="ssn" placeholder="SSN" required><br>
        <button type="submit">Add Representative</button>
    </form>
    <%
        if ("add".equals(request.getParameter("action"))) {
            try {
                // Retrieve form parameters
                String fname = request.getParameter("fname");
                String lname = request.getParameter("lname");
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String ssn = request.getParameter("ssn");

                // Validate that none of the fields are empty
                if (fname.isEmpty() || lname.isEmpty() || username.isEmpty() || password.isEmpty() || ssn.isEmpty()) {
                    throw new Exception("All fields are required.");
                }
                if (ssn.length() != 11) {
                    throw new Exception("SSN must be exactly 11 characters long in the format XXX-XX-XXXX.");
                }

                // Get database connection from session
                Connection conn = (Connection) session.getAttribute("dbConnection");
                if (conn == null || conn.isClosed()) {
                    throw new Exception("Database connection is not available.");
                }

                // Start transaction
                conn.setAutoCommit(false);

                // Insert into Customers table
                String addCustomerQuery = "INSERT INTO Customers (username, password, fname, lname) VALUES (?, ?, ?, ?)";
                PreparedStatement ps = conn.prepareStatement(addCustomerQuery);
                ps.setString(1, username);
                ps.setString(2, password);
                ps.setString(3, fname);
                ps.setString(4, lname);
                ps.executeUpdate();

                // Insert into Employees table
                String addEmployeeQuery = "INSERT INTO Employees (ssn, username, isAdmin, isRep) VALUES (?, ?, 0, 1)";
                ps = conn.prepareStatement(addEmployeeQuery);
                ps.setString(1, ssn);
                ps.setString(2, username);
                ps.executeUpdate();

                // Commit transaction
                conn.commit();
                out.println("<p class='message success'>Representative added successfully.</p>");
            } catch (Exception e) {
                // Rollback in case of an error
                try {
                    Connection conn = (Connection) session.getAttribute("dbConnection");
                    if (conn != null && !conn.isClosed()) {
                        conn.rollback();
                    }
                } catch (SQLException ex) {
                    out.println("<p class='message error'>Error during rollback: " + ex.getMessage() + "</p>");
                }
                out.println("<p class='message error'>Error: " + e.getMessage() + "</p>");
            } finally {
                // Reset auto-commit to default
                try {
                    Connection conn = (Connection) session.getAttribute("dbConnection");
                    if (conn != null && !conn.isClosed()) {
                        conn.setAutoCommit(true);
                    }
                } catch (SQLException ex) {
                    out.println("<p class='message error'>Error resetting auto-commit: " + ex.getMessage() + "</p>");
                }
            }
        }
    %>
</div>

        <!-- Remove Representative Section -->
        <div class="form-container">
            <h2>Remove Representative</h2>
            <form method="post">
                <input type="hidden" name="action" value="remove">
                <input type="text" name="usernameRemove" placeholder="Username" required><br>
                <button type="submit">Remove Representative</button>
            </form>
            <%
                if ("remove".equals(request.getParameter("action"))) {
                    try {
                        String usernameRemove = request.getParameter("usernameRemove");

                        Connection conn = (Connection) session.getAttribute("dbConnection");
                        if (conn == null || conn.isClosed()) {
                            throw new Exception("Database connection is not available.");
                        }

                        String removeEmployeeQuery = "DELETE FROM Employees WHERE username = ?";
                        PreparedStatement ps = conn.prepareStatement(removeEmployeeQuery);
                        ps.setString(1, usernameRemove);
                        ps.executeUpdate();

                        String removeCustomerQuery = "DELETE FROM Customers WHERE username = ?";
                        ps = conn.prepareStatement(removeCustomerQuery);
                        ps.setString(1, usernameRemove);
                        ps.executeUpdate();

                        out.println("<p class='message success'>Representative removed successfully.</p>");
                    } catch (Exception e) {
                        out.println("<p class='message error'>Error: " + e.getMessage() + "</p>");
                    }
                }
            %>
        </div>

<!-- Edit Representative Section -->
<div class="form-container">
    <h2>Edit Representative</h2>
    <form method="post">
        <input type="hidden" name="action" value="edit">
        <input type="text" name="oldUsername" placeholder="Old Username" required><br>
        <input type="text" name="newUsername" placeholder="New Username"><br>
        <input type="text" name="newFname" placeholder="New First Name"><br>
        <input type="text" name="newLname" placeholder="New Last Name"><br>
        <input type="password" name="newPassword" placeholder="New Password"><br>
        <input type="text" name="newSsn" placeholder="New SSN"><br>
        <button type="submit">Edit Representative</button>
    </form>
    <%
        if ("edit".equals(request.getParameter("action"))) {
            try {
                String oldUsername = request.getParameter("oldUsername");
                String newUsername = request.getParameter("newUsername");
                String newFname = request.getParameter("newFname");
                String newLname = request.getParameter("newLname");
                String newPassword = request.getParameter("newPassword");
                String newSsn = request.getParameter("newSsn");

                Connection conn = (Connection) session.getAttribute("dbConnection");
                if (conn == null || conn.isClosed()) {
                    throw new Exception("Database connection is not available.");
                }

                // Validate new username if provided
                if (newUsername != null && !newUsername.isEmpty()) {
                    String checkUsernameQuery = "SELECT COUNT(*) FROM Customers WHERE username = ?";
                    PreparedStatement ps = conn.prepareStatement(checkUsernameQuery);
                    ps.setString(1, newUsername);
                    ResultSet rs = ps.executeQuery();
                    rs.next();
                    if (rs.getInt(1) > 0) {
                        throw new Exception("The new username already exists in the Customers table.");
                    }

                    checkUsernameQuery = "SELECT COUNT(*) FROM Employees WHERE username = ?";
                    ps = conn.prepareStatement(checkUsernameQuery);
                    ps.setString(1, newUsername);
                    rs = ps.executeQuery();
                    rs.next();
                    if (rs.getInt(1) > 0) {
                        throw new Exception("The new username already exists in the Employees table.");
                    }

                    // Update username in Customers table
                    String updateUsernameQuery = "UPDATE Customers SET username = ? WHERE username = ?";
                    ps = conn.prepareStatement(updateUsernameQuery);
                    ps.setString(1, newUsername);
                    ps.setString(2, oldUsername);
                    ps.executeUpdate();

                    // Update username in Employees table
                    updateUsernameQuery = "UPDATE Employees SET username = ? WHERE username = ?";
                    ps = conn.prepareStatement(updateUsernameQuery);
                    ps.setString(1, newUsername);
                    ps.setString(2, oldUsername);
                    ps.executeUpdate();

                    // Replace old username with new one for further updates
                    oldUsername = newUsername;
                }

                // Update other fields if provided
                if (newFname != null && !newFname.isEmpty()) {
                    String updateFnameQuery = "UPDATE Customers SET fname = ? WHERE username = ?";
                    PreparedStatement ps = conn.prepareStatement(updateFnameQuery);
                    ps.setString(1, newFname);
                    ps.setString(2, oldUsername);
                    ps.executeUpdate();
                }
                if (newLname != null && !newLname.isEmpty()) {
                    String updateLnameQuery = "UPDATE Customers SET lname = ? WHERE username = ?";
                    PreparedStatement ps = conn.prepareStatement(updateLnameQuery);
                    ps.setString(1, newLname);
                    ps.setString(2, oldUsername);
                    ps.executeUpdate();
                }
                if (newPassword != null && !newPassword.isEmpty()) {
                    String updatePasswordQuery = "UPDATE Customers SET password = ? WHERE username = ?";
                    PreparedStatement ps = conn.prepareStatement(updatePasswordQuery);
                    ps.setString(1, newPassword);
                    ps.setString(2, oldUsername);
                    ps.executeUpdate();
                }
                if (newSsn != null && !newSsn.isEmpty()) {
                    String updateSsnQuery = "UPDATE Employees SET ssn = ? WHERE username = ?";
                    PreparedStatement ps = conn.prepareStatement(updateSsnQuery);
                    ps.setString(1, newSsn);
                    ps.setString(2, oldUsername);
                    ps.executeUpdate();
                }

                out.println("<p class='message success'>Representative details updated successfully.</p>");
            } catch (Exception e) {
                out.println("<p class='message error'>Error: " + e.getMessage() + "</p>");
            }
        }
    %>
</div>
<!-- Back to Dashboard Button -->
<div class="form-container">
    <button onclick="window.location.href='adminDashboard.jsp'" style="margin-top: 20px;">Back to Dashboard</button>
</div>
    </body>
</html>
