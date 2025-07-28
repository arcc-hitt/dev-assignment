package com.example.dwr;

import com.example.model.Prefix;
import com.example.service.PrefixService;
import org.directwebremoting.annotations.RemoteMethod;
import org.directwebremoting.annotations.RemoteProxy;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import java.util.List;

@RemoteProxy(name = "prefixService")
public class PrefixDwrService {

    private PrefixService prefixService;

    public PrefixDwrService() {
        // Constructor for DWR 'new' creator
    }

    private PrefixService getPrefixService() {
        if (prefixService == null) {
            try {
                // Get Spring context from servlet context
                HttpServletRequest request = org.directwebremoting.WebContextFactory.get().getHttpServletRequest();
                ServletContext servletContext = request.getServletContext();
                WebApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(servletContext);

                if (ctx != null) {
                    prefixService = ctx.getBean(PrefixService.class);
                } else {
                    throw new RuntimeException("Spring context not available");
                }
            } catch (Exception e) {
                throw new RuntimeException("Failed to get PrefixService from Spring context: " + e.getMessage(), e);
            }
        }
        return prefixService;
    }

    @RemoteMethod
    public List<Prefix> list(int page, int size, String search) {
        try {
            return getPrefixService().list(page, size, search);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error retrieving prefix list: " + e.getMessage(), e);
        }
    }

    @RemoteMethod
    public List<Prefix> listAll() {
        try {
            return getPrefixService().listAll();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error retrieving all prefixes: " + e.getMessage(), e);
        }
    }

    @RemoteMethod
    public Prefix create(Prefix prefix) {
        try {
            if (prefix == null) {
                throw new IllegalArgumentException("Prefix cannot be null");
            }

            if (prefix.getSearchPrefix() == null || prefix.getSearchPrefix().trim().isEmpty()) {
                throw new IllegalArgumentException("Search prefix is required");
            }

            // Trim whitespace from all fields
            prefix.setSearchPrefix(prefix.getSearchPrefix().trim());
            if (prefix.getGender() != null) {
                prefix.setGender(prefix.getGender().trim());
            }
            if (prefix.getPrefixOf() != null) {
                prefix.setPrefixOf(prefix.getPrefixOf().trim());
            }

            // Save the prefix - this will handle duplicate checking
            getPrefixService().save(prefix);

            // Return the saved prefix
            return prefix;
        } catch (IllegalArgumentException e) {
            // These are validation errors that should be shown to the user
            e.printStackTrace();
            throw new RuntimeException("Validation error: " + e.getMessage(), e);
        } catch (Exception e) {
            e.printStackTrace();
            // Check if it's a constraint violation
            String message = e.getMessage();
            if (message != null && message.toLowerCase().contains("duplicate")) {
                throw new RuntimeException("A prefix with this value already exists. Please use a different value.", e);
            } else if (message != null && message.toLowerCase().contains("constraint")) {
                throw new RuntimeException("This prefix already exists. Please choose a different one.", e);
            }
            throw new RuntimeException("Unexpected error while saving prefix: " + message, e);
        }
    }

    @RemoteMethod
    public void deletePrefix(Long id) {
        try {
            getPrefixService().delete(id);
        }
        catch (org.hibernate.StaleStateException sse) {
            // Nothing was deleted because no such ID existed
            throw new RuntimeException(
                    "Prefix with ID " + id + " not found or already deleted.",
                    sse
            );
        }
        catch (IllegalArgumentException iae) {
            // From your service layer if you check id==null, etc.
            throw new RuntimeException(iae.getMessage(), iae);
        }
        catch (Exception e) {
            throw new RuntimeException("Error deleting prefix: " + e.getMessage(), e);
        }
    }

    @RemoteMethod
    public Prefix get(Long id) {
        try {
            if (id == null) {
                throw new IllegalArgumentException("ID cannot be null");
            }

            return getPrefixService().get(id);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error retrieving prefix: " + e.getMessage(), e);
        }
    }

    @RemoteMethod
    public long count(String search) {
        try {
            return getPrefixService().count(search);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error counting prefixes: " + e.getMessage(), e);
        }
    }
}