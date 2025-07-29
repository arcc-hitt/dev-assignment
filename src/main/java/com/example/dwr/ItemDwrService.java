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

@RemoteProxy(name="itemService")
public class ItemDwrService {
    private ItemService itemService;

    private ItemService getItemService(){
        if (itemService==null){
            HttpServletRequest req =
                    org.directwebremoting.WebContextFactory
                            .get().getHttpServletRequest();
            ServletContext sc = req.getServletContext();
            WebApplicationContext ctx =
                    WebApplicationContextUtils.getWebApplicationContext(sc);
            itemService = ctx.getBean(ItemService.class);
        }
        return itemService;
    }

    @RemoteMethod
    public List<Item> getItems(
            String name, String code, String category,
            String department, String status,
            int page, int pageSize
    ) {
        return getItemService()
                .getItems(name,code,category,department,status,page,pageSize);
    }

    @RemoteMethod
    public long getItemCount(
            String name, String code, String category,
            String department, String status
    ) {
        return getItemService()
                .getItemCount(name,code,category,department,status);
    }
}
