
package com.cs336.pkg;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ApplicationDB {

    // Database connection details as class-level constants
    // Method to get a connection to the database
    public Connection getConnection() {
        Connection connection = null;
        String URL = "jdbc:mysql://localhost:3306/cs336project?useSSL=false&allowPublicKeyRetrieval=true";

    try {
        // Use the old driver class for MySQL Connector 5.1.49
        Class.forName("com.mysql.jdbc.Driver");

        // Establish the connection
        connection = DriverManager.getConnection(URL, "root", "root");
        System.out.println("Database connection established successfully.");
    } catch (ClassNotFoundException e) {
        System.err.println("JDBC Driver not found. Please check if the MySQL Connector JAR is in the WEB-INF/lib folder.");
        e.printStackTrace();
    } catch (SQLException e) {
        System.err.println("Failed to establish database connection. Check your URL, username, and password.");
        e.printStackTrace();
    }
    return connection;
}

    // Method to close the connection
    public void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
                System.out.println("Database connection closed successfully.");
            } catch (SQLException e) {
                System.err.println("Failed to close the database connection.");
                e.printStackTrace();
            }
        }
    }

    // Main method for testing the database connection
    public static void main(String[] args) {
        ApplicationDB dao = new ApplicationDB();

        // Try-with-resources ensures the connection is closed automatically
        try (Connection connection = dao.getConnection()) {
            if (connection != null) {
                System.out.println("Connection successful: " + connection);
            } else {
                System.out.println("Connection failed.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
