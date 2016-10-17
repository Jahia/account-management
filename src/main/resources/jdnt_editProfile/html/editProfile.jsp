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
<%@ taglib prefix="user" uri="http://www.jahia.org/tags/user" %>
<%--@elvariable id="currentUser" type="org.jahia.services.usermanager.JahiaUser"--%>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<c:set var="userNode" value="${user:lookupUser(currentUser.username)}"/>
<div id="${currentNode.identifier}">
  <form action="${url.baseLive}${currentNode.path}.updateProfile.do" method="post">
    <input type="hidden" name="redirectPage" value="${currentNode.properties['redirectPage'].node.path}"/>
    <div class="form-group">
      <label for="emailInput"><fmt:message key="form.input.email.address"/></label>
      <input type="email" name="email" value="${userNode.properties['j:email'].string}" class="form-control" id="emailInput" placeholder="john.smith@mail.com">
      </div>
    <div class="form-group">
      <label for="firstNameInput"><fmt:message key="form.input.first.name"/></label>
      <input type="text" name="firstName" value="${userNode.properties['j:firstName'].string}" class="form-control" id="firstNameInput" placeholder="John">
    </div>
    <div class="form-group">
      <label for="lastNameInput"><fmt:message key="form.input.last.name"/></label>
      <input type="text" name="lastName" value="${userNode.properties['j:lastName'].string}" class="form-control" id="lastNameInput" placeholder="Smith">
    </div>
    <button type="submit" class="btn btn-primary">Submit</button>
  </form>
</div>