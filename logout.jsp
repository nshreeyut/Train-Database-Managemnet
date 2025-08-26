<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>

<%
    // Retrieve the database connection from the session
    Connection con = (Connection) session.getAttribute("dbConnection");

    // Close the database connection if it exists
    if (con != null) {
        ApplicationDB db = new ApplicationDB();
        db.closeConnection(con);
        session.removeAttribute("dbConnection");
    }

    // Invalidate the current session to log the user out
    session.invalidate();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Train Schedule System - Logged Out</title>
    <meta http-equiv="refresh" content="3;url=login.jsp" />
    <style>
        body {
            background-color: lightblue;
            font-family: Arial, sans-serif;
            text-align: center;
            margin: 0;
            padding: 0;
        }
        .header {
            text-align: center;
            padding: 20px;
        }
        .message-container {
            border-radius: 25px;
            border: 2px solid black;
            background-color: lightgray;
            width: 300px;
            padding: 20px;
            margin: 20px auto;
            text-align: center;
        }
        .message-container h2 {
            color: black;
        }
        .login-button {
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #4285F4;
            color: #fff;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }
        .login-button:hover {
            background-color: #3071A9;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Train Schedule System</h1>
    </div>
    <div class="message-container">
        <h2>You have been logged out successfully. Redirecting to login page...</h2>
    </div>
</body>
</html>
