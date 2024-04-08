<!-- Include the header -->
<%@ include file="header.html" %>
<%@page import="java.util.List"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix = "sql"%>

<%
	int uid = (int)session.getAttribute("uid");
	String name = (String)session.getAttribute("name");
%>

<!-- My Expenses Table -->
<section class="my-expenses">
    <h2>My Expenses</h2>
    
    <sql:setDataSource var = "snapshot" driver = "com.mysql.jdbc.Driver"
         url = "jdbc:mysql://localhost/BudgetBuddyDB"
         user = "root"  password = "mysql@db"/>
 
	      <sql:query dataSource = "${snapshot}" var = "result">
	         SELECT 
			    e.eid,
			    e.description,
			    e.amount,
			    e.no_users,
			    COALESCE(SUM(CASE WHEN d.status = 1 THEN d.uamt ELSE 0 END), 0) AS paid_amount,
			    (e.amount - COALESCE(SUM(CASE WHEN d.status = 1 THEN d.uamt ELSE 0 END), 0)) AS unpaid_amount
			FROM
			    expenses e
			LEFT JOIN
			    debt d ON e.eid = d.eid
			WHERE
			    e.paid_by = <%=uid %>
			GROUP BY
			    e.eid, e.description, e.amount, e.no_users;
	      </sql:query>
    
    <table>
        <thead>
            <tr>
                <th>Expense ID</th>
                <th>Description</th>
                <th>Amount</th>
                <th>Users</th>
                <th>Received</th>
                <th>Pending</th>
                <th>View</th>
            </tr>
        </thead>
        <tbody>
             <c:forEach var = "row" items = "${result.rows}">
             		<c:set var="c_eid" value="${row.eid}" />
             
                    <c:url var="templink" value="expenseDetails.jsp">
						<c:param name="eid" value="${c_eid}"/>
					</c:url>
                    
                    <tr>
                    	<td>${c_eid}</td>
                    	<td>${row.description}</td>
                    	<td>${row.amount}</td>
                    	<td>${row.no_users}</td>
                    	<td>${row.paid_amount}</td>
                    	<td>${row.unpaid_amount}</td>
                    	<td><a href="${templink}">View Details</a></td>
                    </tr>
             </c:forEach>
        </tbody>
    </table>
</section>
<br><button onclick="window.location.href = 'homepage.jsp'">Home</button>
<!-- Include the footer -->
<%@ include file="footer.html" %>
