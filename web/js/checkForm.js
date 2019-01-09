function clearErrorMsg(id1,id2,id3,id4,id5){
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

    $("#" + id3).click(function () {
        if ($("#" + id3 + "ErrorMsg").text() != "") {
            $("#" + id3).val("");
        }
        $("#" + id3 + "ErrorMsg").text("");
    })

    $("#" + id4).focus(function () {
        if ($("#" + id4 + "ErrorMsg").text() != "") {
            $("#" + id4).val("");
        }
        $("#" + id4 + "ErrorMsg").text("");
    })
    $("#" + id5).focus(function () {
        if ($("#" + id5 + "ErrorMsg").text() != "") {
            $("#" + id5).val("");
        }
        $("#" + id5 + "ErrorMsg").text("");
    })

};
function checkForm(id1,id2,id3,id4,id5) {
    $("#" + id1).change(function () {
        if (this.value == ""){
            $("#" + id1 + "ErrorMsg").text("所有者不能为空");
        }
    });
    $("#" + id2).blur(function () {
        if (this.value == ""){
            $("#" + id2 + "ErrorMsg").text("交易名称不能为空");
        }
    });
    $("#" + id3).change(function () {
        if (this.value == ""){
            $("#" + id3 + "ErrorMsg").text("预计成交日期不能为空");
        }
    });
    $("#" + id4).blur(function () {
        if (this.value == ""){
            $("#" + id4 + "ErrorMsg").text("客户名称不能为空");
        }
    });
    $("#" + id5).change(function () {
        if (this.value == ""){
            $("#" + id5 + "ErrorMsg").text("阶段不能为空");
        }
    });
};