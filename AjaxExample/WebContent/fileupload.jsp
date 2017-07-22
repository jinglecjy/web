<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %><%@ page import="java.util.*" %>
<%@ page import="org.apache.commons.io.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<!DOCTYPE html>
<html>
<head><title>文件传输例子</title></head>
<body>
<% request.setCharacterEncoding("utf-8"); %>
<% boolean isMultipart
	  = ServletFileUpload.isMultipartContent(request); // 检查表单中是否包含文件
   if (isMultipart) {
	   FileItemFactory factory = new DiskFileItemFactory();
	   // factory.setSizeThreshold(yourMaxMemorySize); // 设置使用的内存最大值
	   // factory.setRepository(yourTempDirectory); // 设置文件临时目录
	   ServletFileUpload upload = new ServletFileUpload(factory);
	   // upload.setSizeMax(yourMaxRequestSize); // 允许的最大文件尺寸
	   List items = upload.parseRequest(request);
	   for (int i=0; i<items.size(); i++) {
		   FileItem fi = (FileItem) items.get(i);
		   if (fi.isFormField()) { // 如果是表单字段
			   out.println("输入域："+fi.getFieldName()+" 取值："
		                    +fi.getString("utf-8"));
		   }
		   else { // 如果是文件
			   DiskFileItem dfi = (DiskFileItem) fi;
		       // getName()返回文件名称或空串
		       if (!dfi.getName().trim().equals("")) {
		    	   out.print("文件被上传到服务上的实际位置：");
		    	   String fileName = application.getRealPath("/file")
		    			   + System.getProperty("file.separator")
		    			   + FilenameUtils.getName(dfi.getName());
		    	   out.println(new File(fileName).getAbsolutePath());
		    	   dfi.write(new File(fileName));
		       }
		   }
	   } // for
   }// if
%>
</body>
</html>