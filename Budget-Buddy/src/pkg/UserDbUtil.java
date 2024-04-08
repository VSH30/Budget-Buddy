package pkg;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

public class UserDbUtil {
	private DataSource dataSource;
	
	public UserDbUtil(DataSource theDataSource){
		dataSource = theDataSource;
	}

	public User Login(String uid, String pass) throws Exception{
		Connection conn = dataSource.getConnection();
		
		String sql = "SELECT uid, name, mob FROM USERS WHERE uid = ? AND pass = ?";
		
		PreparedStatement stm = conn.prepareStatement(sql);
		
		stm.setString(1, uid);
		stm.setString(2, pass);
		
		ResultSet rs = stm.executeQuery();
		
		if(rs.next())
			return new User(rs.getInt("uid"),rs.getString("name"),rs.getString("mob"));
		else
			return null;
	}

	public List<Integer> getAllUsers(int gid) throws Exception{
		List<Integer> users = new ArrayList<>();
		Connection conn = dataSource.getConnection();
		String sql = "SELECT uid FROM user_grp WHERE gid="+gid+";";
		Statement stm = conn.createStatement();
		ResultSet rs = stm.executeQuery(sql);
		
		while(rs.next()) {
			int temp = rs.getInt("uid");
			users.add(temp);
		}
		
		return users;
	}
	
}
