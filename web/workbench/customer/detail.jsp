<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html; charset=utf-8" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">


	<!-- jquery -->
	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<!-- bootstrap 3-->
	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<!-- bootstrap datetimepicker-->
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

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
        $(".time").datetimepicker({
            minView: "month",
            language:  'zh-CN',
            format: 'yyyy-mm-dd',
            autoclose: true,
            todayBtn: true,
            clearBtn: true,
            pickerPosition: "top-right"
        });
        $(".time1").datetimepicker({
            minView: "month",
            language:  'zh-CN',
            format: 'yyyy-mm-dd',
            autoclose: true,
            todayBtn: true,
            clearBtn: true,
            pickerPosition: "bottom-left"
        });
        displayRemark();
        displayContact();
        displayTran();
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
        $("#saveRemarkBtn").click(function () {
            if ($("#remark").val() == ""){
                alert("备注内容不能为空");
            } else {
                $.post(
                    "workbench/customer/remarkSave.do",
                    {
                        "customerId":"${map.id}",
                        "noteContent":$("#remark").val(),
                        "createBy":"${user.name}",
                        "editFlag":"0"
                    },
                    function (json) {
                        if (json.success){
                            $("#remark").val("");
                            var html = "";
                            html += '<div class="remarkDiv" style="height: 60px;" id='+json.customerRemark.id+'>';
                            html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                            html += '<div style="position: relative; top: -40px; left: 40px;" >';
                            html += '<h5 id=e-'+json.customerRemark.id+'>'+json.customerRemark.noteContent+'</h5>';
                            html += '<font color="gray">客户</font> <font color="gray">-</font> <b>${map.name}</b> <small style="color: gray;" id=s-'+json.customerRemark.id+'> '+(json.customerRemark.createTime)+'由'+(json.customerRemark.createBy)+'</small>';
                            html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                            html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+json.customerRemark.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: red;"></span></a>';
                            html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                            html += '<a class="myHref" href="javascript:void(0);" onclick="delById(\''+json.customerRemark.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: red;"></span></a>';
                            html += '</div>';
                            html += '</div>';
                            html += '</div>';
                            $("#remarkDiv").before(html);
                        }
                    }
                )
            }
        });
        $("#newContactBtn").click(function () {
            $("#c-contactForm")[0].reset();
            $("#c-customerName").val("${map.name}");
            $.ajaxSetup({
                async:false
            });
            $.get(
                "workbench/clue/getAllUser.do",
                function (json) {
                    $("#c-owner").html("<option value=\"\"></option>");
                    $(json).each(function () {
                        $("#c-owner").append("<option value='"+this.id+"' "+(this.id == "${user.id}"?"selected":"")+">"+this.name+"</option>");
                    });
                    $.ajaxSetup({
                        async:true
                    });
                }
            );
            $("#createContactsModal").modal("show");
        });
        $("#c-name").blur(function () {
			if (this.value == ""){
			    $("#c-nameErrorMsg").text("姓名不能为空");
			}
        });
        $("#c-name").focus(function () {
            if ($("#c-nameErrorMsg").text() != ""){
                this.value = "";
			}
			$("#c-nameErrorMsg").text("");
        });
		$("#saveContactBtn").click(function () {
			$("#c-name").blur();
			if ($("#c-nameErrorMsg").text() == ""){
			    $.post(
			        "workbench/contact/save.do",
					{
                        "owner" : $.trim($("#c-owner").val()),
                        "source" : $.trim($("#c-source").val()),
                        "appellation" : $.trim($("#c-appellation").val()),
                        "name" : $.trim($("#c-name").val()),
                        "job" : $.trim($("#c-job").val()),
                        "mphone" : $.trim($("#c-mphone").val()),
                        "email" : $.trim($("#c-email").val()),
                        "birth" : $.trim($("#c-birth").val()),
                        "customerId" : "${map.id}",
                        "description" : $.trim($("#c-description").val()),
                        "contactSummary" : $.trim($("#c-contactSummary").val()),
                        "nextContactTime" : $.trim($("#c-nextContactTime").val()),
                        "address" : $.trim($("#c-address").val()),
                        "createBy" : "${user.name}"

                    },
					function (json) {
						if (json.success){
                            $("#createContactsModal").modal("hide");
                            displayContact();
						}
                    }
				)
			}
        });

	});
	function displayTran() {
        $.ajaxSetup({
            async:false
        });
		$("#tran-tBody").html("");
		$.get(
		    "workbench/tran/getTranByCustomerId.do",
			{
			    "customerId":"${map.id}",
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
	function displayContact() {
        $.ajaxSetup({
            async:false
        });
        $("#contact-tBody").html("");
	    $.get(
	        "workbench/customer/getContact.do",
			{
			    "customerId":"${map.id}",
				"_":new Date().getTime()
			},
			function (json) {
                var html = "";
                $.each(json,function (i,n) {
					html += "<tr id="+n.id+">";
                    html += "<td><a href='workbench/contact/detail.do?id="+n.id+"' style='text-decoration: none;'>"+n.name+"</a></td>";
                    html += "<td>"+n.email+"</td>";
                    html += "<td>"+n.mphone+"</td>";
                    html += "<td><a href='javascript:void(0);' onclick=\"delContactById(\'"+n.id+"\')\" style='text-decoration: none;'><span class='glyphicon glyphicon-remove'></span>删除</a></td>";
                    html += "</tr>";
                });
                $("#contact-tBody").html(html);
                $.ajaxSetup({
                    async:true
                });
            }


		)
    }
    function delContactById(id) {
		$("#removeContactsModal").modal("show");
		$("#delContactBtn").click(function () {
			$.post(
			    "workbench/customer/delContact.do",
				{"id":id},
				function (json) {
					if (json.success){
                        $("#removeContactsModal").modal("hide");
                        $("#" + id).remove();
					} else {
					    alert("删除联系人失败");
					}
                }
			)
        });
    }
    function delById(id) {
        if (confirm("你确定删除吗")){
            $.post(
                "workbench/customer/deleteRemark.do",
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
        $("#editCustomerRemarkModal").modal("show");
        $("#e-noteContent").val($("#e-"+id).text());
        $("#updateRemarkBtn").click(function () {
            if ($("#e-noteContent").val() == ""){
                alert("备注内容不能为空");
            } else {
                $.post(
                    "workbench/customer/updateRemark.do",
                    {
                        "id":id,
                        "noteContent":$.trim($("#e-noteContent").val()),
                        "editBy" : "${user.name}",
                        "editFlag":"1"
                    },
                    function (json) {
                        if (json.success){
                            $("#editCustomerRemarkModal").modal("hide");

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
            "workbench/customer/getRemarkList.do",
			{
			    "customerId" : "${map.id}",
				"_":new Date().getTime()
			},
            function (json) {
                var html = "";
                $.each(json,function (i,n) {
                    html += '<div class="remarkDiv" style="height: 60px;" id='+n.id+'>';
                    html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                    html += '<div style="position: relative; top: -40px; left: 40px;" >';
                    html += '<h5 id=e-'+n.id+'>'+n.noteContent+'</h5>';
                    html += '<font color="gray">客户</font> <font color="gray">-</font> <b>${map.name}</b> <small style="color: gray;" id=s-'+n.id+'> '+(n.editFlag==1?n.editTime:n.createTime)+'由'+(n.editFlag==1?n.editBy:n.createBy)+'</small>';
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
	<input type="hidden" id="h-customerId">
	<!-- 删除联系人的模态窗口 -->
	<div class="modal fade" id="removeContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">删除联系人</h4>
				</div>
				<div class="modal-body">
					<p>您确定要删除该联系人吗？</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-danger" id="delContactBtn">删除</button>
				</div>
			</div>
		</div>
	</div>

    <!-- 删除交易的模态窗口 -->
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
	
	<!-- 创建联系人的模态窗口 -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="c-contactForm">
					
						<div class="form-group">
							<label for="create-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="c-owner">
								</select>
							</div>
							<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="c-source">
								  <option value=""></option>
								  <c:forEach items="${sourceList}" var="s">
									  <option value="${s.value}">${s.text}</option>
								  </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="c-name">
								<span id="c-nameErrorMsg" style="color: red;font-size: 12px"></span>
							</div>
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="c-appellation">
								  <option value=""></option>
									<c:forEach items="${appellationList}" var="s">
										<option value="${s.value}">${s.text}</option>
									</c:forEach>
								</select>
							</div>
							
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="c-job">
							</div>
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="c-mphone">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="c-email">
							</div>
							<label for="create-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time1" id="c-birth">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="c-customerName" value="${map.name}" disabled>
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="c-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="c-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control time" id="c-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address1" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="c-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveContactBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改客户备注的模态窗口 -->
    <div class="modal fade" id="editCustomerRemarkModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改备注</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form" >

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
			<h3>${map.name} <small><a href="http://${map.website}" target="_blank">${map.website}</a></small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" data-toggle="modal" data-target="#editCustomerModal"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${map.ownerName}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>&nbsp;${map.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${map.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>&nbsp;${map.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${map.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">&nbsp;${map.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${map.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">&nbsp;${map.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 40px;">
            <div style="width: 300px; color: gray;">联系纪要</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
					&nbsp;${map.contactSummary}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
        <div style="position: relative; left: 40px; height: 30px; top: 50px;">
            <div style="width: 300px; color: gray;">下次联系时间</div>
            <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${map.nextContactTime}</b></div>
            <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
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
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
					&nbsp;${map.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 10px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<!-- 备注1 -->
		<%--<div class="remarkDiv" style="height: 60px;">
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
				<table id="activityTable2" class="table table-hover" style="width: 900px;">
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
							<td><a href="javascript:void(0);" data-toggle="modal" data-target="#removeTransactionModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="workbench/transaction/save.jsp" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建交易</a>
			</div>
		</div>
	</div>
	
	<!-- 联系人 -->
	<div>
		<div style="position: relative; top: 20px; left: 40px;">
			<div class="page-header">
				<h4>联系人</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>邮箱</td>
							<td>手机</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="contact-tBody">
						<%--<tr>
							<td><a href="workbench/contacts/detail.jsp" style="text-decoration: none;">李四</a></td>
							<td>lisi@bjpowernode.com</td>
							<td>13543645364</td>
							<td><a href="javascript:void(0);" data-toggle="modal" data-target="#removeContactsModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" id="newContactBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建联系人</a>
			</div>
		</div>
	</div>
	
	<div style="height: 200px;"></div>
</body>
</html>