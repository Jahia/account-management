package org.jahia.modules.account.manangement.actions;

import org.apache.commons.lang.StringUtils;
import org.jahia.bin.ActionResult;
import org.jahia.services.content.JCRCallback;
import org.jahia.services.content.JCRSessionWrapper;
import org.jahia.services.content.JCRTemplate;
import org.jahia.services.content.decorator.JCRUserNode;
import org.jahia.services.render.RenderContext;
import org.jahia.services.render.Resource;
import org.jahia.services.render.URLResolver;
import org.jahia.utils.i18n.Messages;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.jcr.RepositoryException;
import javax.script.ScriptException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

/**
 * Created by smomin on 10/13/16.
 */
public class RegisterAction extends BaseAction {
    private static final Logger LOGGER = LoggerFactory.getLogger(RegisterAction.class);

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
        final String username = getParameter(parameters, "username");
        final String password = getParameter(parameters, "password");
        if (StringUtils.isEmpty(username) || StringUtils.isEmpty(password)) {
            return ActionResult.BAD_REQUEST;
        }

        final JSONObject json = new JSONObject();
        final String confirmPassword = getParameter(parameters, "confirmPassword");
        if (!confirmPassword.equals(password)) {
            final String userMessage = Messages.get("resources.account-management",
                    "account.errors.password.not.matching", renderContext.getUILocale());
            json.put("errorMessage", userMessage);
            json.put("focusField", "password");
            return new ActionResult(HttpServletResponse.SC_ACCEPTED, null, json);
        }

        final Properties properties = new Properties();
        properties.put("j:email", parameters.get("email").get(0));
        properties.put("j:firstName", parameters.get("firstName").get(0));
        properties.put("j:lastName", parameters.get("lastName").get(0));
        for (final Map.Entry<String, List<String>> param : parameters.entrySet()) {
            if (param.getKey().startsWith("j:")) {
                final String value = getParameter(parameters, param.getKey());
                if (value != null) {
                    properties.put(param.getKey(), value);
                }
            }
        }

        JCRTemplate.getInstance().doExecuteWithSystemSession(new JCRCallback<Boolean>() {
            @Override
            public Boolean doInJCR(final JCRSessionWrapper s) throws RepositoryException {
                final JCRUserNode user = getUserManagerService().createUser(username, password, properties, s);
                s.save();

                if (getMailService().isEnabled()) {
                    // Prepare mail to be sent :
                    final boolean toAdministratorMail = Boolean.valueOf(getParameter(parameters,
                            "toAdministrator", "false"));
                    final String to = toAdministratorMail ? getMailService().getSettings()
                            .getTo() : getParameter(parameters, "to");
                    final String from = parameters.get("from") == null ? getMailService().getSettings()
                            .getFrom() : getParameter(parameters, "from");
                    final String cc = parameters.get("cc") == null ? null : getParameter(parameters, "cc");
                    final String bcc = parameters.get("bcc") == null ? null : getParameter(parameters, "bcc");

                    final Map<String, Object> bindings = new HashMap<String, Object>();
                    bindings.put("newUser", user);
                    try {
                        getMailService().sendMessageWithTemplate(getTemplatePath(),
                                bindings, to, from, cc, bcc, resource.getLocale(), "Account Management");
                    } catch (ScriptException e) {
                        LOGGER.error("Error sending e-mail notification for user creation", e);
                    }
                }
                return true;
            }
        });
        json.put("result", "success");
        return new ActionResult(HttpServletResponse.SC_ACCEPTED, null, json);
    }
}
