<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.cs336.pkg.ApplicationDB, java.io.StringWriter, java.io.PrintWriter" %>
<!DOCTYPE html>
<html>
<head>
    <title>Reset Password - Train Schedule System</title>
    <style>
        body {
            background-color: lightblue;
            font-family: Arial, sans-serif;
        }
        h1 {
            color: black;
            text-align: center;
        }
        .center {
            display: block;
            margin-left: auto;
            margin-right: auto;
            width: 400px;
            padding: 20px;
        }
        #rcorner {
            border-radius: 25px;
            border: 2px solid black;
            background-color: lightgray;
        }
        fieldset {
            border: none;
            margin: auto;
        }
        .spacing {
            line-height: 1.5;
        }
        .margin {
            margin-top: 5px;
        }
        .message-box {
            text-align: center;
            margin-bottom: 10px;
        }
        .error {
            color: red;
        }
        .success {
            color: green;
        }
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            margin-bottom: 10px;
            border: 1px solid black;
            border-radius: 5px;
        }
        input[type="submit"] {
            background-color: #4285F4;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <h1>Reset Password</h1>
    <div class="center" id="rcorner">
        <% 
            String errorMessage = null;
            String successMessage = null;

            if (request.getMethod().equalsIgnoreCase("POST")) {
                String username = request.getParameter("username");
                String currentPassword = request.getParameter("currentPassword");
                String newPassword = request.getParameter("newPassword");

                if (username == null || currentPassword == null || newPassword == null ||
                    username.trim().isEmpty() || currentPassword.trim().isEmpty() || newPassword.trim().isEmpty()) {
                    errorMessage = "All fields are required.";
                } else if (currentPassword.equals(newPassword)) {
                    errorMessage = "New password cannot be the same as the current password.";
                } else {
                    Connection conn = null;
                    PreparedStatement ps = null;

                    try {
                        conn = (Connection) session.getAttribute("dbConnection");
                        if (conn == null || conn.isClosed()) {
                            ApplicationDB db = new ApplicationDB();
                            conn = db.getConnection();
                            session.setAttribute("dbConnection", conn);
                        }

                        String checkQuery = "SELECT username FROM customers WHERE username = ? AND password = ?";
                        ps = conn.prepareStatement(checkQuery);
                        ps.setString(1, username);
                        ps.setString(2, currentPassword);
                        ResultSet rs = ps.executeQuery();

                        if (!rs.next()) {
                            errorMessage = "Invalid username or current password.";
                        } else {
                            String updateQuery = "UPDATE customers SET password = ? WHERE username = ?";
                            ps = conn.prepareStatement(updateQuery);
                            ps.setString(1, newPassword);
                            ps.setString(2, username);

                            int rows = ps.executeUpdate();
                            if (rows > 0) {
                                successMessage = "Password updated successfully!";
                            } else {
                                errorMessage = "Failed to update password. Please try again.";
                            }
                        }
                    } catch (Exception e) {
                        StringWriter sw = new StringWriter();
                        PrintWriter pw = new PrintWriter(sw);
                        e.printStackTrace(pw);
                        errorMessage = "Error: " + sw.toString();
                    } finally {
                        if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                }
            }
        %>

        <div class="message-box">
            <% if (errorMessage != null) { %>
                <div class="error"><%= errorMessage %></div>
            <% } else if (successMessage != null) { %>
                <div class="success"><%= successMessage %></div>
            <% } %>
        </div>

        <% if (successMessage == null) { %>
            <fieldset class="spacing">
                <form action="resetPassword.jsp" method="post">
                    <label for="username">Username:</label>
                    <input type="text" id="username" name="username" required>
                    
                    <label for="currentPassword">Current Password:</label>
                    <input type="password" id="currentPassword" name="currentPassword" required>
                    
                    <label for="newPassword">New Password:</label>
                    <input type="password" id="newPassword" name="newPassword" required>
                    
                    <input type="submit" value="Submit">
                </form>
                <p>Go back to <a href="login.jsp">Login</a></p>
            </fieldset>
        <% } else { %>
            <a href="login.jsp">Go to Login</a>
        <% } %>
    </div>
</body>
</html>
