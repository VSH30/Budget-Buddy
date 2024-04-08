<!-- Include the header -->
<%@ include file="header.html" %>
<%
	int uid = (int)session.getAttribute("uid");
	String name = (String)session.getAttribute("name");
%>
<!-- Homepage Options -->
<section class="homepage-options">
    <h2>Welcome, <%= name %></h2>
    <ul>
        <li><a href="createExpense.jsp">Create Expense</a></li>
        <li><a href="myDebts.jsp">My Debts</a></li>
        <li><a href="myExpenses.jsp">My Expenses</a></li>
        <li><a href="myGroups.jsp">My Groups</a></li>
        <li><a href="Login.jsp">Logout</a></li>
    </ul>
</section>

<!-- Include the footer -->
<%@ include file="footer.html" %>
