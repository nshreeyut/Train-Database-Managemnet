<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.cs336.pkg.ApplicationDB, java.io.StringWriter, java.io.PrintWriter" %>
<!DOCTYPE html>
<html>
<head>
    <title>Train Schedule System - Register</title>
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
        a {
            text-decoration: none;
            color: blue;
            font-size: 14px;
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
    <h1>Train Schedule System</h1>
    <div class="center" id="rcorner">
        <% 
            String errorMessage = null;
            String successMessage = null;

            if (request.getMethod().equalsIgnoreCase("POST")) {
                String firstName = request.getParameter("firstName");
                String lastName = request.getParameter("lastName");
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String confirmPassword = request.getParameter("confirmPassword");

                if (firstName == null || lastName == null || username == null || password == null || confirmPassword == null ||
                    firstName.trim().isEmpty() || lastName.trim().isEmpty() || username.trim().isEmpty() ||
                    password.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
                    errorMessage = "All fields are required.";
                } else if (!password.equals(confirmPassword)) {
                    errorMessage = "Passwords do not match.";
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

                        String checkQuery = "SELECT username FROM customers WHERE username = ?";
                        ps = conn.prepareStatement(checkQuery);
                        ps.setString(1, username);
                        ResultSet rs = ps.executeQuery();

                        if (rs.next()) {
                            errorMessage = "Username is already taken.";
                        } else {
                            String insertQuery = "INSERT INTO customers (username, password, fname, lname) VALUES (?, ?, ?, ?)";
                            ps = conn.prepareStatement(insertQuery);
                            ps.setString(1, username);
                            ps.setString(2, password);
                            ps.setString(3, firstName);
                            ps.setString(4, lastName);

                            int rows = ps.executeUpdate();
                            if (rows > 0) {
                                successMessage = "Registration successful! You can now log in.";
                            } else {
                                errorMessage = "Registration failed. Please try again.";
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
                <form action="register.jsp" method="post">
                    <label for="firstName">First Name:</label>
                    <input type="text" id="firstName" name="firstName" required>
                    
                    <label for="lastName">Last Name:</label>
                    <input type="text" id="lastName" name="lastName" required>
                    
                    <label for="username">Username:</label>
                    <input type="text" id="username" name="username" required>
                    
                    <label for="password">Password:</label>
                    <input type="password" id="password" name="password" required>
                    
                    <label for="confirmPassword">Confirm Password:</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required>
                    
                    <input type="submit" value="Submit">
                </form>
                <p>Already have an account? <a href="login.jsp">Go to Login</a></p>
            </fieldset>
        <% } else { %>
            <a href="login.jsp">Go to Login</a>
        <% } %>
    </div>
</body>
</html>
