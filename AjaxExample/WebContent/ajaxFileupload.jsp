<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html><html><head>
<title>使用XMLHttpRequest上传文件</title>
<script type="text/javascript">
	var xhr = new XMLHttpRequest();
	function fileSelected() {
		var msg = "";
		var files = document.getElementById('fileName').files;
		for (var i=0, file; file=files[i]; i++) {
			var fileSize = 0;
			if (file.size > 1024*1024)
				fileSize = (Math.round(file.size*100/(1024*1024))/100).toString()+'MB';
			else
				fileSize = (Math.round(file.size*100/1024)/100).toString()+'KB';
			msg = msg+file.name+' '+fileSize+' '+file.type+"<br/>";
		}
		document.getElementById('msg').innerHTML = msg;
	}
	
	function uploadFile() {
		var fd = new FormData();
		fd.append("memo", document.getElementById('memo').value); // 加入数据域memo
		var files = document.getElementById('fileName').files;
		for (var i=0, f; f=files[i]; i++) {
			fd.append(f.name, f);
		}
		xhr.upload.addEventListener("progress", uploadProgress, false);
		xhr.addEventListener("load", uploadComplete, false);
		xhr.addEventListener("error", uploadFailed, false);
		xhr.addEventListener("abort", uploadCanceled, false);
		xhr.open("POST", "fileupload.jsp");
		xhr.send(fd);
	}
	
	function cancelUploadFile() { xhr.abort(); }
	
	function uploadProgress(evt) {
		if(evt.lengthComputable) {
			var percentComplete = Math.round(evt.loaded*100/evt.total);
			document.getElementById('progressNumber').innerHTML 
				= percentComplete.toString()+'%';
		} else {
			document.getElementById('progressNumber').innerHTML
				= "unable to compute";
		}
	}
	
	function uploadComplete(evt) { alert(evt.target.responseText); }
	function uploadFailed(evt) { alert("上传失败！"); }
	function uploadCanceled(evt) { alert("您取消了本次上传。"); }
</script>
</head>
<body>
<p><label for="fileToUpload">选择文件</label>
<input type="file" name="fileName" id="fileName" multiple 
       onchange="fileSelected();" style="width: 800px" /></p>
<div id="msg"></div>
备注：<input type="text" name="memo" id="memo" />
<input type="button" onclick="uploadFile()" value="上传" />
<input type="button" onclick="cancelUploadFile()" value="取消" />
<div id="progressNumber"></div>
</body>
</html>