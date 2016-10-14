package org.jahia.modules.account.manangement.actions;

import org.jahia.bin.ActionResult;
import org.jahia.services.content.JCRSessionWrapper;
import org.jahia.services.content.decorator.JCRUserNode;
import org.jahia.services.render.RenderContext;
import org.jahia.services.render.Resource;
import org.jahia.services.render.URLResolver;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

/**
 * Created by smomin on 10/13/16.
 */
public class UpdateProfileAction extends BaseAction {
    private static final Logger LOGGER = LoggerFactory.getLogger(UpdateProfileAction.class);

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
        final JCRUserNode user = getUserManagerService().lookupUser(renderContext.getUser().getUsername());
        user.setProperty("j:email", getParameter(parameters, "email"));
        user.setProperty("j:firstName", getParameter(parameters, "firstName"));
        user.setProperty("j:lastName", getParameter(parameters, "lastName"));
        for (final Map.Entry<String, List<String>> param : parameters.entrySet()) {
            if (param.getKey().startsWith("j:")) {
                final String value = getParameter(parameters, param.getKey());
                if (value != null) {
                    if (LOGGER.isDebugEnabled()) {
                        LOGGER.debug(param.getKey(), value);
                    }
                    user.setProperty(param.getKey(), value);
                }
            }
        }
        user.saveSession();
        return new ActionResult(HttpServletResponse.SC_ACCEPTED,
                getParameter(parameters, "redirectPage"));
    }
}
