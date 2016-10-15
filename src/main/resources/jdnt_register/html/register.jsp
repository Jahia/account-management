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
      $("#register_${currentNode.identifier}").submit(function(event) {
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
              if (data['result'] == 'success') {
                $.get("${currentNode.properties['redirectPage'].node.url}.ajax", function(d) {
                  $("#${currentNode.identifier}").html(d);
                });
              }
            }, "json");
      });
    });
  </script>
</template:addResources>
<div id="${currentNode.identifier}">
  <template:tokenizedForm>
    <form id="register_${currentNode.identifier}"
          action="${url.baseLive}${currentNode.path}.register.do"
          method="post">
      <div class="form-group">
        <label for="usernameInput_${currentNode.identifier}"><fmt:message key="form.input.username"/></label>
        <input type="text" name="username" class="form-control" id="usernameInput_${currentNode.identifier}" placeholder="john.smith">
      </div>
      <div class="form-group">
        <label for="passwordInput_${currentNode.identifier}"><fmt:message key="form.input.password"/></label>
        <input type="password" name="password" class="form-control" id="passwordInput_${currentNode.identifier}">
      </div>
      <div class="form-group">
        <label for="confirmPasswordInput_${currentNode.identifier}"><fmt:message key="form.input.confirm.password"/></label>
        <input type="password" name="confirmPassword" class="form-control" id="confirmPasswordInput_${currentNode.identifier}">
      </div>
      <div class="form-group">
        <label for="firstNameInput_${currentNode.identifier}"><fmt:message key="form.input.first.name"/></label>
        <input type="text" name="firstName" class="form-control" id="firstNameInput_${currentNode.identifier}" placeholder="John">
      </div>
      <div class="form-group">
        <label for="lastNameInput_${currentNode.identifier}"><fmt:message key="form.input.last.name"/></label>
        <input type="text" name="lastName" class="form-control" id="lastNameInput_${currentNode.identifier}" placeholder="Smith">
      </div>
      <div class="form-group">
        <label for="emailInput_${currentNode.identifier}"><fmt:message key="form.input.email.address"/></label>
        <input type="email" name="email" class="form-control" id="emailInput_${currentNode.identifier}" aria-describedby="emailHelp" placeholder="john.smith@mail.com">
        <small id="emailHelp" class="form-text text-muted"><fmt:message key="form.input.email.address.help"/></small>
      </div>
      <button type="submit" class="btn btn-primary">Submit</button>
    </form>
  </template:tokenizedForm>
</div>