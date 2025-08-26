<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCUMENT html>
<html>
    <style>
        body {
            background-color: lightblue;
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
        div {
            width: 200px;
            padding: 50px;
            margin: 20px;
            text-align: center;
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
    </style>
    <head>
        <title>Train Schedule System</title>
    </head>
    <body>
        <h1>Train Schedule System</h1>
        <div class="center" id="rcorner">
            <fieldset class="spacing">
                <form action="checkLoginDetails.jsp" method="post">
                    <label for="username">Username:</label><br>
                    <input type="text" id="username" name="username"><br>
                    <label for="password">Password:</label><br>
                    <input type="password" id="password" name="password"><br>
                    <input class="margin" type="submit" value="Submit">
                </form>
                <text class="margin">Don't have an account?</text>
                <a href="register.jsp">Register</a><br>
                <text class="margin">Forgot your Password?</text>
                <a href="resetPassword.jsp">Reset Password</a><br>
            </fieldset>
        </div>
    </body>
</html>
