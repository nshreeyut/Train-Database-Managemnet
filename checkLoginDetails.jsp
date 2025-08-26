<%@ page import="java.sql.*, com.cs336.pkg.ApplicationDB, java.io.StringWriter, java.io.PrintWriter" %>
<%
    String userid = request.getParameter("username");
    String pwd = request.getParameter("password");

    if (userid == null || userid.isEmpty() || pwd == null || pwd.isEmpty()) {
        out.println("Please enter both username and password. <a href='login.jsp'>Try again</a>");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String redirectPage = null; // Variable to determine redirection page

    try {
        // Establish or retrieve the database connection
        con = (Connection) session.getAttribute("dbConnection");
        if (con == null || con.isClosed()) {
            ApplicationDB db = new ApplicationDB();
            con = db.getConnection();
            session.setAttribute("dbConnection", con);
        }

        // Step 1: Check if the user is an employee (admin or rep)
        String employeeQuery = "SELECT e.isAdmin, e.isRep, c.fname " +
                               "FROM Employees e " +
                               "JOIN Customers c ON e.username = c.username " +
                               "WHERE e.username = ? AND c.password = ?";
        ps = con.prepareStatement(employeeQuery);
        ps.setString(1, userid);
        ps.setString(2, pwd);
        rs = ps.executeQuery();

        if (rs.next()) {
            // User is an employee
            String firstName = rs.getString("fname");
            boolean isAdmin = rs.getBoolean("isAdmin");
            boolean isRep = rs.getBoolean("isRep");

            session.setAttribute("user", userid);
            session.setAttribute("Fname", firstName);

            if (isAdmin) {
                redirectPage = "adminDashboard.jsp";
            } else if (isRep) {
                redirectPage = "repDashboard.jsp";
            }
        } else {
            // Step 2: Check if the user is a regular customer
            String customerQuery = "SELECT fname FROM Customers WHERE username = ? AND password = ?";
            ps = con.prepareStatement(customerQuery);
            ps.setString(1, userid);
            ps.setString(2, pwd);
            rs = ps.executeQuery();

            if (rs.next()) {
                // User is a customer
                String firstName = rs.getString("fname");
                session.setAttribute("user", userid);
                session.setAttribute("Fname", firstName);
                redirectPage = "userDashboard.jsp";
            } else {
                // Step 3: Invalid credentials
                redirectPage = "loginError.jsp";
            }
        }
    } catch (Exception e) {
        // Handle exceptions and display error message
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);
        e.printStackTrace(pw);
        out.println(sw.toString());
        out.println("An error occurred while processing your request. <a href='login.jsp'>Try again</a>");
    } finally {
        // Close database resources
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
    }

    // Redirect to the determined page after all checks
    if (redirectPage != null) {
        response.sendRedirect(redirectPage);
    }
%>
