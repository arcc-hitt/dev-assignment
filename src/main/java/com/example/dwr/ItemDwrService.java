package com.example.dwr;

import com.example.model.Item;
import com.example.service.ItemService;
import org.directwebremoting.annotations.RemoteMethod;
import org.directwebremoting.annotations.RemoteProxy;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import java.util.List;

@RemoteProxy(name = "itemService")
public class ItemDwrService {

    private ItemService itemService;

    public ItemDwrService() {
        // Constructor for DWR 'new' creator
    }

    private ItemService getItemService() {
        if (itemService == null) {
            try {
                // Get Spring context from servlet context
                HttpServletRequest request = org.directwebremoting.WebContextFactory.get().getHttpServletRequest();
                ServletContext servletContext = request.getServletContext();
                WebApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(servletContext);

                if (ctx != null) {
                    itemService = ctx.getBean(ItemService.class);
                } else {
                    throw new RuntimeException("Spring context not available");
                }
            } catch (Exception e) {
                throw new RuntimeException("Failed to get ItemService from Spring context: " + e.getMessage(), e);
            }
        }
        return itemService;
    }

    @RemoteMethod
    public List<Item> getItems(String search, String category, int page, int pageSize) {
        try {
            return getItemService().getItems(search, category, page, pageSize);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error retrieving items: " + e.getMessage(), e);
        }
    }

    @RemoteMethod
    public long getItemCount(String search, String category) {
        try {
            return getItemService().getItemCount(search, category);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error counting items: " + e.getMessage(), e);
        }
    }
}