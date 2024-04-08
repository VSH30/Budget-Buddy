<!-- Include the header -->
<%@ include file="header.html" %>
<%@page import="java.util.List"%>
<%@page import="java.sql.*"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix = "sql"%>

<%
	int uid = (int)session.getAttribute("uid");
	String name = (String)session.getAttribute("name");
	int eid = Integer.parseInt(request.getParameter("eid"));
%>

<section class="expense-details">
    <h2>Expense Details</h2>
    
    <sql:setDataSource var = "snapshot" driver = "com.mysql.jdbc.Driver"
         url = "jdbc:mysql://localhost/BudgetBuddyDB"
         user = "root"  password = "mysql@db"/>
 
	      <sql:query dataSource = "${snapshot}" var = "result">
	         SELECT
	         	did,
	         	debt.uid,
	         	name,
	         	uamt,
	         	CASE
	         		WHEN status = 1 THEN 'Paid'
	         		ELSE 'Unpaid'
	         	END AS status
	         FROM
	         	debt, users
	         WHERE
	         	users.uid = debt.uid
	         AND
	         	eid = <%=eid %>;
	      </sql:query>
    
    <table>
        <thead>
            <tr>
            	<th>DebtID</th>
                <th>User Name</th>
                <th>Status</th>
                <th>Amount</th>
                <th>Change Status</th>
            </tr>
        </thead>
        <tbody>
           <c:forEach var = "row" items = "${result.rows}">
           		<c:set var="stat" value="${row.status}" />
                <tr>
                    <td>${row.did}</td>
                    <td>${row.name}</td>
                    <td>${row.uamt}</td>
                    <td>${stat}</td>
                    <td>
						 <form method="post">
                    <!-- Hidden input fields to store debt ID and new status -->
                    <input type="hidden" name="did" value="${row.did}" />
                    <input type="hidden" name="newStatus" value="<%=pageContext.getAttribute("stat").equals("Paid") ? 0 : 1 %>" />
                    <!-- Button to submit the form -->
                    <button type="submit">Toggle Status</button>
                </form>
					</td>
                </tr>
             </c:forEach>
        </tbody>
    </table>
</section>
<%
    // Check if the form has been submitted
    if ("POST".equals(request.getMethod())) {
        // Retrieve debt ID and new status from the form parameters
        int did = Integer.parseInt(request.getParameter("did"));
        String newStatus = request.getParameter("newStatus");
        
        // Perform the database update
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/BudgetBuddyDB", "root", "mysql@db");
            PreparedStatement stmt = conn.prepareStatement("UPDATE debt SET status = ? WHERE did = ?");
            stmt.setString(1, newStatus);
            stmt.setInt(2, did);
            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated > 0) {
            	response.sendRedirect("myExpenses.jsp");
            } else {
                out.println("<p>Failed to update status.</p>");
            }
            conn.close();
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    }
%>

<br><button onclick="window.location.href = 'homepage.jsp'">Home</button>
<!-- Include the footer -->
<%@ include file="footer.html" %>
