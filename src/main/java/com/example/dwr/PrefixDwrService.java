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
            throw new RuntimeException("Error retrieving prefix list: " + e.getMessage(), e);
        }
    }

    @RemoteMethod
    public List<Prefix> listAll() {
        try {
            return getPrefixService().listAll();
        } catch (Exception e) {
            throw new RuntimeException("Error retrieving all prefixes: " + e.getMessage(), e);
        }
    }

    @RemoteMethod
    public void create(Prefix prefix) {
        try {
            if (prefix == null) {
                throw new IllegalArgumentException("Prefix cannot be null");
            }

            if (prefix.getSearchPrefix() == null || prefix.getSearchPrefix().trim().isEmpty()) {
                throw new IllegalArgumentException("Search prefix is required");
            }

            // Trim whitespace
            prefix.setSearchPrefix(prefix.getSearchPrefix().trim());
            if (prefix.getGender() != null) {
                prefix.setGender(prefix.getGender().trim());
            }
            if (prefix.getPrefixOf() != null) {
                prefix.setPrefixOf(prefix.getPrefixOf().trim());
            }

            getPrefixService().save(prefix);
        } catch (Exception e) {
            throw new RuntimeException("Error creating prefix: " + e.getMessage(), e);
        }
    }

    @RemoteMethod
    public void delete(Long id) {
        try {
            if (id == null) {
                throw new IllegalArgumentException("ID cannot be null");
            }

            getPrefixService().delete(id);
        } catch (Exception e) {
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
            throw new RuntimeException("Error retrieving prefix: " + e.getMessage(), e);
        }
    }

    @RemoteMethod
    public long count(String search) {
        try {
            return getPrefixService().count(search);
        } catch (Exception e) {
            throw new RuntimeException("Error counting prefixes: " + e.getMessage(), e);
        }
    }
}