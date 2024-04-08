package pkg;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

/**
 * Servlet implementation class UserControllerServlet
 */
@WebServlet("/UserControllerServlet")
public class UserControllerServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private UserDbUtil userDbUtil;
	
	@Resource(name="jdbc/BudgetBuddyDB")
	private DataSource dataSource;
	
	@Override
	public void init() throws ServletException {
		super.init();
		
		try {
			userDbUtil = new UserDbUtil(dataSource);
		}catch(Exception e) {
			throw new ServletException(e);
		}
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request,response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			String theCommand = request.getParameter("command");
			
			switch(theCommand) {
			case "LOGIN":
				Login(request,response);
				break;
			case "GET_GROUP_USERS":
				getGroupUsers(request,response);
				break;
			case "CREATE_EXPENSE":
				createExpense(request,response);
				break;
			case "SIGNUP":
				SignUp(request,response);
				break;
			case "DEL_GROUP":
				delGroup(request,response);
				break;
			case "ADD_GRP":
				addGroup(request,response);
				break;
			default:
				doNothing();
			}
		}catch(Exception e) {
			throw new ServletException(e);
		}
	}

	private void addGroup(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
		Connection conn = dataSource.getConnection();
		
		String gname = request.getParameter("gname");
		HttpSession session = request.getSession();
		int cuid = (int)session.getAttribute("uid");
		
		Statement stm = conn.createStatement();
		stm.execute("INSERT INTO grp(gname,created_by) VALUES('"+gname+"',"+cuid+")");
		
		request.getRequestDispatcher("myGroups.jsp").forward(request, response);
	}

	private void delGroup(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
		Connection conn = dataSource.getConnection();
		
		int gid = Integer.parseInt(request.getParameter("gid"));
		
		Statement stm = conn.createStatement();
		stm.execute("DELETE FROM grp WHERE gid = "+gid);
		stm.execute("DELETE FROM user_grp WHERE gid = "+gid);
		
		request.getRequestDispatcher("myGroups.jsp").forward(request, response);
	}

	private void Login(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String uid = request.getParameter("userid");
		String pass = request.getParameter("password");
		
		User user = userDbUtil.Login(uid,pass);
		
		HttpSession session = request.getSession();
		session.removeAttribute("Error");
		if(user != null) {
			session.setAttribute("uid", user.getUid());
			session.setAttribute("name", user.getName());
			request.getRequestDispatcher("/homepage.jsp").forward(request, response);
		}else {
			session.setAttribute("Error", "1");
			request.getRequestDispatcher("/Login.jsp").forward(request, response);
		}
	}
	
	private void getGroupUsers(HttpServletRequest request, HttpServletResponse response)  throws Exception{
		String desc = request.getParameter("description");
		request.setAttribute("description", desc);
		int amt = Integer.parseInt(request.getParameter("amount"));
		request.setAttribute("amount", amt);
		String type = request.getParameter("type");
		request.setAttribute("type", type);
		
		int gid = Integer.parseInt(request.getParameter("group"));
		
		List<Integer> users = userDbUtil.getAllUsers(gid);

		request.setAttribute("users",users);
		request.getRequestDispatcher("/createExpenseDetails.jsp").forward(request,response);
	}
	
	private void createExpense(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
		String desc = (String)request.getParameter("description");
		int amt = Integer.parseInt(request.getParameter("amount"));
		String[] uid = request.getParameterValues("selectedUsers");
		String[] uamt = request.getParameterValues("userAmount");
		String type = (String)request.getParameter("type");
		int totalUsers = uid.length;
		
		HttpSession session = request.getSession();
		int cuid = (int)session.getAttribute("uid");
		
		Connection conn = dataSource.getConnection();
		Statement stm = conn.createStatement();
		String sql = "INSERT INTO expenses(description,amount,paid_by) VALUES('"+desc+"',"+amt+","+cuid+");";
		stm.execute(sql);
		ResultSet rs = stm.executeQuery("SELECT LAST_INSERT_ID() AS eid;");
		int eid = 0;
		if(rs.next())
			eid = rs.getInt("eid");
		
		String dsql = "INSERT INTO debt(eid,uid,uamt,status) VALUES("+eid+",?,?,FALSE)";
		PreparedStatement dstm = conn.prepareStatement(dsql);
		for(int i=0;i<uid.length;i++) {
			dstm.setInt(1, Integer.parseInt(uid[i]));
			if(type.equals("manual"))
				dstm.setInt(2, Integer.parseInt(uamt[i]));
			else if(type.equals("auto"))
				dstm.setInt(2, amt/totalUsers);
			dstm.execute();
		}
		request.getRequestDispatcher("/homepage.jsp").forward(request, response);
	}
	
	private void SignUp(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
		Connection conn = dataSource.getConnection();
		String name = (String)request.getParameter("name");
		String mob = (String)request.getParameter("mobile");
		String pass = (String)request.getParameter("password");
		
		String sql = "INSERT INTO users(name,mob,pass) VALUES(?,?,?)";
		
		PreparedStatement stm = conn.prepareStatement(sql);
		stm.setString(1, name);
		stm.setString(2, mob);
		stm.setString(3, pass);
		stm.execute();
		
		ResultSet rs = conn.createStatement().executeQuery("SELECT LAST_INSERT_ID() AS uid");
		int uid = 0;
		if(rs.next())
			uid = rs.getInt("uid");
		request.setAttribute("uid", uid);
		request.getRequestDispatcher("/signedUp.jsp").forward(request, response);
	}

	private void doNothing() {
		//SKIP
	}


}
