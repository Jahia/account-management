package org.jahia.modules.account.manangement.actions;

import org.jahia.bin.ActionResult;
import org.jahia.engines.EngineMessage;
import org.jahia.engines.EngineMessages;
import org.jahia.registries.ServicesRegistry;
import org.jahia.services.content.JCRSessionWrapper;
import org.jahia.services.content.decorator.JCRUserNode;
import org.jahia.services.pwdpolicy.JahiaPasswordPolicyService;
import org.jahia.services.pwdpolicy.PolicyEnforcementResult;
import org.jahia.services.render.RenderContext;
import org.jahia.services.render.Resource;
import org.jahia.services.render.URLResolver;
import org.jahia.utils.i18n.Messages;
import org.json.JSONObject;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

/**
 * Created by smomin on 10/13/16.
 */
public class UpdatePasswordAction extends BaseAction {

    /**
     *
     * @param request
     * @param renderContext
     * @param resource
     * @param session
     * @param parameters
     * @param urlResolver
     * @return
     * @throws Exception
     */
    @Override
    public ActionResult doExecute(final HttpServletRequest request,
                                  final RenderContext renderContext,
                                  final Resource resource,
                                  final JCRSessionWrapper session,
                                  final Map<String, List<String>> parameters,
                                  final URLResolver urlResolver) throws Exception {
        final String password = request.getParameter("password").trim();
        final JSONObject json = new JSONObject();
        if ("".equals(password)) {
            final String userMessage = Messages.get("resources.account-management",
                    "account.errors.password.mandatory", renderContext.getUILocale());
            json.put("errorMessage", userMessage);
            json.put("focusField", "password");
        } else {
            final String confirmPassword = request.getParameter("confirmPassword").trim();
            if (!confirmPassword.equals(password)) {
                final String userMessage = Messages.get("resources.account-management",
                        "account.errors.password.not.matching", renderContext.getUILocale());
                json.put("errorMessage", userMessage);
                json.put("focusField", "password");
            } else {
                final String oldPassword = request.getParameter("oldPassword").trim();
                final JCRUserNode user = getUserManagerService()
                        .lookupUser(renderContext.getUser().getUsername(), session);
                if (!user.verifyPassword(oldPassword)) {
                    final String userMessage = Messages.get("resources.account-management",
                            "account.errors.oldPassword.matching", renderContext.getUILocale());
                    json.put("errorMessage", userMessage);
                    json.put("focusField", "oldPassword");
                } else {
                    final JahiaPasswordPolicyService pwdPolicyService = ServicesRegistry.getInstance()
                            .getJahiaPasswordPolicyService();
                    final PolicyEnforcementResult evalResult = pwdPolicyService
                            .enforcePolicyOnPasswordChange(user, password, true);
                    if (!evalResult.isSuccess()) {
                        final EngineMessages policyMsgs = evalResult.getEngineMessages();
                        final StringBuilder res = new StringBuilder();
                        for (final EngineMessage message : policyMsgs.getMessages()) {
                            res.append((message.isResource() ? Messages.getInternalWithArguments(message.getKey(),
                                    renderContext.getUILocale(), message.getValues()) : message.getKey()) + "\n");
                        }
                        json.put("errorMessage", res.toString());
                    } else {
                        user.setPassword(password);
                        session.save();
                        json.put("errorMessage", Messages.get("resources.account-management",
                                "account.passwordChanged", renderContext.getUILocale()));
                        json.put("result", "success");
                    }
                }
            }
        }
        return new ActionResult(HttpServletResponse.SC_OK, null, json);
    }
}
