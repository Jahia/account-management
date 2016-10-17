package org.jahia.modules.account.manangement.actions;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang.StringUtils;
import org.jahia.bin.ActionResult;
import org.jahia.bin.Jahia;
import org.jahia.bin.Render;
import org.jahia.services.content.JCRSessionWrapper;
import org.jahia.services.content.decorator.JCRUserNode;
import org.jahia.services.mail.MailService;
import org.jahia.services.render.RenderContext;
import org.jahia.services.render.Resource;
import org.jahia.services.render.URLResolver;
import org.jahia.services.usermanager.JahiaUserManagerService;
import org.jahia.utils.Url;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.jcr.RepositoryException;
import javax.servlet.http.HttpServletRequest;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import static javax.servlet.http.HttpServletResponse.SC_ACCEPTED;
import static javax.servlet.http.HttpServletResponse.SC_OK;

/**
 * Created by smomin on 10/13/16.
 */
public class RecoverPasswordAction extends BaseAction {
    private static final Logger LOGGER = LoggerFactory.getLogger(RecoverPasswordAction.class);
    protected static final String PROPERTY_PASSWORD_RECOVERY_TOKEN = "j:passwordRecoveryToken";
    protected static final String SESSION_ATTRIBUTE_PASSWORD_RECOVERY_ASKED = "passwordRecoveryAsked";

    private int passwordRecoveryTimeoutSeconds;

    /**
     *
     * @param user
     * @param passwordRecoveryTimeout
     * @return
     * @throws RepositoryException
     */
    private static String generateToken(final JCRUserNode user,
                                        final int passwordRecoveryTimeout) throws RepositoryException {
        final String path = user.getPath();
        final long timestamp = System.currentTimeMillis();
        final String authKey = DigestUtils.md5Hex(path
                + timestamp)
                + '|'
                + (timestamp
                + passwordRecoveryTimeout
                * 1000L);
        user.setProperty(PROPERTY_PASSWORD_RECOVERY_TOKEN, authKey);
        user.getSession().save();

        try {
            return Base64.encodeBase64URLSafeString((path + "|" + authKey).getBytes("UTF-8"));
        } catch (UnsupportedEncodingException e) {
            throw new IllegalArgumentException(e);
        }
    }

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
        if (StringUtils.isEmpty(username)) {
            return ActionResult.BAD_REQUEST;
        }

        final Locale locale = renderContext.getUILocale();
        if (request.getSession().getAttribute(SESSION_ATTRIBUTE_PASSWORD_RECOVERY_ASKED) != null) {
            return result(SC_OK, "passwordrecovery.mail.alreadysent", locale);
        }

        final String siteKey = resource.getNode().getResolveSite().getSiteKey();
        final JCRUserNode user = getUserManagerService().lookupUser(username, siteKey, true);
        if (user == null || user.isRoot() || JahiaUserManagerService.isGuest(user)) {
            return result(SC_OK, "passwordrecovery.username.invalid", locale);
        }

        final String to = user.getPropertyAsString("j:email");
        if (to == null || !MailService.isValidEmailAddress(to, false)) {
            return result(SC_OK, "passwordrecovery.mail.invalid", locale);
        }

        final String from = getMailService().getSettings().getFrom();
        final String token = generateToken(user, passwordRecoveryTimeoutSeconds > 0 ? passwordRecoveryTimeoutSeconds
                : request.getSession().getMaxInactiveInterval());
        final Map<String, Object> bindings = new HashMap<String, Object>();
        final String link = Url.getServer(request)
                + Jahia.getContextPath()
                + Render.getRenderServletPath()
                + "/live/"
                + resource.getLocale().getLanguage()
                + resource.getNode().getProperty("updatePasswordPage").getNode().getPath()
                + ".html?key=" + token;
        if (LOGGER.isDebugEnabled()) {
            LOGGER.debug("link", link);
        }
        bindings.put("link", link);
        bindings.put("user", user);

        getMailService().sendMessageWithTemplate(getTemplatePath(), bindings, to, from,
                null, null, resource.getLocale(), "Account Management");
        request.getSession().setAttribute(SESSION_ATTRIBUTE_PASSWORD_RECOVERY_ASKED, true);

        return result(SC_ACCEPTED, "passwordrecovery.mail.sent", locale);
    }

    /**
     *
     * @param code
     * @param messageKey
     * @param locale
     * @return
     * @throws JSONException
     */
    private ActionResult result(final int code,
                                final String messageKey,
                                final Locale locale) throws JSONException {
        final JSONObject json = new JSONObject();
        json.put("message", getI18nMessage(messageKey, locale));
        return new ActionResult(code, null, json);
    }

    /**
     * Set the timeout in seconds, after which the password reset token expires. If a positive non-zero value
     * is provided here, it will be used. Otherwise, a current value of the HTTP session timeout will be used
     * for expiration.
     *
     * @param passwordRecoveryTimeoutSeconds the timeout in seconds, after which the password reset token expires.
     *                                       If a positive value is provided here, it will be used. Otherwise, a
     *                                       current value of the HTTP session timeout will be used for expiration
     */
    public void setPasswordRecoveryTimeoutSeconds(final int passwordRecoveryTimeoutSeconds) {
        this.passwordRecoveryTimeoutSeconds = passwordRecoveryTimeoutSeconds;
    }
}
