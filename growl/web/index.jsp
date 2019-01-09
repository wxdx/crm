<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script type="text/javascript" src="jquery-1.11.1-min.js"></script>
<link href="bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery.bootstrap-growl.js"></script>
<html>
  <head>
    <title>show</title>
    <script type="text/javascript">
      $(function () {

         // $.bootstrapGrowl("My message");

          $.bootstrapGrowl("My message", {
              ele: 'body', // which element to append to  绑定到某个元素
              type: 'info', // (null, 'info', 'danger', 'success')  提示的类型
              offset: {from: 'top', amount: 20}, // 'top', or 'bottom' 相对顶部或者底部的距离
              align: 'right', // ('left', 'right', or 'center')    位置 左右居中
              width: 400, // (integer, or 'auto') 宽度
              delay: 4000, // Time while the message will be displayed. It's not equivalent to the *demo* timeOut!  自动消失时间设置
              allow_dismiss: true, // If true then will display a cross to close the popup. 是否出现小叉叉点击就取消提示框
              stackup_spacing: 10 // spacing between consecutively stacked growls. 这是嘛不太懂 说啥间距嘛的
          });
      });
      /*$(function() {
          $.bootstrapGrowl("This is a test.");

          setTimeout(function() {
              $.bootstrapGrowl("This is another test.", { type: 'success' });
          }, 1000);

          setTimeout(function() {
              $.bootstrapGrowl("Danger, Danger!", {
                  type: 'danger',
                  align: 'center',
                  width: 'auto',
                  allow_dismiss: false
              });
          }, 2000);

          setTimeout(function() {
              $.bootstrapGrowl("Danger, Danger!", {
                  type: 'info',
                  align: 'left',
                  stackup_spacing: 30
              });
          }, 3000);
      });*/
    </script>
  </head>
  <body>
  66
  </body>
</html>
