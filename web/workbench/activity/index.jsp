<%@ page import="com.wkcto.crm.utils.DateUtil" %>
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


<script type="text/javascript">
    function display(pageNo,pageSize){
        $("#tBody").html("");
        $("#qx").prop("checked",false);
        $.get(
            "workbench/activity/page.do",
            {
                "pageNo": pageNo,
                "pageSize" :pageSize,
                "name": $("#h-name").val(),
                "ownerName": $("#h-owner").val(),
                "startTime":$("#h-startTime").val(),
                "endTime":$("#h-endTime").val(),
                "_" : new Date().getTime()
            },
            function (json) {
                $(json.aList).each(function () {
                    $("#tBody").append("<tr class='active'><td><input type='checkbox' value='"+this.id+"' name='id'></td><td><a style='text-decoration: none; cursor: pointer;' onclick="+"window.location.href='workbench/activity/detail.do?id="+this.id+"';"+">"
                        +this.name+"</a></td><td>"
                        +this.ownerName+"</td><td>"
                        +this.startTime+"</td><td>"
                        +this.endTime+"</td></tr>");
                });
                var totalPages = Math.ceil(json.total/pageSize);
                $("#activityPagination").bs_pagination({
                    currentPage: pageNo, //页码pageNo
                    rowsPerPage: pageSize, //每页显示条数 pageSize
                    totalPages: totalPages,//总页数
                    totalRows: json.total,//总记录条数
                    visiblePageLinks: 3,//显示的卡片数
                    showGoToPage: true,
                    showRowsPerPage: true,
                    showRowsInfo: true,
                    onChangePage:function (event,data) {
                        $("#p-name").val($.trim($("#h-name").val()));
                        $("#p-ownerName").val( $.trim($("#h-owner").val()));
                        $("#p-startTime").val($.trim($("#h-startTime").val()));
                        $("#p-endTime").val($.trim($("#h-endTime").val()));
                        display(data.currentPage,data.rowsPerPage);
                    }
                });

            }
        )
    };
    function getOwner(id){
        $.ajaxSetup({
            async:false
        });
        $.get(
            "workbench/activity/getOwner.do",
            function (data) {
                $("#"+id).html("<option></option>");
                $(data).each(function () {
                    if (id == "e-owner") {
                        $("#"+id).append("<option value='"+this.name+"'>"+this.name+"</option>");
                    }else {
                        $("#"+id).append("<option value='"+this.id+"'>" + this.name + "</option>");
                    }
                });
                $.ajaxSetup({
                    async:true
                });
            }
        )
    };
    function checkForm(owner,name,startTime,endTime){
        $("#" + owner).change(function () {
            if ($("#" + owner).val() == ""){
                $("#" + owner + "ErrorMsg").text("请选择活动所有者");
            }
        });
        $("#" + owner).click(function () {
            $("#" + owner + "ErrorMsg").text("");
        });

        $("#" + name).blur(function () {
            var name1 = this.value;
            if (name1 == ""){
                $("#" + name +"ErrorMsg").text("活动名称不能为空");
            }
        });
        $("#" + name).focus(function () {
            if ($("#" + name +"ErrorMsg").text() != ""){
                $("#" + name +"ErrorMsg").text("");
            }
        });
        $("#" + endTime).change(function () {
            var begin = new Date($("#" + startTime).val().replace(/-/g,"/"));
            var end = new Date(this.value.replace(/-/g,"/"));
            if(begin - end > 0){
                $("#" + endTime + "ErrorMsg").text("结束时间不能早于开始时间");
            }
        });

        $("#" + endTime).focus(function () {
            if ($("#" + endTime +"ErrorMsg").text() != ""){
                $("#" + endTime +"ErrorMsg").text("");
            }
        });

    }
	$(function(){
        display(1,2);
        checkForm("c-owner","c-name","c-startTime","c-endTime");
        checkForm("e-owner","e-name","e-startTime","e-endTime");
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
	        autoclose: true,
	        todayBtn: true,
			clearBtn: true,
	        pickerPosition: "bottom-left"
		});
		$("#pageQueryBtn").click(function () {
		    $("#h-name").val($.trim($("#p-name").val()));
		    $("#h-owner").val( $.trim($("#p-ownerName").val()));
		    $("#h-startTime").val($.trim($("#p-startTime").val()));
		    $("#h-endTime").val($.trim($("#p-endTime").val()));
			display(1, $("#activityPagination").bs_pagination("getOption","rowsPerPage"));
        });
		$("#createBtn").click(function () {
			$("#createActivityModal").modal("show");
			$("#createForm")[0].reset();
			getOwner("c-owner");
        });
		$("#saveBtn").click(function () {
            $("#c-owner").change();
            $("#c-name").blur();
            $("#c-endTime").change();
			if ($("#c-nameErrorMsg").text() == "" && $("#c-ownerErrorMsg").text() == "" && $("#c-endTimeErrorMsg").text() == "") {
				$.ajax({
					url:"workbench/activity/save.do",
					type:"post",
					data:{
						"owner" :$.trim($("#c-owner").val()),
						"name" :$.trim($("#c-name").val()),
						"startTime" :$.trim($("#c-startTime").val()),
						"endTime" :$.trim($("#c-endTime").val()),
						"cost" :$.trim($("#c-cost").val()),
						"createBy" :"${user.name}",
						"description" :$.trim($("#c-description").val())
					},
					success:function (json) {
						if (json.success){
							$("#createActivityModal").modal("hide");
                            display(1, $("#activityPagination").bs_pagination("getOption","rowsPerPage"));
						}
					},
					error:function () {
						alert("保存失败");
					}
				});
			}

        });
		$("#editBtn").click(function () {
			var $xz = $(":checkbox[name='id']:checked");
			if ($xz.length == 0){
			    alert("请选择一条记录来修改");
			} else if($xz.length > 1){
			    alert("不能同时修改多条记录");
			} else {
                $("#editActivityModal").modal("show");
                var id= $xz[0].value;
                $.get(
                    "workbench/activity/edit.do",
                    {"id":id},
                    function (data) {
                        getOwner("e-owner");

                        $("#e-owner").find("option[value='"+data.ownerName+"']").prop("selected",true);
                        $("#userId").val(data.userId);
                        $("#e-name").val(data.name);
                        $("#editId").val(data.id);
                        $("#e-startTime").val(data.startTime);
                        $("#e-endTime").val(data.endTime);
                        $("#e-cost").val(data.cost);
                        $("#e-description").val(data.description);
                    }
                )
			}
        });
		$("#updateBtn").click(function () {
            $("#e-owner").change();
            $("#e-name").blur();
            $("#e-endTime").change();
			if ($("#e-ownerErrorMsg").text() == "" && $("#e-nameErrorMsg").text() == "" && $("#e-endTimeErrorMsg").text() == ""){
			    $("#editForm").submit();
			}
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
                    window.location.href = "workbench/activity/delete.do" + path;
                }
            }
        });
        $("#qx").click(function () {
             $(":checkbox[name='id']").prop("checked",this.checked);
             $("#tBody").on("click",":checkbox[name='id']",function () {
				 $("#qx").prop("checked",$(":checkbox[name='id']").size() == $(":checkbox[name='id']:checked").size());
             });
        });
        $("#exportAllBtn").click(function () {
            if (confirm("你确定导出全部数据吗?")) {
                window.location.href = "workbench/activity/exportAll.do";
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
                   window.location.href = "workbench/activity/exportCheckAll.do?" + path;
               }
           }
        });
        $("#importExcelBtn").click(function () {
			$.ajax({
				type:"post",
				url:"workbench/activity/import.do",
				data:new FormData($('#importFileForm')[0]),
				processData:false,
				contentType:false,
				success:function (json) {
					if (json.success){
                        $("#importActivityModal").modal("hide");
					    display(1, $("#activityPagination").bs_pagination("getOption","rowsPerPage"));
					} else{
					    alert("导入失败!");
					}
                }

			});
        });


		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });
		
	});
	
</script>
</head>
<body>
<input type="hidden" id="h-name">
<input type="hidden" id="h-owner">
<input type="hidden" id="h-startTime">
<input type="hidden" id="h-endTime">

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" id="createForm" role="form">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="c-owner">
								  <%--<option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
								</select>
								<span id="c-ownerErrorMsg" style="color: red;font-size: 12px;"></span>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="c-name">
								<span id="c-nameErrorMsg" style="color: red;font-size: 12px;"></span>
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="c-startTime">
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="c-endTime">
								<span id="c-endTimeErrorMsg" style="color: red;font-size: 12px;"></span>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="c-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="c-description"></textarea>
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
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form action="workbench/activity/update.do" method="post" class="form-horizontal" role="form" id="editForm">
						<input type="hidden" name="editBy" value="${user.name}">
						<input type="hidden" name="editTime" value="<%=DateUtil.getSysTime()%>">
						<input type="hidden" id="editId" name="id">
						<input type="hidden" id="userId" name="owner" >
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="e-owner">
								  <%--<option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
								</select>
								<span id="e-ownerErrorMsg" style="color: red;font-size: 12px;"></span>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="e-name" name="name" value="发传单">
								<span id="e-nameErrorMsg" style="color: red;font-size: 12px;"></span>
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="e-startTime" name="startTime">
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="e-endTime" name="endTime" >
								<span id="e-endTimeErrorMsg" style="color: red;font-size: 12px;"></span>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="e-cost" name="cost">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="e-description" name="description">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
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
	
	
	<!-- 导入市场活动的模态窗口 -->
	<div class="modal fade" id="importActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
				</div>
				<div class="modal-body" style="height: 350px;">
					<div style="position: relative;top: 20px; left: 50px;">
						请选择要上传的文件：<small style="color: gray;">[仅支持.xls或.xlsx格式]</small>
					</div>
					<div style="position: relative;top: 40px; left: 50px;">
						<form id="importFileForm">
							<input type="file" name="f1" >
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
				<h3>市场活动列表</h3>
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
				      <input class="form-control" type="text" id="p-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="p-ownerName">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control time" type="text" id="p-startTime">
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control time" type="text" id="p-endTime">
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
				  <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal"><span class="glyphicon glyphicon-import"></span> 导入</button>
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
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="tBody">
					</tbody>
				</table>
			</div>
			<div id="activityPagination"></div>
		</div>
		
	</div>
</body>
</html>