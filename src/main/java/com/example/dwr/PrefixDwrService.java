package com.example.dwr;

import com.example.model.Prefix;
import com.example.service.PrefixService;
import org.directwebremoting.annotations.RemoteMethod;
import org.directwebremoting.annotations.RemoteProxy;
import org.springframework.web.context.support.WebApplicationContextUtils;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.ServletContext;
import java.util.List;

@RemoteProxy(name="prefixService")
public class PrefixDwrService {
    private PrefixService svc;

    private PrefixService getSvc(){
        if(svc==null){
            HttpServletRequest req =
                    org.directwebremoting.WebContextFactory.get().getHttpServletRequest();
            ServletContext sc = req.getServletContext();
            svc = WebApplicationContextUtils
                    .getRequiredWebApplicationContext(sc)
                    .getBean(PrefixService.class);
        }
        return svc;
    }

    @RemoteMethod
    public List<Prefix> getPrefixes(
            String search, String gender, String prefixOf,
            int page, int pageSize
    ){
        return getSvc().getPrefixes(search,gender,prefixOf,page,pageSize);
    }

    @RemoteMethod
    public long count(
            String search, String gender, String prefixOf
    ){
        return getSvc().getPrefixCount(search,gender,prefixOf);
    }

    @RemoteMethod
    public Prefix create(Prefix p){
        getSvc().save(p);
        return p;
    }

    @RemoteMethod
    public void deletePrefix(Long id){
        getSvc().delete(id);
    }
}
