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
<form action="${url.baseLive}${currentNode.path}.updatePassword.do" method="post">
  <input type="hidden" name="redirectPage" value="${currentNode.properties['redirectPage'].node.path}"/>
  <div class="form-group">
    <label for="oldPasswordInput"><fmt:message key="form.input.old.password"/></label>
    <input type="password" name="oldPassword" class="form-control" id="oldPasswordInput">
  </div>
  <div class="form-group">
    <label for="passwordInput"><fmt:message key="form.input.password"/></label>
    <input type="password" name="password" class="form-control" id="passwordInput">
  </div>
  <div class="form-group">
    <label for="confirmPasswordInput"><fmt:message key="form.input.confirm.password"/></label>
    <input type="password" name="confirmPassword" class="form-control" id="confirmPasswordInput">
  </div>
  <button type="submit" class="btn btn-primary">Submit</button>
</form>