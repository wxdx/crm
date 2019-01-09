<%@ page import="com.wkcto.crm.utils.UUIDGenerator" %>
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
        $("body").on("mouseover",".remarkDiv",function(){
            $(this).children("div").children("div").show();
        });
        $("body").on("mouseout",".remarkDiv",function(){
            $(this).children("div").children("div").hide();
        });

        displayRemark();
        $("#saveRemarkBtn").click(function () {
            if ($("#remark").val() == ""){
                alert("备注内容不能为空");
            }
           $.post(
               "workbench/activity/remarkSave.do",
               {
                   "id":"<%=UUIDGenerator.generate()%>",
                   "activityId":"${map.id}",
                   "noteContent":$("#remark").val(),
                   "createBy":"${user.name}",
                   "createTime":"<%=DateUtil.getSysTime()%>",
                   "editBy" : "",
                   "editTime":"",
                   "editFlag":"0"
               },
               function (json) {
                   if (json.success){
                       $("#remark").val("");
                       var html = "";
                       html += '<div class="remarkDiv" style="height: 60px;" id='+json.activityRemark.id+'>';
                       html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                       html += '<div style="position: relative; top: -40px; left: 40px;" >';
                       html += '<h5 id=e-'+json.activityRemark.id+'>'+json.activityRemark.noteContent+'</h5>';
                       html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${map.name}</b> <small style="color: gray;" id=s-'+json.activityRemark.id+'> '+(json.activityRemark.createTime)+'由'+(json.activityRemark.createBy)+'</small>';
                       html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                       html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+json.activityRemark.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: red;"></span></a>';
                       html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                       html += '<a class="myHref" href="javascript:void(0);" onclick="delById(\''+json.activityRemark.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: red;"></span></a>';
                       html += '</div>';
                       html += '</div>';
                       html += '</div>';
                       $("#remarkDiv").before(html);
                   }
               }
           )
        });
	});
	function displayRemark() {
		$.get(
		    "workbench/activity/getRemarkList.do",
			{"activityId":"${map.id}"},
			function (json) {
		        var html = "";
                $.each(json,function (i,n) {
                    html += '<div class="remarkDiv" style="height: 60px;" id='+n.id+'>';
                    html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                    html += '<div style="position: relative; top: -40px; left: 40px;" >';
                    html += '<h5 id=e-'+n.id+'>'+n.noteContent+'</h5>';
                    html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${map.name}</b> <small style="color: gray;" id=s-'+n.id+'> '+(n.editFlag==1?n.editTime:n.createTime)+'由'+(n.editFlag==1?n.editBy:n.createBy)+'</small>';
                    html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                    html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: red;"></span></a>';
                    html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                    html += '<a class="myHref" href="javascript:void(0);" onclick="delById(\''+n.id+'\')" ><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: red;"></span></a>';
                    html += '</div>';
                    html += '</div>';
                    html += '</div>';
                });
                $("#remarkDiv").before(html);
            }
		)
    }
    function delById(id) {
        if (confirm("你确定删除吗")){
            $.post(
                "workbench/activity/deleteRemark.do",
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
        $("#editActivityRemarkModal").modal("show");
        $("#e-noteContent").val($("#e-"+id).text());
        $("#updateRemarkBtn").click(function () {
            if ($("#e-noteContent").val() == ""){
                alert("备注内容不能为空");
            } else {
                $.post(
                    "workbench/activity/updateRemark.do",
                    {
                        "id":id,
                        "noteContent":$.trim($("#e-noteContent").val()),
                        "editBy" : "${user.name}",
                        "editTime":"<%=DateUtil.getSysTime()%>",
                        "editFlag":"1"
                    },
                    function (json) {
                        if (json.success){
                            $("#editActivityRemarkModal").modal("hide");

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

</script>

</head>
<body>

    <!-- 修改市场活动备注的模态窗口 -->
    <div class="modal fade" id="editActivityRemarkModal" role="dialog">
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
                            <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="e-noteContent"></textarea>
                            </div>
                        </div>

                    </form>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary"id="updateRemarkBtn">更新</button>
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
			<h3>市场活动-${map.name} <small>${map.startTime} ~ ${map.endTime}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" data-toggle="modal" data-target="#editActivityModal"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${map.ownerName}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${map.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${map.startTime}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${map.endTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${map.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${map.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${map.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${map.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${map.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${map.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 30px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<%--<!-- 备注1 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
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
				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>
		--%>
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
	<div style="height: 200px;"></div>
</body>
</html>