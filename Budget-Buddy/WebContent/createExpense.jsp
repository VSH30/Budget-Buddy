<!-- Include the header -->
<%@ include file="header.html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix = "sql"%>

<%
	int uid = (int)session.getAttribute("uid");
	String name = (String)session.getAttribute("name");
%>
<!-- Create Expense Form -->

<section class="create-expense-form">
    <h2>Create Expense</h2>
    
    <sql:setDataSource var = "snapshot" driver = "com.mysql.jdbc.Driver"
         url = "jdbc:mysql://localhost/BudgetBuddyDB"
         user = "root"  password = "mysql@db"/>
 
      <sql:query dataSource = "${snapshot}" var = "result">
         SELECT * FROM grp, user_grp WHERE user_grp.uid = <%= uid %>;
      </sql:query>
    
    <form action="UserControllerServlet" method="post">
        <input type="text" name="description" placeholder="Expense Description" required>
        <input type="number" name="amount" placeholder="Amount" required>
        <br>Split: <input type="radio" name="type" value="auto" required>Auto
        <input type="radio" name="type" value="manual">Manual
        
        <!-- Group Dropdown -->
        <select name="group" required>
        	<option value="0" selected>Select Group</option>
	        <c:forEach var = "row" items = "${result.rows}">
            	<option value="${row.gid}">${row.gname}</option>
            </c:forEach>
        </select>
        <input type="hidden" name="command" value="GET_GROUP_USERS"/>
        <button type="submit">Next</button>
    </form>
</section>

<!-- Include the footer -->
<%@ include file="footer.html" %>
