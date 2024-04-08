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
    <h2>My Groups</h2>
    
     <sql:setDataSource var = "snapshot" driver = "com.mysql.jdbc.Driver"
         url = "jdbc:mysql://localhost/BudgetBuddyDB"
         user = "root"  password = "mysql@db"/>
 
	      <sql:query dataSource = "${snapshot}" var = "result">
	         SELECT * FROM grp WHERE created_by = <%=uid %>;
	      </sql:query>
    <form method=GET action="UserControllerServlet">
    <input type="hidden" name="command" value="ADD_GRP"/>
    <table>
        <thead>
            <tr>
            	<th>Group ID</th>
            	<th>Group Name</th>
            	<th>Created On</th>
            	<th>View</th>
            	<th>Delete</th>
            </tr>
        </thead>
        <tbody>
        	<tr>
        		<td>-</td>
        		<td><input type="text" name="gname" placeholder="Enter Group Name" required></td>
        		<td>-</td>
        		<td><button type="submit">Add Group</button></td>
        		<td>-</td>
        	</tr>
            <c:forEach var = "row" items = "${result.rows}">
           		<c:set var="c_gid" value="${row.gid}" />
             
                    <c:url var="templink" value="groupDetails.jsp">
						<c:param name="gid" value="${c_gid}"/>
					</c:url>
					<c:url var="dellink" value="UserControllerServlet">
						<c:param name="command" value="DEL_GROUP"/>
						<c:param name="gid" value="${c_gid}"/>
					</c:url>
           		
                <tr>
                    <td>${row.gid}</td>
                    <td>${row.gname}</td>
                    <td>${row.created_on}</td>
                    <td><a href="${templink}">View Details</a></td>
                    <td><a href="${dellink}">Delete Group</a></td>
                </tr>
            </c:forEach>
        </tbody>
    </table></form>
</section>
<br><button onclick="window.location.href = 'homepage.jsp'">Home</button>
<!-- Include the footer -->
<%@ include file="footer.html" %>
