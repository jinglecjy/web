<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8"%>
<% request.setCharacterEncoding("utf-8"); %>
<% 
	String p1 = request.getParameter("p1");
	String p2 = request.getParameter("p2");
	String Car = request.getParameter("Car");
	String sex = request.getParameter("sex");
	String hobbys[] = request.getParameterValues("hobby");
	out.println("---------表单提交的内容如下---------<br/>");
	if(p1!=null) out.println("文本框："+p1);
	if(p2!=null) out.println("<br/>密码框："+p2); 
	if(Car!=null) out.println("<br/>下拉列表框："+Car); 
	if(sex!=null) out.println("<br/>单选框："+sex); 
	if(hobbys!=null) {
		out.println("<br/>复选框：");
		for(int i=0; i<hobbys.length; i++){
			out.print(hobbys[i]+" ");
		}
	}
%>