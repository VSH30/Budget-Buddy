<!-- Include the header -->
<%@page import="java.util.List"%>
<%@ include file="header.html" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix = "sql"%>

<%!
	boolean isPresent(int x, List<Integer> arr){
		if(arr.contains(x))
				return true;
		return false;
	}
%>

<%
	int uid = (int)session.getAttribute("uid");
	request.setAttribute("cuid", uid);
	String name = (String)session.getAttribute("name");
	List<Integer> user = (List<Integer>)pageContext.getAttribute("users");
%>

<!-- Create Expense Form -->
<section class="create-expense-form">
    <h2>Create Expense (Details)</h2>
    <form id="expenseForm" action="UserControllerServlet" method="post" onsubmit="checkTotalAmount(event)">
        <input type="hidden" name="command" value="CREATE_EXPENSE"/>
        <input type="text" value="${description}" required disabled>
        <input type="text" id="totalAmount" value="${amount}" required disabled>
        <input type="text" value="${type}" required disabled>
        
        <input type="hidden" name="description" value="${description}">
        <input type="hidden" name="amount" id="totalAmount" value="${amount}">
        <input type="hidden" name="type" value="${type}">
        
         <sql:setDataSource var = "snapshot" driver = "com.mysql.jdbc.Driver"
         url = "jdbc:mysql://localhost/BudgetBuddyDB"
         user = "root"  password = "mysql@db"/>
 
	      <sql:query dataSource = "${snapshot}" var = "result">
	         SELECT uid, name FROM users;
	      </sql:query>
        
        <!-- Scrollable Table -->
        <div class="user-table">
            <table id="userTable">
                <thead>
                    <tr>
                        <th>Display Name</th>
                        <th>Select User</th>
                        <c:if test="${type == 'manual'}">
                        	<th>Amount</th>
                        </c:if>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var = "row" items = "${result.rows}">
                    <tr>
                    	<td>${row.name}</td>
                    	<!--<td>
                    	 <c:set var="uidInt" value="${Integer.parseInt(row.uid)}" />
                    	<input type="checkbox" name="selectedUsers" value="${row.uid}" onchange="toggleNumberInput(this)"
                    		<c:if test="${user.contains(uidInt)}">checked</c:if>
                    	> </td>-->
                    	<td><input type="checkbox" name="selectedUsers" value="${row.uid}" onchange="toggleNumberInput(this)">
                    		<!--<c:if test="${row.uid == uid}">checked</c:if>-->
                    	</td>
                        <c:if test="${type == 'manual'}">
                        	<td><input type="number" name="userAmount" value="0" disabled></td>
                        </c:if>
                    </tr>
            		</c:forEach>
                    <!-- Add more table rows as needed -->
                </tbody>
            </table>
        </div>
        <button type="submit">Submit Expense</button>
    </form>
</section>

<!-- Include the footer -->
<%@ include file="footer.html" %>

<!-- JavaScript Code -->
<script>
    // Function to enable/disable number input based on checkbox state
    function toggleNumberInput(checkbox) {
    	if('manual'==='<%=request.getAttribute("type")%>'){
	        var numberInput = checkbox.parentNode.nextElementSibling.querySelector('input[type="number"]');
	        numberInput.disabled = !checkbox.checked;
    	}
    }

    // Function to check total amount on form submission
    function checkTotalAmount(event) {
    	if('manual'==='<%=request.getAttribute("type")%>'){
	        var totalAmount = parseInt(document.getElementById("totalAmount").value);
	        var userAmountInputs = document.getElementsByName("userAmount");
	        var sum = 0;
	        for (var i = 0; i < userAmountInputs.length; i++) {
	            sum += parseInt(userAmountInputs[i].value);
	        }
	        if (sum !== totalAmount) {
	            event.preventDefault(); // Prevent form submission
	            alert("Total user amounts must match the specified total amount.");
	        }else{
	        	
	        }
    	}
    }
</script>
