<%@ page import="com.wkcto.crm.utils.DateUtil" %>
<%@page contentType="text/html; charset=utf-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
            $("#createClueModal").modal("show");
		    $("#createForm")[0].reset();
            getOwner("c-owner");
            $("#c-owner").find("option[value='${user.id}']").prop("selected",true);

        });
		$("#editBtn").click(function () {
            var $xz = $(":checkbox[name='id']:checked");
            if ($xz.length == 0){
                alert("请选择一条记录来修改");
            } else if($xz.length > 1){
                alert("不能同时修改多条记录");
            } else {
                $("#editClueModal").modal("show");
                $("#editForm")[0].reset();
                var id= $xz[0].value;
                $("#editId").val(id);
                $.get(
                    "workbench/clue/getOne.do",
                    {"id":id},
                    function (json) {
                        getOwner("e-owner");
                        $("#e-owner").find("option[value='"+json.uId+"']").prop("selected",true);
                        $("#e-company").val(json.company);
                        $("#e-appellation").val(json.appellation);
                        $("#e-fullname").val(json.fullname);
                        $("#e-job").val(json.job);
                        $("#e-email").val(json.email);
                        $("#e-phone").val(json.phone);
                        $("#e-website").val(json.website);
                        $("#e-mphone").val(json.mphone);
                        $("#e-state").val(json.state);
                        $("#e-source").val(json.source);
                        $("#e-description").val(json.description);
                        $("#e-contactSummary").val(json.contactSummary);
                        $("#e-nextContactTime").val(json.nextContactTime);
                        $("#e-address").val(json.address);
                    }
                )
            }
        });
		$("#updateBtn").click(function () {
            $("e-owner").change();
            $("e-company").blur();
            $("e-fullname").blur();
            if ($("#e-ownerErrorMsg").text() == "" && $("#e-companyErrorMsg").text() == "" && $("#e-fullnameErrorMsg").text() == "") {
                $("#editForm").submit();
            }
		});
		checkForm("c-owner","c-company","c-fullname");
        clearErrorMsg("c-owner","c-company","c-fullname");
		checkForm("e-owner","e-company","e-fullname");
        clearErrorMsg("e-owner","e-company","e-fullname");
		$("#c-saveBtn").click(function () {
			$("c-owner").change();
			$("c-company").blur();
			$("c-fullname").blur();
			if ($("#c-ownerErrorMsg").text() == "" && $("#c-companyErrorMsg").text() == "" && $("#c-fullnameErrorMsg").text() == "") {
			    $.post(
			        "workbench/clue/save.do",
					{
                       "owner" : $.trim($("#c-owner").val()),
                       "company" : $.trim($("#c-company").val()),
                       "appellation" : $.trim($("#c-appellation").val()),
                       "fullname" : $.trim($("#c-fullname").val()),
                       "job" : $.trim($("#c-job").val()),
                       "email" : $.trim($("#c-email").val()),
                       "phone" : $.trim($("#c-phone").val()),
                       "website" : $.trim($("#c-website").val()),
                       "mphone" : $.trim($("#c-mphone").val()),
                       "state" : $.trim($("#c-state").val()),
                       "source" : $.trim($("#c-source").val()),
                       "description" : $.trim($("#c-description").val()),
                       "contactSummary" : $.trim($("#c-contactSummary").val()),
                       "nextContactTime" : $.trim($("#c-nextContactTime").val()),
                       "address" : $.trim($("#c-address").val()),
                       "createBy" : "${user.name}",
                       "createTime" : "<%=DateUtil.getSysTime()%>"
                    },
					function (json) {
						if (json.success){
                            $("#createClueModal").modal("hide");
                            display(1, $("#cluePagination").bs_pagination("getOption","rowsPerPage"));
						}
                    }
				)
			}

        });
        $("#pageQueryBtn").click(function () {
            $("#h-fullname").val($.trim($("#q-fullname").val()));
            $("#h-company").val($.trim($("#q-company").val()));
            $("#h-phone").val($.trim($("#q-phone").val()));
            $("#h-source").val($.trim($("#q-source").val()));
            $("#h-owner").val($.trim($("#q-owner").val()));
            $("#h-mphone").val($.trim($("#q-mphone").val()));
            $("#h-state").val($.trim($("#q-state").val()));
            display(1, $("#cluePagination").bs_pagination("getOption","rowsPerPage"));
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
                    window.location.href = "workbench/clue/delete.do" + path;
                }
            }
        });
        $("#exportAllBtn").click(function () {
            if (confirm("你确定导出全部数据吗?")) {
                window.location.href = "workbench/clue/exportAll.do";
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
                    window.location.href = "workbench/clue/exportCheckAll.do?" + path;
                }
            }
        });
        $("#importExcelBtn").click(function () {
            $.ajax({
                type:"post",
                url:"workbench/clue/import.do",
                data:new FormData($('#importFileForm')[0]),
                processData:false,
                contentType:false,
                success:function (json) {
                    if (json.success){
                        $("#importClueModal").modal("hide");
                        display(1, $("#cluePagination").bs_pagination("getOption","rowsPerPage"));
                    } else{
                        alert("导入失败!");
                    }
                }

            });
        });

		
	});
    function clearErrorMsg(id,id1,id2){
        $("#" + id).focus(function () {
            if ($("#" + id + "ErrorMsg").text() != "") {
                $("#" + id).val("");
            }
            $("#" + id + "ErrorMsg").text("");
        })

        $("#" + id1).focus(function () {
            if ($("#" + id1 + "ErrorMsg").text() != "") {
                $("#" + id1).val("");
            }
            $("#" + id1 + "ErrorMsg").text("");
        })

        $("#" + id2).focus(function () {
            if ($("#" + id2 + "ErrorMsg").text() != "") {
                $("#" + id2).val("");
            }
            $("#" + id2 + "ErrorMsg").text("");
        })

    };
	function checkForm(id1,id2,id3) {
        $("#" + id1).change(function () {
            if (this.value == ""){
                $("#" + id1 + "ErrorMsg").text("所有者不能为空");
            }
        });
        $("#" + id2).blur(function () {
            if (this.value == ""){
                $("#" + id2 + "ErrorMsg").text("公司不能为空");
            }
        });
        $("#" + id3).blur(function () {
            if (this.value == ""){
                $("#" + id3 + "ErrorMsg").text("姓名不能为空");
            }
        });
    };
    function display(pageNo,pageSize){
        $("#tBody").html("");
        $("#qx").prop("checked",false);
        $.get(
            "workbench/clue/page.do",
            {
                "pageNo": pageNo,
                "pageSize" :pageSize,
                "fullname": $("#h-fullname").val(),
                "company": $("#h-company").val(),
                "phone": $("#h-phone").val(),
                "source":$("#h-source").val(),
                "owner":$("#h-owner").val(),
                "mphone":$("#h-mphone").val(),
                "state":$("#h-state").val(),
                "_" : new Date().getTime()
            },
            function (json) {
                $(json.aList).each(function () {
                    $("#tBody").append("<tr class=\"active\"> <td><input type='checkbox' name='id' value='"+this.id+"' /></td> <td><a style='text-decoration: none; cursor: pointer;' onclick="+"window.location.href='workbench/clue/detail.do?id="+this.id+"';"+">"+
						this.fullname+""+
						this.appellation+"</a></td> <td>"+
						this.company+"</td> <td>"+
						this.phone+"</td> <td>"+
						this.mphone+"</td> <td>"+
						this.source+"</td> <td>"+
						this.owner+"</td> <td>"+
						this.state+"</td> </tr>");
                });
                var totalPages = Math.ceil(json.total/pageSize);
                $("#cluePagination").bs_pagination({
                    currentPage: pageNo, //页码pageNo
                    rowsPerPage: pageSize, //每页显示条数 pageSize
                    totalPages: totalPages,//总页数
                    totalRows: json.total,//总记录条数
                    visiblePageLinks: 3,//显示的卡片数
                    showGoToPage: true,
                    showRowsPerPage: true,
                    showRowsInfo: true,
                    onChangePage:function (event,data) {
                        $("#q-fullname").val($.trim($("#h-fullname").val()));
                        $("#q-company").val( $.trim($("#h-company").val()));
                        $("#q-phone").val($.trim($("#h-phone").val()));
                        $("#q-source").val($.trim($("#h-source").val()));
                        $("#q-owner").val($.trim($("#h-owner").val()));
                        $("#q-mphone").val($.trim($("#h-mphone").val()));
                        $("#q-state").val($.trim($("#h-state").val()));
                        display(data.currentPage,data.rowsPerPage);
                    }
                });

            }
        )
    };
	
</script>
</head>
<body>
<input type="hidden" id="h-fullname">
<input type="hidden" id="h-company">
<input type="hidden" id="h-phone">
<input type="hidden" id="h-source">
<input type="hidden" id="h-owner">
<input type="hidden" id="h-mphone">
<input type="hidden" id="h-state">

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="createForm">
					
						<div class="form-group">
							<label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="c-owner">
								  <option value=""></option>
								</select>
								<span id="c-ownerErrorMsg" style="color: red;font-size: 12px"></span>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="c-company">
								<span id="c-companyErrorMsg" style="color: red;font-size: 12px"></span>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="c-appellation">
								  <option value=""></option>
									<c:forEach items="${appellationList}" var="appellation">
										<option value="${appellation.value}">${appellation.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="c-fullname">
								<span id="c-fullnameErrorMsg" style="color: red;font-size: 12px"></span>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="c-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="c-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="c-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="c-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="c-mphone">
							</div>
							<label for="create-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="c-state">
								  <option value=""></option>
									<c:forEach items="${clueStateList}" var="clueState">
										<option value="${clueState.value}">${clueState.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="c-source">
								  <option value=""></option>
									<c:forEach items="${sourceList}" var="source">
										<option value="${source.value}">${source.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">线索描述</label>
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
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
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
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="editForm" action="workbench/clue/update.do" method="post">
						<input type="hidden" id="editId" name="id">
						<input type="hidden" name="editBy" value="${user.name}">
						<input type="hidden" name="editTime" value="<%=DateUtil.getSysTime()%>">

						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="e-owner" name="owner">
								  <option value=""></option>
								</select>
								<span id="e-ownerErrorMsg" style="color: red;font-size: 12px"></span>

							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="e-company" name="company">
								<span id="e-companyErrorMsg" style="color: red;font-size: 12px"></span>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="e-appellation" name="appellation">
								  <option value=""></option>
									<c:forEach items="${appellationList}" var="appellation">
										<option value="${appellation.value}">${appellation.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="e-fullname" name="fullname" value="李四">
								<span id="e-fullnameErrorMsg" style="color: red;font-size: 12px"></span>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="e-job" name="job">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="e-email" name="email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="e-phone" name="phone">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="e-website" name="website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="e-mphone" name="mphone">
							</div>
							<label for="edit-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="e-state" name="state">
								  <option value=""></option>
									<c:forEach items="${clueStateList}" var="clueState">
										<option value="${clueState.value}">${clueState.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="e-source" name="source">
								  <option value=""></option>
									<c:forEach items="${sourceList}" var="source">
										<option value="${source.value}">${source.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="e-description" name="description">这是一条线索的描述信息</textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="e-contactSummary" name="contactSummary">这个线索即将被转换</textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="e-nextContactTime" name="nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="e-address" name="address">北京大兴区大族企业湾</textarea>
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
	
	
	<!-- 导入线索的模态窗口 -->
	<div class="modal fade" id="importClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">导入线索</h4>
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
				<h3>线索列表</h3>
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
				      <input class="form-control" type="text" id="q-fullname">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input class="form-control" type="text" id="q-company">
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
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control" id="q-source">
					  	  <option value=""></option>
						  <c:forEach items="${sourceList}" var="source">
							  <option value="${source.value}">${source.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="q-owner">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input class="form-control" type="text" id="q-mphone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control" id="q-state">
						<option value=""></option>
						<c:forEach items="${clueStateList}" var="clueState">
							<option value="${clueState.value}">${clueState.text}</option>
						</c:forEach>
						</select>
				    </div>
				  </div>

				  <button type="button" class="btn btn-default" id="pageQueryBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importClueModal"><span class="glyphicon glyphicon-import"></span> 导入</button>
				  <button type="button" class="btn btn-default" id="exportCheckBtn"><span class="glyphicon glyphicon-export"></span> 导出选中</button>
				  <button type="button" class="btn btn-default" id="exportAllBtn"><span class="glyphicon glyphicon-export"></span> 导出全部</button>
				</div>
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="tBody">
					</tbody>
				</table>
				<div id="cluePagination"></div>
			</div>

		</div>
	</div>
</body>
</html>