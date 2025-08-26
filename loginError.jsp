<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Check if the user session attribute is null
    if (session.getAttribute("user") == null) {
%>
<!DOCTYPE html>
<html>
<head>
    <title>Login Error</title>
    <style>
        body {
            background-color: lightblue;
            font-family: Arial, sans-serif;
            text-align: center;
            padding-top: 50px;
        }
        .error-message {
            color: red;
            font-size: 20px;
            margin-bottom: 20px;
        }
        .login-button {
            padding: 10px 20px;
            background-color: #4285F4;
            color: #fff;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            text-decoration: none;
        }
        .login-button:hover {
            background-color: #3071A9;
        }
    </style>
</head>
<body>
    <h2 class="error-message">Invalid username or password.</h2>
    <a href="login.jsp" class="login-button">Try Again</a>
</body>
</html>
<%
    } else {
%>
<!DOCTYPE html>
<html>
<head>
    <title>Already Logged In</title>
    <style>
        body {
            background-color: lightblue;
            font-family: Arial, sans-serif;
            text-align: center;
            padding-top: 50px;
        }
        .message {
            color: black;
            font-size: 18px;
        }
        .logout-button {
            padding: 10px 20px;
            background-color: #4285F4;
            color: #fff;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            text-decoration: none;
        }
        .logout-button:hover {
            background-color: #3071A9;
        }
    </style>
</head>
<body>
    <h2 class="message">You are already logged in.</h2>
    <a href="logout.jsp" class="logout-button">Log Out</a>
</body>
</html>
<%
    }
%>
