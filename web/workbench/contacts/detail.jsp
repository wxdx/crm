<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
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
    var possibilityJson={
        <%
           Map<String,String> possibilityMap = (Map<String,String>)application.getAttribute("possibilityMap");
           Set<String> keys = possibilityMap.keySet();
           int i = 0;
           for(String key:keys){
               String value = possibilityMap.get(key);
               if (i < keys.size() - 1){
        %>
        "<%=key%>":<%=value%>,
        <%
               } else {
        %>
        "<%=key%>":<%=value%>
        <%
               }
               i++;
           }
         %>
    };
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
        displayTran();
        $("#saveRemarkBtn").click(function () {
            if ($("#remark").val() == ""){
                alert("备注内容不能为空");
            } else {
                $.post(
                    "workbench/contact/remarkSave.do",
                    {
                        "contactId":"${map.id}",
                        "noteContent":$("#remark").val(),
                        "createBy":"${user.name}",
                        "editFlag":"0"
                    },
                    function (json) {
                        if (json.success){
                            $("#remark").val("");
                            var html = "";
                            html += '<div class="remarkDiv" style="height: 60px;" id='+json.contactRemark.id+'>';
                            html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                            html += '<div style="position: relative; top: -40px; left: 40px;" >';
                            html += '<h5 id=e-'+json.contactRemark.id+'>'+json.contactRemark.noteContent+'</h5>';
                            html += '<font color="gray">联系人</font> <font color="gray">-</font> <b>${map.name}</b> <small style="color: gray;" id=s-'+json.contactRemark.id+'> '+(json.contactRemark.createTime)+'由'+(json.contactRemark.createBy)+'</small>';
                            html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                            html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+json.contactRemark.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: red;"></span></a>';
                            html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                            html += '<a class="myHref" href="javascript:void(0);" onclick="delById(\''+json.contactRemark.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: red;"></span></a>';
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
                var sendData = "contactId=${map.id}";
                for(var i = 0;i < $xz.length;i++){
                    sendData += "&activityId="+ $xz[i].value;
                }
                $.ajax({
                    type:"post",
                    url:"workbench/contact/relationClueAndActivity.do",
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
	});
    function getNeverRelationActivity() {
        $("#tBody1").html("");
        $.get(
            "workbench/contact/getNeverRelationActivity.do",
            {
                "contactId":"${map.id}",
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
            "workbench/contact/getActivity.do",
            {
                "contactId":"${map.id}",
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
                "workbench/contact/dissociated.do",
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
    function displayTran() {
        $.ajaxSetup({
            async:false
        });
        $("#tran-tBody").html("");
        $.get(
            "workbench/tran/getTranByContactsId.do",
            {
                "contactId":"${map.id}",
                "_":new Date().getTime()
            },
            function (json) {
                var html = "";
                $.each(json,function (i,n) {
                    html += '<tr id="'+n.id+'">';
                    html += '<td><a href="workbench/transaction/detail.jsp" style="text-decoration: none;">'+n.companyName+'-'+n.name+'</a></td>';
                    html += '<td>'+n.money+'</td>';
                    html += '<td>'+n.stage+'</td>';
                    html += '<td>'+possibilityJson[n.stage]+'</td>';
                    html += '<td>'+n.expectedDate+'</td>';
                    html += '<td>'+n.type+'</td>';
                    html += '<td><a href="javascript:void(0);" onclick="delTranById(\''+n.id+'\')" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>';
                    html += '</tr>';
                });
                $("#tran-tBody").html(html);
                $.ajaxSetup({
                    async:true
                });
            }
        )
    }
    function delTranById(id) {
        $("#removeTransactionModal").modal("show");
        $("#delTranBtn").click(function () {
            $.post(
                "workbench/tran/delTran.do",
                {"id":id},
                function (json) {
                    if (json.success){
                        $("#removeTransactionModal").modal("hide");
                        $("#" + id).remove();
                    } else {
                        alert("删除交易失败");
                    }
                }
            )
        });
    }
    function delById(id) {
        if (confirm("你确定删除吗")){
            $.post(
                "workbench/contact/deleteRemark.do",
                {"id":id},
                function (json) {
                    if (json.success){
                        $("#"+id).remove();
                    } else {
                        alert("删除失败");
                    }
                }
            )
        }
    }
    function editRemark(id) {
        $("#editContactRemarkModal").modal("show");
        $("#e-noteContent").val($("#e-"+id).text());
        $("#remarkUpdateBtn").click(function () {
            if ($("#e-noteContent").val() == ""){
                alert("备注内容不能为空");
            } else {
                $.post(
                    "workbench/contact/updateRemark.do",
                    {
                        "id":id,
                        "noteContent":$.trim($("#e-noteContent").val()),
                        "editBy" : "${user.name}",
                        "editFlag":"1"
                    },
                    function (json) {
                        if (json.success){
                            $("#editContactRemarkModal").modal("hide");

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
            "workbench/contact/getRemarkList.do",
            {
                "contactId" : "${map.id}",
                "_":new Date().getTime()
            },
            function (json) {
                var html = "";
                $.each(json,function (i,n) {
                    html += '<div class="remarkDiv" style="height: 60px;" id='+n.id+'>';
                    html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                    html += '<div style="position: relative; top: -40px; left: 40px;" >';
                    html += '<h5 id=e-'+n.id+'>'+n.noteContent+'</h5>';
                    html += '<font color="gray">联系人</font> <font color="gray">-</font> <b>${map.name}</b> <small style="color: gray;" id=s-'+n.id+'> '+(n.editFlag==1?n.editTime:n.createTime)+'由'+(n.editFlag==1?n.editBy:n.createBy)+'</small>';
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
	<!-- 解除联系人和市场活动关联的模态窗口 -->
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
					<button type="button" class="btn btn-danger" id="delActivityBtn">解除</button>
				</div>
			</div>
		</div>
	</div>

	<!--删除交易模态窗口-->
	<div class="modal fade" id="removeTransactionModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">删除交易</h4>
				</div>
				<div class="modal-body">
					<p>您确定要删除该交易吗？</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-danger" id="delTranBtn">删除</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 联系人和市场活动关联的模态窗口 -->
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
					<table id="activityTable2" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input type="checkbox"/></td>
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
	
	<!-- 修改联系人备注的模态窗口 -->
	<div class="modal fade" id="editContactRemarkModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改联系人备注</h4>
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
					<button type="button" class="btn btn-primary" id="remarkUpdateBtn">更新</button>
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
			<h3>${map.name}${map.appellation} <small> - ${map.customerName}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" data-toggle="modal" data-target="#editContactsModal"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${map.ownerName}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>&nbsp;${map.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${map.customerName}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">姓名</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>&nbsp;${map.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${map.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>&nbsp;${map.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${map.job}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">生日</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${map.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${map.createTime}&nbsp;</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${map.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${map.editTime}&nbsp;</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					&nbsp;${map.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					&nbsp;${map.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${map.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 90px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
					&nbsp; ${map.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	<!-- 备注 -->
	<div style="position: relative; top: 20px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<%--<!-- 备注1 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">联系人</font> <font color="gray">-</font> <b>李四先生-北京动力节点</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
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
				<font color="gray">联系人</font> <font color="gray">-</font> <b>李四先生-北京动力节点</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
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
	
	<!-- 交易 -->
	<div>
		<div style="position: relative; top: 20px; left: 40px;">
			<div class="page-header">
				<h4>交易</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable3" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>金额</td>
							<td>阶段</td>
							<td>可能性</td>
							<td>预计成交日期</td>
							<td>类型</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="tran-tBody">
						<%--<tr>
							<td><a href="workbench/transaction/detail.jsp" style="text-decoration: none;">动力节点-交易01</a></td>
							<td>5,000</td>
							<td>谈判/复审</td>
							<td>90</td>
							<td>2017-02-07</td>
							<td>新业务</td>
							<td><a href="javascript:void(0);" data-toggle="modal" data-target="#unbundModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="workbench/transaction/save.jsp" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建交易</a>
			</div>
		</div>
	</div>
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
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
							<td><a href="workbench/activity/detail.jsp" style="text-decoration: none;">发传单</a></td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);" data-toggle="modal" data-target="#unbundActivityModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
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