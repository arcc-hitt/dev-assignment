package com.example.dwr;

import com.example.model.Prefix;
import com.example.service.PrefixService;
import org.directwebremoting.annotations.RemoteMethod;
import org.directwebremoting.annotations.RemoteProxy;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@RemoteProxy(name = "prefixService")   // this is the name your JS will use
@Service
public class PrefixDwrService {

    @Autowired
    private PrefixService prefixService;

    @RemoteMethod  // now DWR will export this
    public List<Prefix> list(int page, int size, String search) {
        return prefixService.list(page, size, search);
    }

    @RemoteMethod
    public List<Prefix> listAll() {
        return prefixService.listAll();
    }

    @RemoteMethod
    public void create(Prefix p) {
        prefixService.save(p);
    }

    @RemoteMethod
    public void delete(Long id) {
        prefixService.delete(id);
    }
}
