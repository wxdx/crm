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
	$(function () {
		loadPage();
		function loadPage() {
			$.get(
				"settings/dept/getList.do",
				 function (data) {
					$(data).each(function () {
						$("#tBody").append("<tr class='active'><td><input type='checkbox' name='deptSelect' value="+this.deptno+"></td><td>"+
							this.deptno+"</td><td>"+
							this.name+"</td><td>"+
							this.leader+"</td><td>"+
							this.phone+"</td><td>"+
							this.description+"</td> </tr>")
					});
				},
				"json"
			)
		}
		$("#openCreateModalBtn").click(function () {
			$("#createDeptModal").modal("show");
		});
		$("#deptNo").blur(function () {
			checkNo("deptNo","deptNoErrorMsg");
		});

		$("#eDeptNo").blur(function () {
			checkNo("eDeptNo","eDeptNoErrorMsg");
		});

		function checkNo(id,errorId){
			var deptNo = $.trim($("#"+id).val());
			if (deptNo == ""){
				$("#"+errorId).text("编号不能为空");
			} else {
				var regExp = /^\d{4}$/;
				var ok = regExp.test(deptNo);
				if (ok){
					$("#"+errorId).text("");

					$.ajaxSetup({
						async : false
					});

					//验证编码是否重复
					$.ajax({
						type:"get",
						url:"settings/dept/checkNo.do",
						data:{"deptno" : deptNo,"_":new Date().getTime()},
						dataType:"json",
						success:function (json) {
							if (json.success){
								//可用的编号
								$("#"+errorId).text("");
							} else {
								//不可用
								$("#"+errorId).text("该编号已存在!");
							}
							if (id==="eDeptNo" && errorId==="eDeptNoErrorMsg") {
								if (changeNo === deptNo) {
									$("#"+errorId).text("");
								}
							}
							$.ajaxSetup({
								async : true
							});
						}
					});

				} else {
					$("#"+errorId).text("编号只能是四位数字");
				}
			}
		 }


		$("#deptNo").focus(function () {
			if ($("#deptNoErrorMsg").text() != ""){
				$("#deptNo").val("");
			}
			$("#deptNoErrorMsg").text("");
		});

		$("#closeCreateBtn").click(function () {
			$("#createDeptModal").modal("hide");
		});

		$("#saveCreateBtn").click(function () {
			$("#deptNo").blur();
			if ($("#deptNoErrorMsg").text() == "") {
				$.post(
					"settings/dept/add.do",
					{
						"deptno": $.trim($("#deptNo").val()),
						"name": $.trim($("#name").val()),
						"leader": $.trim($("#leader").val()),
						"phone": $.trim($("#phone").val()),
						"description": $.trim($("#description").val())
					},
					function (data) {
						if (data.success) {
							$("#createDeptModal").modal("hide");
							window.location.reload();
						} else {
							alert("添加部门失败");
							$("#createDeptModal").modal("hide");
						}

					},
					"json"
				)
			}
		});

		$( "#createDeptModal" ).on( "show.bs.modal" ,function(){
			$("#createDept")[0].reset();
		});

		var changeNo;
		$("#openEditModalBtn").click(function () {
			var $deptSelect = $("input:checkbox[name='deptSelect']:checked");
			if ($deptSelect.length == 0){
				alert("请选择一条记录来修改");
			} else if ($deptSelect.length > 1) {
				alert("不能同时修改多条记录");
			} else {
				$("#editDeptModal").modal("show");
				var deptNo = $deptSelect[0].value;
				$.get(
					"settings/dept/getOne.do",
					{"deptno":deptNo},
					function (data) {
						$("#eDeptNo").val(data.deptno);
						changeNo = data.deptno;
						$("#oldDeptNo").val(data.deptno);
						$("#eName").val(data.name);
						$("#eLeader").val(data.leader);
						$("#ePhone").val(data.phone);
						$("#eDescription").val(data.description);
					},
					"json"
				)
			}
		});
		$("#doUpdateBtn").click(function () {
			$("#eDeptNo").blur();
			if ($("#eDeptNoErrorMsg").text() == "") {
				$.post(
					"settings/dept/update.do",
					{
						"deptno": $.trim($("#eDeptNo").val()),
						"oldDeptno": $("#oldDeptNo").val(),
						"name": $.trim($("#eName").val()),
						"leader": $.trim($("#eLeader").val()),
						"phone": $.trim($("#ePhone").val()),
						"description": $.trim($("#eDescription").val())
					},
					function (data) {
						if (data.success) {
							$("#editDeptModal").modal("hide");
							window.location.reload();
						} else {
							alert("更新失败");
							$("#editDeptModal").modal("hide");
						}
					},
					"json"
				)
			}
		});

		$("#DeleteBtn").click(function () {
			var $deptSelect = $("input:checkbox[name='deptSelect']:checked");
			if ($deptSelect.length == 0){
				alert("请至少选择一条记录来删除");
			} else {
				if (confirm("你确定删除吗?")) {
					var path = "?";
					for (var i = 0; i < $deptSelect.length; i++) {
						if (i === 0) {
							path += "deptno=" + $deptSelect[i].value;
						} else {
							path += "&deptno=" + $deptSelect[i].value;
						}
					}
					window.location.href = "settings/dept/delete.do" + path;
				}
			}
		});
		$("#qx").click(function () {
			var $qx = $("#qx");
			var $xz = $("input:checkbox[name='deptSelect']");
			if ($qx[0].checked){
				for (var i = 0;i < $xz.length;i++){
					$xz[i].checked = true;
				}
			}  else {
				for (var i = 0;i < $xz.length;i++){
					$xz[i].checked = false;
				}
			}
		});


	})
</script>
</head>
<body>

	<!-- 我的资料 -->
	<div class="modal fade" id="myInformation" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">我的资料</h4>
				</div>
				<div class="modal-body">
					<div style="position: relative; left: 40px;">
						姓名：<b>张三</b><br><br>
						登录帐号：<b>zhangsan</b><br><br>
						组织机构：<b>1005，市场部，二级部门</b><br><br>
						邮箱：<b>zhangsan@bjpowernode.com</b><br><br>
						失效时间：<b>2017-02-14 10:10:10</b><br><br>
						允许访问IP：<b>127.0.0.1,192.168.100.2</b>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改密码的模态窗口 -->
	<div class="modal fade" id="editPwdModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 70%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改密码</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<div class="form-group">
							<label for="oldPwd" class="col-sm-2 control-label">原密码</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="oldPwd" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="newPwd" class="col-sm-2 control-label">新密码</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="newPwd" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="confirmPwd" class="col-sm-2 control-label">确认密码</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="confirmPwd" style="width: 200%;">
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal" onclick="window.location.href='login.jsp';">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 退出系统的模态窗口 -->
	<div class="modal fade" id="exitModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">离开</h4>
				</div>
				<div class="modal-body">
					<p>您确定要退出系统吗？</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal" onclick="window.location.href='login.jsp';">确定</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 顶部 -->
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2017&nbsp;动力节点</span></div>
		<div style="position: absolute; top: 15px; right: 15px;">
			<ul>
				<li class="dropdown user-dropdown">
					<a href="javascript:void(0)" style="text-decoration: none; color: white;" class="dropdown-toggle" data-toggle="dropdown">
						<span class="glyphicon glyphicon-user"></span> zhangsan <span class="caret"></span>
					</a>
					<ul class="dropdown-menu">
						<li><a href="workbench/index.html"><span class="glyphicon glyphicon-home"></span> 工作台</a></li>
						<li><a href="index.html"><span class="glyphicon glyphicon-wrench"></span> 系统设置</a></li>
						<li><a href="javascript:void(0)" data-toggle="modal" data-target="#myInformation"><span class="glyphicon glyphicon-file"></span> 我的资料</a></li>
						<li><a href="javascript:void(0)" data-toggle="modal" data-target="#editPwdModal"><span class="glyphicon glyphicon-edit"></span> 修改密码</a></li>
						<li><a href="javascript:void(0);" data-toggle="modal" data-target="#exitModal"><span class="glyphicon glyphicon-off"></span> 退出</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</div>
	
	<!-- 创建部门的模态窗口 -->
	<div class="modal fade" id="createDeptModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel"><span class="glyphicon glyphicon-plus"></span> 新增部门</h4>
				</div>
				<div class="modal-body">
				
					<form id="createDept" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-code" class="col-sm-2 control-label">编号<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="deptNo" style="width: 200%;" placeholder="编号为四位数字，不能为空，具有唯一性">
								<span id="deptNoErrorMsg" style="color: red;font-size: 12px"></span>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-name" class="col-sm-2 control-label">名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="name" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-manager" class="col-sm-2 control-label">负责人</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="leader" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">电话</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="phone" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 55%;">
								<textarea class="form-control" rows="3" id="description"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" id="closeCreateBtn">关闭</button>
					<button type="button" class="btn btn-primary" id="saveCreateBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改部门的模态窗口 -->
	<div class="modal fade" id="editDeptModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel"><span class="glyphicon glyphicon-edit"></span> 编辑部门</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
						<input type="hidden" id="oldDeptNo">
						<div class="form-group">
							<label for="create-code" class="col-sm-2 control-label">编号<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="eDeptNo"  style="width: 200%;" placeholder="编号为四位数字，不能为空，具有唯一性" value="1110">
								<span id="eDeptNoErrorMsg" style="color: red;font-size: 12px"></span>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-name" class="col-sm-2 control-label">名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="eName" style="width: 200%;" value="财务部">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-manager" class="col-sm-2 control-label">负责人</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="eLeader" style="width: 200%;" value="张飞">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">电话</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="ePhone" style="width: 200%;" value="010-84846004">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 55%;">
								<textarea class="form-control" rows="3" id="eDescription">description info</textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" id="closeEditBtn" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="doUpdateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<div style="width: 95%">
		<div>
			<div style="position: relative; left: 30px; top: -10px;">
				<div class="page-header">
					<h3>部门列表</h3>
				</div>
			</div>
		</div>
		<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px; top:-30px;">
			<div class="btn-group" style="position: relative; top: 18%;">
			  <button type="button" class="btn btn-primary" id="openCreateModalBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
			  <button type="button" class="btn btn-default" id="openEditModalBtn" ><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			  <button type="button" class="btn btn-danger" id="DeleteBtn" ><span class="glyphicon glyphicon-minus"></span> 删除</button>
			</div>
		</div>
		<div style="position: relative; left: 30px; top: -10px;">
			<table class="table table-hover">
				<thead>
					<tr style="color: #B3B3B3;">
						<td><input type="checkbox" id="qx"></td>
						<td>编号</td>
						<td>名称</td>
						<td>负责人</td>
						<td>电话</td>
						<td>描述</td>
					</tr>
				</thead>
				<tbody id="tBody">
					<%--<tr class="active">
						<td><input type="checkbox" /></td>
						<td>1110</td>
						<td>财务部</td>
						<td>张飞</td>
						<td>010-84846005</td>
						<td>description info</td>
					</tr>
					<tr>
						<td><input type="checkbox" /></td>
						<td>1120</td>
						<td>销售部</td>
						<td>关羽</td>
						<td>010-84846006</td>
						<td>description info</td>
					</tr>--%>
				</tbody>
			</table>
		</div>
		
		<div style="height: 50px; position: relative;top: 0px; left:30px;">
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
						<li><a href="#">下一页</a></li>
						<li class="disabled"><a href="#">末页</a></li>
					</ul>
				</nav>
			</div>
		</div>
			
	</div>
	
</body>
</html>