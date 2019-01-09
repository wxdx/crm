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


	<script type="text/javascript" src="js/Source.js"></script>

<script type="text/javascript">
	$(function(){
        display(1,2);
        $(".time").datetimepicker({
            minView: "month",
            language:  'zh-CN',
            format: 'yyyy-mm-dd',
            autoclose: true,
            todayBtn: true,
            clearBtn: true,
            pickerPosition: "top-right"
        });
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });
        $("#createBtn").click(function () {
            $("#createCustomerModal").modal("show");
            $("#createForm")[0].reset();
            getOwner("c-owner");
            $("#c-owner").find("option[value='${user.id}']").prop("selected",true);
        });
        $("#pageQueryBtn").click(function () {
            $("#h-name").val($.trim($("#q-name").val()));
            $("#h-phone").val($.trim($("#q-phone").val()));
            $("#h-owner").val($.trim($("#q-owner").val()));
            $("#h-website").val($.trim($("#q-website").val()));
            display(1, $("#customerPagination").bs_pagination("getOption","rowsPerPage"));
        });
        $("#c-name").blur(function () {
			if (this.value == ""){
				$("#c-nameErrorMsg").text("名称不能为空!");
			}
        });
        $("#c-name").focus(function () {
            if ( $("#c-nameErrorMsg").text() != ""){
				this.value = "";
            }
            $("#c-nameErrorMsg").text("");
        });
        $("#e-name").blur(function () {
			if (this.value == ""){
				$("#e-nameErrorMsg").text("名称不能为空!");
			}
        });
        $("#e-name").focus(function () {
            if ( $("#e-nameErrorMsg").text() != ""){
				this.value = "";
            }
            $("#e-nameErrorMsg").text("");
        });
        $("#c-saveBtn").click(function () {
            $("c-name").blur();
            if ($("#c-nameErrorMsg").text() == "") {
                $.post(
                    "workbench/customer/save.do",
                    {
                        "owner" : $.trim($("#c-owner").val()),
                        "name" : $.trim($("#c-name").val()),
                        "phone" : $.trim($("#c-phone").val()),
                        "website" : $.trim($("#c-website").val()),
                        "description" : $.trim($("#c-description").val()),
                        "contactSummary" : $.trim($("#c-contactSummary").val()),
                        "nextContactTime" : $.trim($("#c-nextContactTime").val()),
                        "address" : $.trim($("#c-address").val()),
                        "createBy" : "${user.name}"
                    },
                    function (json) {
                        if (json.success){
                            $("#createCustomerModal").modal("hide");
                            display(1, $("#customerPagination").bs_pagination("getOption","rowsPerPage"));
                        }
                    }
                )
            }

        });

        $("#editBtn").click(function () {
            var $xz = $(":checkbox[name='id']:checked");
            if ($xz.length == 0){
                alert("请选择一条记录来修改");
            } else if($xz.length > 1){
                alert("不能同时修改多条记录");
            } else {
                $("#editCustomerModal").modal("show");
                $("#editForm")[0].reset();
                var id= $xz[0].value;
                $("#editId").val(id);
                $.get(
                    "workbench/customer/getOne.do",
                    {"id":id},
                    function (json) {
                        getOwner("e-owner");
                        $("#e-owner").find("option[value='"+json.uId+"']").prop("selected",true);
                        $("#e-name").val(json.name);
                        $("#e-phone").val(json.phone);
                        $("#e-website").val(json.website);
                        $("#e-description").val(json.description);
                        $("#e-contactSummary").val(json.contactSummary);
                        $("#e-nextContactTime").val(json.nextContactTime);
                        $("#e-address").val(json.address);
                    }
                )
            }
        });
        $("#updateBtn").click(function () {
            $("#e-name").blur();
            if ($("#e-nameErrorMsg").text() == "") {
                $("#editForm").submit();
            }
        });
        $("#qx").click(function () {
			$(":checkbox[name='id']").prop("checked",this.checked);
			$("#tBody").on("click",":checkbox[name='id']",function () {
				$("#qx").prop("checked",$(":checkbox[name='id']").size() == $(":checkbox[name='id']:checked").size());
            });
        });
        $("#deleteBtn").click(function () {
            var $id = $(":checkbox[name='id']:checked");
            if ($id.length == 0){
                alert("请至少选择一条记录来删除");
            } else {
                if (confirm("你确定删除吗?")) {
                    var path = "?";
                    for (var i = 0; i < $id.length; i++) {
                        if (i === 0) {
                            path += "id=" + $id[i].value;
                        } else {
                            path += "&id=" + $id[i].value;
                        }
                    }
                    $("#qx").prop("checked",false);
                    window.location.href = "workbench/customer/delete.do" + path;
                }
            }
        });
        $("#exportAllBtn").click(function () {
            if (confirm("你确定导出全部数据吗?")) {
                window.location.href = "workbench/customer/exportAll.do";
            }
        });
        $("#exportCheckBtn").click(function () {
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
                    window.location.href = "workbench/customer/exportCheckAll.do?" + path;
                }
            }
        });
        $("#importExcelBtn").click(function () {
            $.ajax({
                type:"post",
                url:"workbench/customer/import.do",
                data:new FormData($('#importFileForm')[0]),
                processData:false,
                contentType:false,
                success:function (json) {
                    if (json.success){
                        $("#importCustomerModal").modal("hide");
                        display(1, $("#customerPagination").bs_pagination("getOption","rowsPerPage"));
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
            "workbench/customer/page.do",
            {
                "pageNo": pageNo,
                "pageSize" :pageSize,
                "name": $("#h-name").val(),
                "phone": $("#h-phone").val(),
                "owner":$("#h-owner").val(),
                "website":$("#h-website").val(),
                "_" : new Date().getTime()
            },
            function (json) {
                $(json.aList).each(function () {
                    $("#tBody").append("<tr> <td><input type='checkbox' name='id' value='"+
						this.id+"' /></td> <td><a style='text-decoration: none; cursor: pointer;' onclick="+"window.location.href='workbench/customer/detail.do?id="+this.id+"';"+">"+ this.name+"</a></td> <td>"+ this.owner+"</td> <td>"+ this.phone+"</td> <td>"+ this.website+"</td> </tr>");
                });
                var totalPages = Math.ceil(json.total/pageSize);
                $("#customerPagination").bs_pagination({
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
                        $("#q-phone").val($.trim($("#h-phone").val()));
                        $("#q-owner").val($.trim($("#h-owner").val()));
                        $("#q-website").val($.trim($("#h-website").val()));
                        display(data.currentPage,data.rowsPerPage);
                    }
                });

            }
        )
    };

</script>
</head>
<body>
<input type="hidden" id="h-name">
<input type="hidden" id="h-owner">
<input type="hidden" id="h-phone">
<input type="hidden" id="h-website">



	<!-- 创建客户的模态窗口 -->
	<div class="modal fade" id="createCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="createForm">
					
						<div class="form-group">
							<label for="create-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="c-owner">
								</select>
							</div>
							<label for="create-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="c-name">
								<span id="c-nameErrorMsg" style="color: red;font-size: 12px"></span>
							</div>
						</div>
						
						<div class="form-group">
                            <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="c-website">
                            </div>
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="c-phone">
							</div>
						</div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="c-description"></textarea>
							</div>
						</div>
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="c-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control time" id="c-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address1" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="c-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="c-saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改客户的模态窗口 -->
	<div class="modal fade" id="editCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="editForm" action="workbench/customer/update.do" method="post">
						<input type="hidden" id="editId" name="id">
						<input type="hidden" name="editBy" value="${user.name}">
					
						<div class="form-group">
							<label for="edit-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="e-owner" name="owner">
								</select>
							</div>
							<label for="edit-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="e-name" name="name" value="动力节点">
								<span id="e-nameErrorMsg" style="color: red;font-size: 12px"></span>
							</div>
						</div>
						
						<div class="form-group">
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="e-website" name="website" value="http://www.bjpowernode.com">
                            </div>
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="e-phone" name="phone" value="010-84846003">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="e-description" name="description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="create-contactSummary1" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="e-contactSummary" name="contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="create-nextContactTime2" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control time" id="e-nextContactTime" name="nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id=e-address" name="address">北京大兴大族企业湾</textarea>
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
	
	
	<!-- 导入客户的模态窗口 -->
	<div class="modal fade" id="importCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">导入客户</h4>
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
				<h3>客户列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="q-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="q-owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text" id="q-phone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司网站</div>
				      <input class="form-control" type="text" id="q-website">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="pageQueryBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importCustomerModal"><span class="glyphicon glyphicon-import"></span> 导入</button>
				  <button type="button" class="btn btn-default" id="exportCheckBtn"><span class="glyphicon glyphicon-export"></span> 导出选中</button>
				  <button type="button" class="btn btn-default" id="exportAllBtn"><span class="glyphicon glyphicon-export"></span> 导出全部</button>
				</div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx" /></td>
							<td>名称</td>
							<td>所有者</td>
							<td>公司座机</td>
							<td>公司网站</td>
						</tr>
					</thead>
					<tbody id="tBody">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/customer/detail.jsp';">动力节点</a></td>
							<td>zhangsan</td>
							<td>010-84846003</td>
							<td>http://www.bjpowernode.com</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/customer/detail.jsp';">动力节点</a></td>
                            <td>zhangsan</td>
                            <td>010-84846003</td>
                            <td>http://www.bjpowernode.com</td>
                        </tr>--%>
					</tbody>
				</table>
				<div id="customerPagination"></div>
			</div>

		</div>
		
	</div>
</body>
</html>