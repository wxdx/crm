<%@page contentType="text/html; charset=utf-8" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">


	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script>
		if (window.top != window.self){
		    window.top.location = window.self.location;
		}
        $(function () {
           $("#loginAct").focus();
           $("#loginBtn").click(function () {
             	login();
           });
           $(window).keydown(function (e) {
               if (e.keyCode == 13){
                   login();
               }
           });
           $(".clear").focus(function () {
               $("#errorMsg").text("");
           });

        });
        function login() {
            var loginAct = $.trim($("#loginAct").val());
            var loginPwd = $.trim($("#loginPwd").val());
            var tenDayAutoLoginFlag = "no";
            if($("#tenDayAutoLoginFlag").prop("checked")){
                tenDayAutoLoginFlag = "ok";
            }
            $.ajax({
                type:"post",
                url:"login.do",
                data:{"loginAct" : loginAct,"loginPwd" : loginPwd,"tenDayAutoLoginFlag" : tenDayAutoLoginFlag},
                beforeSend :function () {
                    if (loginAct != "" && loginPwd != ""){
                        return true;
                    } else {
                        $("#errorMsg").text("用户名密码不能为空");
                        return false;
                    }
                },
                dataType : "json",
                success : function (json) {
                    if (json.success){
                        window.location.href = "workbench/index.jsp";
                    } else {
                        $("#errorMsg").text(json.errorMsg);
                    }
                }
            });
        }
    </script>
</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2017&nbsp;动力节点</span></div>
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control clear" id="loginAct" type="text" placeholder="用户名">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control clear" id="loginPwd" type="password" placeholder="密码">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						<label>
							<input type="checkbox" id="tenDayAutoLoginFlag"> 十天内免登录
                            <span id="errorMsg" style="color: red;font-size: 12px"></span>
						</label>
					</div>
					<button type="button" class="btn btn-primary btn-lg btn-block" id="loginBtn" style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>