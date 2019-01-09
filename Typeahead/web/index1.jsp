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
    <script type="text/javascript" src="jquery/Bootstrap-3-Typeahead-master/bootstrap3-typeahead.js"></script>
    <script>
      $(function () {
          $('#product_search').typeahead({
              source: function(query, process) {
                  $.post(
                      "getName.do",
                      {"name":query},
                      function (json) {
                          process(json);
                      }
                  );
              },
              delay : 200
          });

      })
    </script>
  </head>
  <body>
    <div style="margin: 50px 50px">
      <label for="product_search">Product Search: </label>
      <input id="product_search" type="text" data-provide="typeahead">
    </div>
  </body>
</html>
