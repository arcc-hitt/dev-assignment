package com.example.service;
import com.example.dao.PrefixDao;
import com.example.model.Prefix;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class PrefixServiceImpl implements PrefixService {
    @Autowired private PrefixDao dao;
    
    @Override public void save(Prefix p){ dao.save(p); }
    
    @Override public void delete(Long id){ dao.delete(id); }
    
    @Override public List<Prefix> list(int page,int size,String s){
        return dao.list(page,size,s);
    }
    
    @Override public List<Prefix> listAll(){
        return dao.listAll();
    }
    
    @Override public void saveAll(List<Prefix> prefixes){
        dao.saveAll(prefixes);
    }
}
