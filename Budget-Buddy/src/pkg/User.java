package pkg;

public class User {
	private int uid;
	private String name;
	private String mob;
	private String pass;
	public User(int uid, String name, String mob, String pass) {
		super();
		this.uid = uid;
		this.name = name;
		this.mob = mob;
		this.pass = pass;
	}
	public User(int uid, String name, String mob) {
		super();
		this.uid = uid;
		this.name = name;
		this.mob = mob;
	}
	
	public User(int uid, String name) {
		super();
		this.uid = uid;
		this.name = name;
	}
	public int getUid() {
		return uid;
	}
	public void setUid(int uid) {
		this.uid = uid;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getMob() {
		return mob;
	}
	public void setMob(String mob) {
		this.mob = mob;
	}
	public String getPass() {
		return pass;
	}
	public void setPass(String pass) {
		this.pass = pass;
	}
}
