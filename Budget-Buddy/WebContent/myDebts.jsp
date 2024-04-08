<!-- Include the header -->
<%@ include file="header.html" %>

<%@page import="java.util.List"%>
<%@page import="java.sql.*"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix = "sql"%>

<%
	int uid = (int)session.getAttribute("uid");
	String name = (String)session.getAttribute("name");
%>


<!-- My Debts Table -->
<section class="my-debts">
    <h2>My Debts</h2>
    
     <sql:setDataSource var = "snapshot" driver = "com.mysql.jdbc.Driver"
         url = "jdbc:mysql://localhost/BudgetBuddyDB"
         user = "root"  password = "mysql@db"/>
 
	      <sql:query dataSource = "${snapshot}" var = "result">
	         SELECT 
			    d.did,
			    d.eid,
			    e.description,
			    d.uamt,
			    CASE WHEN d.status = 1 THEN 'Paid' ELSE 'Unpaid' END AS status,
			    u.name
			FROM
			    debt d
			INNER JOIN
			    expenses e ON d.eid = e.eid
			INNER JOIN
			    users u ON e.paid_by = u.uid
			WHERE
			    d.uid = <%= uid %>; 
	      </sql:query>
    
    <table>
        <thead>
            <tr>
            	<th>Debt ID</th>
                <th>Expense ID</th>
                <th>Created By</th>
                <th>Description</th>
                <th>Amount</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var = "row" items = "${result.rows}">
           		<c:set var="stat" value="${row.status}" />
                <tr>
                    <td>${row.did}</td>
                    <td>${row.eid}</td>
                    <td>${row.name}</td>
                    <td>${row.description}</td>
                    <td>${row.uamt}</td>
                    <td>${row.status}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</section>
<br><button onclick="window.location.href = 'homepage.jsp'">Home</button>
<!-- Include the footer -->
<%@ include file="footer.html" %>
