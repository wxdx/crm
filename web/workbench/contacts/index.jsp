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
	<!-- bootstrap pagination-->
	<link href="jquery/bootstrap_pagination/jquery.bs_pagination.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="jquery/bootstrap_pagination/jquery.bs_pagination.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_pagination/en.js"></script>
	<!-- bootstrap typeahead -->
	<script type="text/javascript" src="jquery/bootstrap-typeahead/bootstrap3-typeahead.js"></script>
	<!-- bootstrap growl-->
	<script type="text/javascript" src="jquery/bootstrap-growl-master/jquery.bootstrap-growl.js"></script>

	<script type="text/javascript" src="js/Source.js"></script>

<script type="text/javascript">

	$(function(){
		
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });
		$.get(
		    "workbench/contact/alertMsg.do",
			function (json) {
		        if (json) {
                    $.each(json, function (i, n) {
                        $.bootstrapGrowl("今日需要联系"+n.name+""+n.appellation+"", {
                            ele: 'body',
                            type: 'danger',
                            offset: {from: 'top', amount: 25},
                            align: 'right',
                            width: 400,
                            delay: 2000,
                            allow_dismiss: true,
                            stackup_spacing: 10
                        });
                    })
                }
            }
		);
        $(".time1").datetimepicker({
            minView: "month",
            language:  'zh-CN',
            format: 'yyyy-mm-dd',
            autoclose: true,
            todayBtn: true,
            clearBtn: true,
            pickerPosition: "top-right"
        });
        $(".time").datetimepicker({
            minView: "month",
            language:  'zh-CN',
            format: 'yyyy-mm-dd',
            autoclose: true,
            todayBtn: true,
            clearBtn: true,
            pickerPosition: "bottom-left"
        });
		$("#createBtn").click(function () {
		    $("#c-form")[0].reset();
            getOwner("c-owner");
            $("#c-owner").find("option[value='${user.id}']").prop("selected",true);
            $('#c-customerName').typeahead({
                source: function(query, process) {
                    $.post(
                        "workbench/tran/autoCompleteCustomer.do",
                        {"name":query},
                        function (json) {
                            process(json);
                        }
                    );
                },
                delay : 200
            });
			$("#createContactsModal").modal("show");
        });
		$("#c-owner").change(function () {
			if (this.value == ""){
			    $("#c-ownerErrorMsg").text("所有者不能为空");
			}
        });
		$("#c-name").blur(function () {
			if (this.value == ""){
			    $("#c-nameErrorMsg").text("姓名不能为空");
			}
        });
		$("#c-owner").focus(function () {
			if ($("#c-ownerErrorMsg").text() != ""){
			    this.value = "";
			}
            $("#c-ownerErrorMsg").text("");
        });
		$("#c-name").focus(function () {
			if ($("#c-nameErrorMsg").text() != ""){
			    this.value = "";
			}
            $("#c-nameErrorMsg").text("");
        });

		$("#saveBtn").click(function () {
            $("#c-owner").change();
            $("#c-name").blur();
            if ($("#c-ownerErrorMsg").text()=="" && $("#c-nameErrorMsg").text()=="") {
				if ($("#c-customerName").val() == ""){
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
							"description" : $.trim($("#c-description").val()),
							"contactSummary" : $.trim($("#c-contactSummary").val()),
							"nextContactTime" : $.trim($("#c-nextContactTime").val()),
							"address" : $.trim($("#c-address").val()),
							"createBy" : "${user.name}"
						},
						function (json) {
							if (json.success){
								$("#createContactsModal").modal("hide");
                                display(1, $("#contactPagination").bs_pagination("getOption","rowsPerPage"));
							}
						}
					)
				} else {
					$.ajaxSetup({
						async:false
					});

						$.get(
							"workbench/customer/checkCustomerName.do",
							{"name":$.trim($("#c-customerName").val())},
							function (json) {
								if (json.success) {
									$("#h-customerId").val(json.id);
								} else {
									alert("保存失败");
								}
								$.ajaxSetup({
									async:true
								});

							}
						);

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
								"customerId" : $("#h-customerId").val(),
								"description" : $.trim($("#c-description").val()),
								"contactSummary" : $.trim($("#c-contactSummary").val()),
								"nextContactTime" : $.trim($("#c-nextContactTime").val()),
								"address" : $.trim($("#c-address").val()),
								"createBy" : "${user.name}"
							},
							function (json) {
								if (json.success){
									$("#createContactsModal").modal("hide");
                                    display(1, $("#contactPagination").bs_pagination("getOption","rowsPerPage"));
								}
							}
						)
				}
			}
		});
		display(1,2);
        $("#qx").click(function () {
            $(":checkbox[name='id']").prop("checked",this.checked);
            $("#tBody").on("click",":checkbox[name='id']",function () {
                $("#qx").prop("checked",$(":checkbox[name='id']").size() == $(":checkbox[name='id']:checked").size());
            });
        });

        $("#pageQueryBtn").click(function () {
            $("#h-name").val($.trim($("#q-name").val()));
            $("#h-source").val($.trim($("#q-source").val()));
            $("#h-owner").val($.trim($("#q-owner").val()));
            $("#h-birth").val($.trim($("#q-birth").val()));
            $("#h-customerName").val($.trim($("#q-customerName").val()));
            display(1, $("#contactPagination").bs_pagination("getOption","rowsPerPage"));
        });
        $("#editBtn").click(function () {
			var  $xz = $(":checkbox[name='id']:checked");
			if ($xz.length == 0){
			    alert("请选择一个记录来修改");
			} else if ($xz.length > 1){
			    alert("不能同时修改多条记录");
			} else {
                $("#editForm")[0].reset();
                var id= $xz[0].value;
                $("#editId").val(id);
                $.get(
                    "workbench/contact/getOne.do",
                    {"id":id},
                    function (json) {
                        getOwner("e-owner");
                        $("#e-owner").find("option[value='"+json.uId+"']").prop("selected",true);
                        $("#e-appellation").val(json.appellation);
                        $("#e-name").val(json.name);
                        $("#e-job").val(json.job);
                        $("#e-email").val(json.email);
                        $("#e-mphone").val(json.mphone);
                        $("#e-source").val(json.source);
                        $("#e-birth").val(json.birth);
                        $("#e-customerName").val(json.customerName);
                        $("#e-description").val(json.description);
                        $("#e-contactSummary").val(json.contactSummary);
                        $("#e-nextContactTime").val(json.nextContactTime);
                        $("#e-address").val(json.address);
                    }
                );
                $('#e-customerName').typeahead({
                    source: function(query, process) {
                        $.post(
                            "workbench/tran/autoCompleteCustomer.do",
                            {"name":query},
                            function (json) {
                                process(json);
                            }
                        );
                    },
                    delay : 200
                });
                $("#editContactsModal").modal("show");
			}
        })
		$("#updateBtn").click(function () {
            if ($("#e-customerName").val() == ""){
                $.post(
                    "workbench/contact/update.do",
                    {
                        "id":$("#editId").val(),
                        "owner" : $.trim($("#e-owner").val()),
                        "source" : $.trim($("#e-source").val()),
                        "appellation" : $.trim($("#e-appellation").val()),
                        "name" : $.trim($("#e-name").val()),
                        "job" : $.trim($("#e-job").val()),
                        "mphone" : $.trim($("#e-mphone").val()),
                        "email" : $.trim($("#e-email").val()),
                        "birth" : $.trim($("#e-birth").val()),
                        "description" : $.trim($("#e-description").val()),
                        "contactSummary" : $.trim($("#e-contactSummary").val()),
                        "nextContactTime" : $.trim($("#e-nextContactTime").val()),
                        "address" : $.trim($("#e-address").val()),
                        "editBy" : "${user.name}"
                    },
                    function (json) {
                        if (json.success){
                            $("#editContactsModal").modal("hide");
                            display(1, $("#contactPagination").bs_pagination("getOption","rowsPerPage"));
                        }
                    }
                )
            } else {
                $.ajaxSetup({
                    async:false
                });

                $.get(
                    "workbench/customer/checkCustomerName.do",
                    {"name":$.trim($("#e-customerName").val())},
                    function (json) {
                        if (json.success) {
                            $("#h-customerId").val(json.id);
                        } else {
                            alert("更新失败");
                        }
                        $.ajaxSetup({
                            async:true
                        });

                    }
                );

                $.post(
                    "workbench/contact/update.do",
                    {
                        "id":$("#editId").val(),
                        "owner" : $.trim($("#e-owner").val()),
                        "source" : $.trim($("#e-source").val()),
                        "appellation" : $.trim($("#e-appellation").val()),
                        "name" : $.trim($("#e-name").val()),
                        "job" : $.trim($("#e-job").val()),
                        "mphone" : $.trim($("#e-mphone").val()),
                        "email" : $.trim($("#e-email").val()),
                        "birth" : $.trim($("#e-birth").val()),
                        "customerId" : $("#h-customerId").val(),
                        "description" : $.trim($("#e-description").val()),
                        "contactSummary" : $.trim($("#e-contactSummary").val()),
                        "nextContactTime" : $.trim($("#e-nextContactTime").val()),
                        "address" : $.trim($("#e-address").val()),
                        "createBy" : "${user.name}"
                    },
                    function (json) {
                        if (json.success){
                            $("#editContactsModal").modal("hide");
                            display(1, $("#contactPagination").bs_pagination("getOption","rowsPerPage"));
                        }
                    }
                )
            }
        });
        $("#deleteBtn").click(function () {
            var $id = $(":checkbox[name='id']:checked");
            if ($id.length == 0){
                alert("请至少选择一条记录来删除");
            } else {
                if (confirm("你确定删除吗?")) {
                    var path = "";
                    for (var i = 0; i < $id.length; i++) {
                        if (i === 0) {
                            path += "id=" + $id[i].value;
                        } else {
                            path += "&id=" + $id[i].value;
                        }
                    }
                    $("#qx").prop("checked",false);
                    $.post(
                        "workbench/contact/delete.do",
						 path,
						 function (json) {
							if (json.success){
                                display(1, $("#contactPagination").bs_pagination("getOption","rowsPerPage"));
							}
                        }
					);

                }
            }
        });
        $("#exportAllBtn").click(function () {
            if (confirm("你确定导出全部数据吗?")) {
                window.location.href = "workbench/contact/exportAll.do";
            }
        });
        $("#exportAllCheckBtn").click(function () {
            var $xz =  $(":checkbox[name='id']:checked");
            if ($xz.length == 0){
                alert("请选择要导出的数据")
            } else {
                var path = "";
                for (var i = 0; i < $xz.length; i++) {
                    path += "&id=" + $xz[i].value;
                }
                path = path.substr(1);
                if (confirm("你确定导出选中的数据吗?")) {
                    window.location.href = "workbench/contact/exportCheckAll.do?" + path;
                }
            }
        });
        $("#importExcelBtn").click(function () {
            $.ajax({
                type:"post",
                url:"workbench/contact/import.do",
                data:new FormData($('#importFileForm')[0]),
                processData:false,
                contentType:false,
                success:function (json) {
                    if (json.success){
                        $("#importContactsModal").modal("hide");
                        display(1, $("#contactPagination").bs_pagination("getOption","rowsPerPage"));
                    } else{
                        alert("导入失败!");
                    }
                }

            });
        });

	});
    function display(pageNo,pageSize){
        $("#tBody").html("");
        $("#qx").prop("checked",false);
        $.get(
            "workbench/contact/page.do",
            {
                "pageNo": pageNo,
                "pageSize" :pageSize,
                "name": $("#h-name").val(),
                "source": $("#h-source").val(),
                "owner": $("#h-owner").val(),
                "birth":$("#h-birth").val(),
                "customerName":$("#h-customerName").val(),
                "_" : new Date().getTime()
            },
            function (json) {
                $(json.aList).each(function () {
                    $("#tBody").append("<tr> <td><input type='checkbox' name='id' value='"+this.id+"'></td> <td><a style='text-decoration: none; cursor: pointer;' onclick="+"window.location.href='workbench/contact/detail.do?id="+this.id+"';"+">"+this.name+"</a></td> <td>"+this.customerName+"</td> <td>"+this.ownerName+"</td> <td>"+this.source+"</td> <td>"+this.birth+"</td> </tr>");
                });
                var totalPages = Math.ceil(json.total/pageSize);
                $("#contactPagination").bs_pagination({
                    currentPage: pageNo, //页码pageNo
                    rowsPerPage: pageSize, //每页显示条数 pageSize
                    totalPages: totalPages,//总页数
                    totalRows: json.total,//总记录条数
                    visiblePageLinks: 3,//显示的卡片数
                    showGoToPage: true,
                    showRowsPerPage: true,
                    showRowsInfo: true,
                    onChangePage:function (event,data) {
                        $("#q-name").val($.trim($("#h-name").val()));
                        $("#q-customerName").val($.trim($("#h-customerName").val()));
                        $("#q-owner").val($.trim($("#h-owner").val()));
                        $("#q-birth").val($.trim($("#h-birth").val()));
                        $("#q-source").val($.trim($("#h-source").val()));
                        display(data.currentPage,data.rowsPerPage);
                    }
                });

            }
        )
    };
	

	
</script>
</head>
<body>

	<input id="h-customerId" type="hidden">

	<input id="h-owner" type="hidden">
	<input id="h-name" type="hidden">
	<input id="h-customerName" type="hidden">
	<input id="h-source" type="hidden">
	<input id="h-birth" type="hidden">

	<input id="editId" type="hidden">
	<!-- 创建联系人的模态窗口 -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabelx">创建联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="c-form">
					
						<div class="form-group">
							<label for="create-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="c-owner">

								</select>
								<span id="c-ownerErrorMsg" style="color: red;font-size: 12px"></span>
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
								<input type="text" class="form-control time" id="c-birth">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="c-customerName" autocomplete="off" placeholder="支持自动补全，输入客户不存在则新建">
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
								<label for="create-contactSummary1" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="c-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime1" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time1" id="c-nextContactTime">
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
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改联系人的模态窗口 -->
	<div class="modal fade" id="editContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">修改联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="editForm">
					
						<div class="form-group">
							<label for="edit-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="e-owner">
								</select>
							</div>
							<label for="edit-clueSource1" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="e-source">
								  <option value=""></option>
									<c:forEach items="${sourceList}" var="s">
										<option value="${s.value}">${s.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="e-name" value="李四">
							</div>
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="e-appellation">
								  <option value=""></option>
									<c:forEach items="${appellationList}" var="s">
										<option value="${s.value}">${s.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="e-job">
							</div>
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="e-mphone">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="e-email">
							</div>
							<label for="edit-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="e-birth">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="e-customerName" autocomplete="off" placeholder="支持自动补全，输入客户不存在则新建" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="e-description">这是一条线索的描述信息</textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="e-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time1" id="e-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address2" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="e-address">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	<!-- 导入联系人的模态窗口 -->
	<div class="modal fade" id="importContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">导入联系人</h4>
				</div>
				<div class="modal-body" style="height: 350px;">
					<div style="position: relative;top: 20px; left: 50px;">
						请选择要上传的文件：<small style="color: gray;">[仅支持.xls或.xlsx格式]</small>
					</div>
					<div style="position: relative;top: 40px; left: 50px;">
						<form id="importFileForm">
						<input type="file" name="f1">
						</form>
					</div>
					<div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
						<h3>重要提示</h3>
						<ul>
							<li>给定文件的第一行将视为字段名。</li>
							<li>请确认您的文件大小不超过5MB。</li>
							<li>从XLS/XLSX文件中导入全部重复记录之前都会被忽略。</li>
							<li>复选框值应该是1或者0。</li>
							<li>日期值必须为MM/dd/yyyy格式。任何其它格式的日期都将被忽略。</li>
							<li>日期时间必须符合MM/dd/yyyy hh:mm:ss的格式，其它格式的日期时间将被忽略。</li>
							<li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
							<li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
						</ul>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="importExcelBtn">导入</button>
				</div>
			</div>
		</div>
	</div>
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>联系人列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="q-owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">姓名</div>
				      <input class="form-control" type="text" id="q-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" type="text" id="q-customerName">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="q-source">
						  <option value=""></option>
						  <c:forEach items="${sourceList}" var="s">
							  <option value="${s.value}">${s.text}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">生日</div>
				      <input class="form-control" type="text" id="q-birth">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="pageQueryBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importContactsModal"><span class="glyphicon glyphicon-import"></span> 导入</button>
				  <button type="button" class="btn btn-default" id="exportAllCheckBtn"><span class="glyphicon glyphicon-export"></span> 导出选中</button>
				  <button type="button" class="btn btn-default" id="exportAllBtn"><span class="glyphicon glyphicon-export"></span> 导出全部</button>
				</div>
				
			</div>
			<div style="position: relative;top: 20px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"></td>
							<td>姓名</td>
							<td>客户名称</td>
							<td>所有者</td>
							<td>来源</td>
							<td>生日</td>
						</tr>
					</thead>
					<tbody id="tBody">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/contacts/detail.jsp';">李四</a></td>
							<td>动力节点</td>
							<td>zhangsan</td>
							<td>广告</td>
							<td>2000-10-10</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/contacts/detail.jsp';">李四</a></td>
                            <td>动力节点</td>
                            <td>zhangsan</td>
                            <td>广告</td>
                            <td>2000-10-10</td>
                        </tr>--%>
					</tbody>
				</table>
				<div id="contactPagination"></div>
			</div>
		</div>
		
	</div>
</body>
</html>