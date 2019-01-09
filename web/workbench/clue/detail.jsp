<%@ page import="com.wkcto.crm.utils.DateUtil" %>
<%@page contentType="text/html; charset=utf-8" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">


	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		$("body").on("mouseover",".remarkDiv",function () {
            $(this).children("div").children("div").show();
        });
		$("body").on("mouseout",".remarkDiv",function () {
            $(this).children("div").children("div").hide();
        });
        displayRemark();
        $("#saveRemarkBtn").click(function () {
            if ($("#remark").val() == ""){
                alert("备注内容不能为空");
            } else {
				$.post(
					"workbench/clue/remarkSave.do",
					{
						"clueId":"${map.id}",
						"noteContent":$("#remark").val(),
						"createBy":"${user.name}",
						"createTime":"<%=DateUtil.getSysTime()%>",
						"editFlag":"0"
					},
					function (json) {
						if (json.success){
							$("#remark").val("");
							var html = "";
							html += '<div class="remarkDiv" style="height: 60px;" id='+json.clueRemark.id+'>';
							html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
							html += '<div style="position: relative; top: -40px; left: 40px;" >';
							html += '<h5 id=e-'+json.clueRemark.id+'>'+json.clueRemark.noteContent+'</h5>';
							html += '<font color="gray">线索</font> <font color="gray">-</font> <b>${map.fullname}${map.appellation}-${map.company}</b> <small style="color: gray;" id=s-'+json.clueRemark.id+'> '+(json.clueRemark.createTime)+'由'+(json.clueRemark.createBy)+'</small>';
							html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
							html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+json.clueRemark.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: red;"></span></a>';
							html += '&nbsp;&nbsp;&nbsp;&nbsp;';
							html += '<a class="myHref" href="javascript:void(0);" onclick="delById(\''+json.clueRemark.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: red;"></span></a>';
							html += '</div>';
							html += '</div>';
							html += '</div>';
							$("#remarkDiv").before(html);
						}
					}
				)
			}
        });
        displayActivity();
        $("#relationActivityBtn").click(function () {
            $("#queryActivityForm")[0].reset();
            $("#h-queryActivity").val($("#queryActivity").val());
            getNeverRelationActivity();
            $("#bundModal").modal("show");
        });
        $("#relationBtn").click(function () {
			var $xz = $(":checkbox[name='id']:checked");
			if ($xz.length == 0){
			    alert("请选择要关联的市场活动");
			} else {
				var sendData = "clueId=${map.id}";
			    for(var i = 0;i < $xz.length;i++){
			        sendData += "&activityId="+ $xz[i].value;
				}
				$.ajax({
					type:"post",
					url:"workbench/clue/relationClueAndActivity.do",
					data:sendData,
					success:function (json) {
                        if (json.success) {
                            $("#bundModal").modal("hide");
                            displayActivity();
                        }
                    }
				});
			}
        });

        $("#qx").click(function () {
			$(":checkbox[name='id']").prop("checked",this.checked);
			$("#tBody1").on("click",":checkbox[name='id']",function () {
                $("#qx").prop("checked",$(":checkbox[name='id']").size() == $(":checkbox[name='id']:checked").size());
            })
        });
        $("#queryActivity").keydown(function (event) {
            if (event.keyCode == 13){
			   $("#h-queryActivity").val(this.value);
			   getNeverRelationActivity();
			   return false;//阻止事件冒泡
            }
        });
        $("#c-sendEmailBtn").click(function () {
            $("#sendEMailForm")[0].reset();
            $("#internetAddress").val("${map.email}");
			$("#sendEmailModal").modal("show");
			$("#sendEmailBtn").click(function () {
                $.post(
                    "workbench/clue/sendEmail.do",
                    {
                        "internetAddress":$("#internetAddress").val(),
                        "subject":$("#subject").val(),
                        "message":$("#message").val()
                    },
                    function (json) {
                        if (json.success){
                            alert("发送成功");
                            $("#sendEmailModal").modal("hide");
                        }
                    }
                )
            });
        });
	});
	function getNeverRelationActivity() {
        $("#tBody1").html("");
        $.get(
            "workbench/clue/getNeverRelationActivity.do",
            {
                "clueId":"${map.id}",
                "name":$("#h-queryActivity").val()
            },
            function (json) {
                var html = "";
                $.each(json,function (i,n) {
                    html += "<tr>";
                    html += "<td><input type='checkbox' name='id' value='"+n.id+"'></td>";
                    html += "<td>"+n.name+"</td>";
                    html += "<td>"+n.startTime+"</td>";
                    html += "<td>"+n.endTime+"</td>";
                    html += "<td>"+n.owner+"</td>";
                    html += "</tr>";
                });
                $("#tBody1").html(html);
            }
        )
    }
	function displayActivity() {
        $.ajaxSetup({
            async:false
        });
		$.get(
		    "workbench/clue/getActivity.do",
			{
			    "clueId":"${map.id}",
				"_":new Date().getTime()
			},
			function (json) {
				var html = "";
				$.each(json,function (i,n) {
						html += "<tr id="+n.rId+">";
						html += "<td><a href='workbench/activity/detail.do?id="+n.id+"' style='text-decoration: none;'>"+n.name+"</a></td>";
						html += "<td>"+n.startTime+"</td>";
						html += "<td>"+n.endTime+"</td>";
						html += "<td>"+n.owner+"</td>";
						html += "<td><a href='javascript:void(0);' onclick=\"dissociated(\'"+n.rId+"\')\"  style='text-decoration: none;'><span class='glyphicon glyphicon-remove'></span>解除关联</a></td>";
						html += "</tr>";
                });
				$("#tBody").html(html);
                $.ajaxSetup({
                    async:true
                });
            }
		)
    }
    function dissociated(id) {
		$("#unbundModal").modal("show");
		$("#delActivityBtn").click(function () {
			$.post(
				"workbench/clue/dissociated.do",
				{"id":id},
				function (json) {
					if (json.success){
                        $("#unbundModal").modal("hide");
						$("#" + id).remove();
					}
				}
			)
		});
    }
	function delById(id) {
		if (confirm("确定删除吗?")) {
            $.post(
                "workbench/clue/deleteRemark.do",
                {"id": id},
                function (json) {
                    if (json.success) {
                        $("#" + id).remove();
                    } else {
                        alert("删除失败");
                    }
                }
            )
        }
    }
	function editRemark(id) {
        $("#editClueRemarkModal").modal("show");
        $("#e-noteContent").val($("#e-"+id).text());
        $("#updateRemarkBtn").click(function () {
            if ($("#e-noteContent").val() == ""){
                alert("备注内容不能为空");
            } else {
                $.post(
                    "workbench/clue/updateRemark.do",
                    {
                        "id":id,
                        "noteContent":$.trim($("#e-noteContent").val()),
                        "editBy" : "${user.name}",
                        "editTime":"<%=DateUtil.getSysTime()%>",
                        "editFlag":"1"
                    },
                    function (json) {
                        if (json.success){
                            $("#editClueRemarkModal").modal("hide");

                            $("#e-"+id).text(json.noteContent);
                            $("#s-"+id).text(json.editTime + "由" + json.editBy);
                        } else {
                            alert("更新失败");
                        }
                    }
                )
            }
        });
    }
    function displayRemark() {
        $.ajaxSetup({
            async:false
        });
        $.get(
            "workbench/clue/getRemarkList.do",
            {
                "clueId":"${map.id}",
				"_":new Date().getTime()
			},
            function (json) {
                var html = "";
                $.each(json,function (i,n) {
                    html += '<div class="remarkDiv" style="height: 60px;" id='+n.id+'>';
                    html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                    html += '<div style="position: relative; top: -40px; left: 40px;" >';
                    html += '<h5 id=e-'+n.id+'>'+n.noteContent+'</h5>';
                    html += '<font color="gray">线索</font> <font color="gray">-</font> <b>${map.fullname}${map.appellation}-${map.company}</b> <small style="color: gray;" id=s-'+n.id+'> '+(n.editFlag==1?n.editTime:n.createTime)+'由'+(n.editFlag==1?n.editBy:n.createBy)+'</small>';
                    html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                    html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: red;"></span></a>';
                    html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                    html += '<a class="myHref" href="javascript:void(0);" onclick="delById(\''+n.id+'\')" ><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: red;"></span></a>';
                    html += '</div>';
                    html += '</div>';
                    html += '</div>';
                });
                $("#remarkDiv").before(html);
                $.ajaxSetup({
                    async:true
                });
            }
        )
    }
</script>

</head>
<body>
<input type="hidden" id="h-queryActivity">
	<!-- 解除关联的模态窗口 -->
	<div class="modal fade" id="unbundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">解除关联</h4>
				</div>
				<div class="modal-body">
					<p>您确定要解除该关联关系吗？</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-danger" id="delActivityBtn">确定</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form" id="queryActivityForm">
						  <div class="form-group has-feedback">
						        <input type="text" class="form-control" id="queryActivity" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input type="checkbox" id="qx"></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="tBody1">
							<%--<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="relationBtn">关联</button>
				</div>
			</div>
		</div>
	</div>

<!-- 发送邮件的模态窗口 -->
<div class="modal fade" id="sendEmailModal" role="dialog">
	<div class="modal-dialog" role="document" style="width: 45%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title" id="myModalLabel1">发送邮件</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal" role="form" id="sendEMailForm">
					<div class="form-group">
						<label for="edit-describe" class="col-sm-2 control-label">收件人</label>
						<input type="text" class="form-control" id="internetAddress" style="width: 300px;" >
					</div>
					<div class="form-group">
						<label for="edit-describe" class="col-sm-2 control-label">主题</label>
						<input type="text" class="form-control" id="subject" style="width: 300px;" >
					</div>
					<div class="form-group">
						<label for="edit-describe" class="col-sm-2 control-label">内容</label>
						<div class="col-sm-10" style="width: 81%;">
							<textarea class="form-control" rows="3" id="message"></textarea>
						</div>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" class="btn btn-primary" id="sendEmailBtn">发送</button>
			</div>
		</div>
	</div>
</div>
    <!-- 修改线索备注的模态窗口 -->
    <div class="modal fade" id="editClueRemarkModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 45%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改备注</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form">
                        <div class="form-group">
                            <label for="edit-describe" class="col-sm-2 control-label">内容</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="e-noteContent"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${map.fullname}${map.appellation} <small>${map.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" id="c-sendEmailBtn"><span class="glyphicon glyphicon-envelope"></span> 发送邮件</button>
			<button type="button" class="btn btn-default" onclick="window.location.href='workbench/clue/convert.jsp?fullname=${map.fullname}&appellation=${map.appellation}&company=${map.company}&owner=${map.ownerName}&clueId=${map.id}';"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
			<button type="button" class="btn btn-default" data-toggle="modal" data-target="#editClueModal"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${map.fullname}${map.appellation}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${map.ownerName}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${map.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${map.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${map.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${map.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${map.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${map.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${map.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${map.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${map.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${map.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${map.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${map.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${map.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${map.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${map.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${map.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 40px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<!-- 备注1 -->
		<%--<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>
		
		<!-- 备注2 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>呵呵！</h5>
				<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary" id="saveRemarkBtn">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="tBody">
						<%--<tr>
							<td>发传单</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);" data-toggle="modal" data-target="#unbundModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>
						<tr>
							<td>发传单</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);" data-toggle="modal" data-target="#unbundModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" id="relationActivityBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>