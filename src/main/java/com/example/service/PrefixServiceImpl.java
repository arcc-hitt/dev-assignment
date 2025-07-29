package com.example.service;

import com.example.dao.PrefixDao;
import com.example.model.Prefix;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
@Transactional
public class PrefixServiceImpl implements PrefixService {
    @Autowired private PrefixDao dao;

    @Override
    public List<Prefix> getPrefixes(
            String search, String gender, String prefixOf,
            int page, int pageSize
    ) {
        int offset = (page-1)*pageSize;
        return dao.list(search, gender, prefixOf, offset, pageSize);
    }

    @Override
    public long getPrefixCount(
            String search, String gender, String prefixOf
    ) {
        return dao.count(search, gender, prefixOf);
    }

    @Override
    public void save(Prefix p){
        if(p.getSearchPrefix()==null||p.getSearchPrefix().trim().isEmpty()){
            throw new IllegalArgumentException("Prefix cannot be empty");
        }
        dao.save(p);
    }

    @Override
    public void delete(Long id){
        dao.delete(id);
    }

    @Override
    public List<Prefix> listAll() {
        // Get all records without pagination for Excel export and API endpoints
        return dao.list("", "", "", 0, Integer.MAX_VALUE);
    }
}