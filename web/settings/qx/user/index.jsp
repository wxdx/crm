<%@ page import="com.wkcto.crm.utils.UUIDGenerator" %>
<%@ page import="com.wkcto.crm.utils.MD5" %>
<%@ page import="com.wkcto.crm.utils.DateUtil" %>
<%@page contentType="text/html; charset=utf-8" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">


<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<link rel="stylesheet" href="jquery/bootstrap_3.3.0/css/bootstrap.min.css">


<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script>
  		$(function () {

            $("#createUserBtn").click(function () {
                $("#addUserForm")[0].reset();
                $("#deptCodeErrorMsg").text("");
                $("#emailErrorMsg").text("");
                $("#confirmPwdErrorMsg").text("");
                $("#pwdErrorMsg").text("");
                $("#actErrorMsg").text("");
                $.get(
                    "settings/qx/user/getDeptList.do",
                    function (data) {
                        $("#deptCode").html("<option></option>");
                        $(data).each(function () {
							$("#deptCode").append("<option name='deptName' value='"+this.deptno+"'>"+this.name+"</option>");
                        });
                    },
                    "json"
                );
                $("#createUserModal").modal("show");
            });
            $("#loginAct").focus(function () {
				if ($("#actErrorMsg").text() != ""){
				    $("#loginAct").val("");
				}
                $("#actErrorMsg").text("");
            });
			$("#loginAct").blur(function () {
			    var act = $.trim($("#loginAct").val());
				if (act == ""){
					$("#actErrorMsg").text("登录账户不能为空");
				} else {
				    $.ajaxSetup({
						async : false
					});
				    $.get(
				        "settings/qx/user/checkLoginAct.do",
						{"loginAct" : act},
						function (data) {
							if (data.success){
                                $("#actErrorMsg").text("");
							}  else {
                                $("#actErrorMsg").text("该账户已存在");
							}
                            $.ajaxSetup({
                                async : true
                            });
                        },
						"json"
					)
				}
            });
			$("#loginPwd").blur(function () {
				var loginPwd = $.trim($("#loginPwd").val());
				if (loginPwd == ""){
				    $("#pwdErrorMsg").text("密码不能为空");
				} else {
                    $("#pwdErrorMsg").text("");
				}
				if ($.trim($("#confirmPwd").val()) != ""){
                    $("#confirmPwd").blur();
				}
            });
            $("#loginPwd").focus(function () {
                if ($("#pwdErrorMsg").text() != ""){
                    $("#loginPwd").val("");
                }
                $("#pwdErrorMsg").text("");
            });
            $("#confirmPwd").blur(function () {
                if ($.trim($("#confirmPwd").val()) != $.trim($("#loginPwd").val()) ) {
                   $("#confirmPwdErrorMsg").text("两次密码不一致");
				}else{
                   $("#confirmPwdErrorMsg").text("");
				}
            });
            $("#confirmPwd").focus(function () {
                if ($("#confirmPwdErrorMsg").text() != ""){
                    $("#confirmPwd").val("");
                }
                $("#confirmPwdErrorMsg").text("");
            });
            $("#email").blur(function () {
				var regExp =  /^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.[a-zA-Z0-9]{2,6}$/;
				var email = $.trim($("#email").val());
				var ok = regExp.test(email);
				if (email == ""){
                    $("#emailErrorMsg").text("");
				} else {
                    if (ok) {
                        $("#emailErrorMsg").text("");
                    } else {
                        $("#emailErrorMsg").text("邮箱格式不正确,请检查邮箱格式");
                    }
                }
            });
            $("#email").focus(function () {
                if ($("#emailErrorMsg").text() != ""){
                    $("#email").val("");
                }
                $("#emailErrorMsg").text("");
            });
			$('#expireTime').datetimepicker({
				language: 'zh-CN',//显示中文
				format: 'yyyy-mm-dd hh:ii:ss',//显示格式
				//minView: "month",//设置只显示到月份
				initialDate: new Date(),//初始化当前日期
				autoclose: true,//选中自动关闭
				todayBtn: true,//显示今日按钮
				clearBtn: true
			});

			$("#deptCode").blur(function () {
				var deptCode = this.value;
				if (deptCode == ""){
				    $("#deptCodeErrorMsg").text("请选择部门");
				} else {
                    $("#deptCodeErrorMsg").text("");
				}
            });
            $("#saveBtn").click(function () {
                $.ajaxSetup({
                    async : false
                });
                $.ajax({
                    type:"post",
                    url : "settings/qx/user/save.do",
					data:{
                     "id" : "<%=UUIDGenerator.generate()%>",
					 "loginAct" : $.trim($("#loginAct").val()),
					 "name" : $.trim($("#name").val()),
					 "loginPwd" : "<%=MD5.get("+$.trim($('#loginPwd').val())+")%>",
					 "email" : $.trim($("#email").val()),
					 "expireTime" : $.trim($("#expireTime").val()),
					 "lockState" : $.trim($("#lockState").val()),
					 "deptCode" : $.trim($("#deptCode").val()),
					 "allowIps" : $.trim($("#allowIps").val()),
					 "createTime" :"<%=DateUtil.getSysTime()%>",
					 "createBy" : "admin",
                     "editTime" : "",
					  "editBy" : ""
                    },
					beforeSend :function () {
                        $("#loginAct").blur();
                        $("#loginPwd").blur();
                        $("#confirmPwd").blur();
                        $("#email").blur();
                        $("#deptCode").blur();
                        if ($("#deptCodeErrorMsg").text() == "" &&
                        $("#emailErrorMsg").text() == "" &&
                        $("#confirmPwdErrorMsg").text() == "" &&
                        $("#pwdErrorMsg").text() == "" &&
                        $("#actErrorMsg").text() == ""){
                            return true;
						}
						return false;
                    },
                    success:function (json) {
						if (json.success){
                            $("#createUserModal").modal("hide");
                            window.location.reload();
						} else {
						    alert("添加失败");
						}
                        $.ajaxSetup({
                            async : true
                        });

                    },
					dataType:"json"
                });
            });

        });
    </script>
</head>
<body>

	<!-- 创建用户的模态窗口 -->
	<div class="modal fade" id="createUserModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">新增用户</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form" id="addUserForm">
					
						<div class="form-group">
							<label for="create-loginActNo" class="col-sm-2 control-label">登录帐号<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="loginAct">
								<span id="actErrorMsg" style="color: red;font-size: 12px"></span>
							</div>
							<label for="create-username" class="col-sm-2 control-label">用户姓名</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="name">
							</div>
						</div>
						<div class="form-group">
							<label for="create-loginPwd" class="col-sm-2 control-label">登录密码<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="password" class="form-control" id="loginPwd">
								<span id="pwdErrorMsg" style="color: red;font-size: 12px"></span>
							</div>
							<label for="create-confirmPwd" class="col-sm-2 control-label">确认密码<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="password" class="form-control" id="confirmPwd">
								<span id="confirmPwdErrorMsg" style="color: red;font-size: 12px"></span>
							</div>
						</div>
						<div class="form-group">
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="email">
								<span id="emailErrorMsg" style="color: red;font-size: 12px"></span>
							</div>
							<label for="create-expireTime" class="col-sm-2 control-label">失效时间</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="expireTime" readonly="readonly">
							</div>
						</div>
						<div class="form-group">
							<label for="create-lockStatus" class="col-sm-2 control-label">锁定状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="lockState">
									<option value="0"></option>
								  <option value="0">启用</option>
								  <option value="1">锁定</option>
								</select>
							</div>
							<label for="create-org" class="col-sm-2 control-label">部门<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="deptCode">
                                    <%--<option></option>
                                    <option>市场部</option>
                                    <option>策划部</option>--%>
                                </select>
								<span id="deptCodeErrorMsg" style="color: red;font-size: 12px"></span>
                            </div>
						</div>
						<div class="form-group">
							<label for="create-allowIps" class="col-sm-2 control-label">允许访问的IP</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="allowIps" style="width: 280%" placeholder="多个用逗号隔开">
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn" >保存</button>
				</div>
			</div>
		</div>
	</div>
	
	
	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>用户列表</h3>
			</div>
		</div>
	</div>
	
	<div class="btn-toolbar" role="toolbar" style="position: relative; height: 80px; left: 30px; top: -10px;">
		<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
		  
		  <div class="form-group">
		    <div class="input-group">
		      <div class="input-group-addon">用户姓名</div>
		      <input class="form-control" type="text">
		    </div>
		  </div>
		  &nbsp;&nbsp;&nbsp;&nbsp;
		  <div class="form-group">
		    <div class="input-group">
		      <div class="input-group-addon">部门名称</div>
		      <input class="form-control" type="text">
		    </div>
		  </div>
		  &nbsp;&nbsp;&nbsp;&nbsp;
		  <div class="form-group">
		    <div class="input-group">
		      <div class="input-group-addon">锁定状态</div>
			  <select class="form-control">
			  	  <option></option>
			      <option>锁定</option>
				  <option>启用</option>
			  </select>
		    </div>
		  </div>
		  <br><br>
		  
		  <div class="form-group">
		    <div class="input-group">
		      <div class="input-group-addon">失效时间</div>
			  <input class="form-control" type="text" id="startTime" />
		    </div>
		  </div>
		  
		  ~
		  
		  <div class="form-group">
		    <div class="input-group">
			  <input class="form-control" type="text" id="endTime" />
		    </div>
		  </div>
		  
		  <button type="submit" class="btn btn-default">查询</button>
		  
		</form>
	</div>
	
	
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px; width: 110%; top: 20px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button type="button" class="btn btn-primary" id="createUserBtn" ><span class="glyphicon glyphicon-plus"></span> 创建</button>
		  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
		<div class="btn-group" style="position: relative; top: 18%; left: 5px;">
			<button type="button" class="btn btn-default">设置显示字段</button>
			<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
				<span class="caret"></span>
				<span class="sr-only">Toggle Dropdown</span>
			</button>
			<ul id="definedColumns" class="dropdown-menu" role="menu"> 
				<li><a href="javascript:void(0);"><input type="checkbox"/> 登录帐号</a></li>
				<li><a href="javascript:void(0);"><input type="checkbox"/> 用户姓名</a></li>
				<li><a href="javascript:void(0);"><input type="checkbox"/> 部门名称</a></li>
				<li><a href="javascript:void(0);"><input type="checkbox"/> 邮箱</a></li>
				<li><a href="javascript:void(0);"><input type="checkbox"/> 失效时间</a></li>
				<li><a href="javascript:void(0);"><input type="checkbox"/> 允许访问IP</a></li>
				<li><a href="javascript:void(0);"><input type="checkbox"/> 锁定状态</a></li>
				<li><a href="javascript:void(0);"><input type="checkbox"/> 创建者</a></li>
				<li><a href="javascript:void(0);"><input type="checkbox"/> 创建时间</a></li>
				<li><a href="javascript:void(0);"><input type="checkbox"/> 修改者</a></li>
				<li><a href="javascript:void(0);"><input type="checkbox"/> 修改时间</a></li>
			</ul>
		</div>
	</div>
	
	<div style="position: relative; left: 30px; top: 40px; width: 110%">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" /></td>
					<td>序号</td>
					<td>登录帐号</td>
					<td>用户姓名</td>
					<td>部门名称</td>
					<td>邮箱</td>
					<td>失效时间</td>
					<td>允许访问IP</td>
					<td>锁定状态</td>
					<td>创建者</td>
					<td>创建时间</td>
					<td>修改者</td>
					<td>修改时间</td>
				</tr>
			</thead>
			<tbody>
				<tr class="active">
					<td><input type="checkbox" /></td>
					<td>1</td>
					<td><a  href="detail.html">zhangsan</a></td>
					<td>张三</td>
					<td>市场部</td>
					<td>zhangsan@bjpowernode.com</td>
					<td>2017-02-14 10:10:10</td>
					<td>127.0.0.1,192.168.100.2</td>
					<td><a href="javascript:void(0);" onclick="window.confirm('您确定要锁定该用户吗？');" style="text-decoration: none;">启用</a></td>
					<td>admin</td>
					<td>2017-02-10 10:10:10</td>
					<td>admin</td>
					<td>2017-02-10 20:10:10</td>
				</tr>
				<tr>
					<td><input type="checkbox" /></td>
					<td>2</td>
					<td><a  href="detail.html">lisi</a></td>
					<td>李四</td>
					<td>市场部</td>
					<td>lisi@bjpowernode.com</td>
					<td>2017-02-14 10:10:10</td>
					<td>127.0.0.1,192.168.100.2</td>
					<td><a href="javascript:void(0);" onclick="window.confirm('您确定要启用该用户吗？');" style="text-decoration: none;">锁定</a></td>
					<td>admin</td>
					<td>2017-02-10 10:10:10</td>
					<td>admin</td>
					<td>2017-02-10 20:10:10</td>
				</tr>
			</tbody>
		</table>
	</div>
	
	<div style="height: 50px; position: relative;top: 30px; left: 30px;">
		<div>
			<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
		</div>
		<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
			<button type="button" class="btn btn-default" style="cursor: default;">显示</button>
			<div class="btn-group">
				<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
					10
					<span class="caret"></span>
				</button>
				<ul class="dropdown-menu" role="menu">
					<li><a href="#">20</a></li>
					<li><a href="#">30</a></li>
				</ul>
			</div>
			<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
		</div>
		<div style="position: relative;top: -88px; left: 285px;">
			<nav>
				<ul class="pagination">
					<li class="disabled"><a href="#">首页</a></li>
					<li class="disabled"><a href="#">上一页</a></li>
					<li class="active"><a href="#">1</a></li>
					<li><a href="#">2</a></li>
					<li><a href="#">3</a></li>
					<li><a href="#">4</a></li>
					<li><a href="#">5</a></li>
					<li><a href="#">下一页</a></li>
					<li class="disabled"><a href="#">末页</a></li>
				</ul>
			</nav>
		</div>
	</div>
			
</body>
</html>