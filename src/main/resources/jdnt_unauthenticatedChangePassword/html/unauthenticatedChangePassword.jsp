<%@ page language="java"
         contentType="text/html;charset=UTF-8"
         import="org.apache.commons.codec.binary.Base64" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="query" uri="http://www.jahia.org/tags/queryLib" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="s" uri="http://www.jahia.org/tags/search" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
key: ${param['key']}<br>
<c:if test="${not empty param['key']}">
  <% pageContext.setAttribute("requestKeyValue", new String(Base64.decodeBase64(request.getParameter("key")), "UTF-8")); %>
</c:if>
requestKeyValue:  ${requestKeyValue}<br>
<c:if test="${not empty requestKeyValue}">
  <c:set var="userpath" value="${fn:substringBefore(requestKeyValue, '|')}" />
  <c:set var="authKey" value="${fn:substringAfter(requestKeyValue, '|')}" />
</c:if>
<template:addResources type="javascript" resources="jquery.min.js"/>
<template:addResources>
  <script type="text/javascript">
    $(document).ready(function() {
      $("#changePasswordForm_${currentNode.identifier}").submit(function(event) {
        event.preventDefault();
        var $form = $(this);
        var url = $form.attr('action');

        var password = $form.find('input[name="password"]').val();
        if (password == '') {
          alert("<fmt:message key='passwordrecovery.recover.password.mandatory'/>");
          return false;
        }
        var passwordconfirm = $form.find('input[name="confirmPassword"]').val();
        if (passwordconfirm != password) {
          alert("<fmt:message key='passwordrecovery.recover.password.not.matching'/>");
          return false;
        }
        $.post(url, $form.serializeArray(),
            function(data) {
              alert(data['errorMessage']);
              if (data['result'] == 'success') {
                $.get("${currentNode.properties['redirectPage'].node.url}.ajax", function(d) {
                  $("#${currentNode.identifier}").html(d);
                });
              } else if (data['errorMessage']) {
                $("#${currentNode.identifier}").html(data['errorMessage']);
              }
            }, "json");
      });
    });
  </script>
</template:addResources>
<div id="${currentNode.identifier}">
  <template:tokenizedForm>
    <form id="changePasswordForm_${currentNode.identifier}"
          action="<c:url value='${url.base}${fn:escapeXml(userpath)}.unauthenticatedChangePassword.do'/>"
          method="post">
      <input type="hidden" name="authKey" value="${fn:escapeXml(authKey)}" />
      <div class="form-group">
        <label for="passwordInput_${currentNode.identifier}"><fmt:message key="form.input.password"/></label>
        <input type="password" name="password" autocomplete="off" class="form-control" id="passwordInput_${currentNode.identifier}">
      </div>
      <div class="form-group">
        <label for="confirmPasswordInput_${currentNode.identifier}"><fmt:message key="form.input.confirm.password"/></label>
        <input type="password" name="confirmPassword" autocomplete="off" class="form-control" id="confirmPasswordInput_${currentNode.identifier}">
      </div>
      <button type="submit" class="btn btn-primary">Submit</button>
    </form>
  </template:tokenizedForm>
</div>