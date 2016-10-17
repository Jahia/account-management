<%@ page language="java" contentType="text/html;charset=UTF-8" %>
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
<template:addResources type="javascript" resources="jquery.min.js"/>
<template:addResources>
  <script type="text/javascript">
    $(document).ready(function() {
      $("#forgotPassword_${currentNode.identifier}").submit(function(event) {
        event.preventDefault();
        var $form = $(this);
        var url = $form.attr('action');
        $.post(url, $form.serializeArray(),
            function(data) {
              $("#${currentNode.identifier}").html(data['message']);
            }, "json");
      });
    });
  </script>
</template:addResources>
<div id="${currentNode.identifier}">
  <template:tokenizedForm>
    <form id="forgotPassword_${currentNode.identifier}"
          action="${url.baseLive}${currentNode.path}.forgotPassword.do"
          method="post">
      <div class="form-group">
        <label for="usernameInput_${currentNode.identifier}"><fmt:message key="form.input.username"/></label>
        <input type="text" name="username" class="form-control" id="usernameInput_${currentNode.identifier}" placeholder="john.smith">
      </div>
      <button type="submit" class="btn btn-primary">Submit</button>
    </form>
  </template:tokenizedForm>
</div>