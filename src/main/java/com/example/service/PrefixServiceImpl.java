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

    @Autowired
    private PrefixDao dao;

    @Override
    public void save(Prefix p) {
        if (p == null) {
            throw new IllegalArgumentException("Prefix cannot be null");
        }
        dao.save(p);
    }

    @Override
    public void delete(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("ID cannot be null");
        }
        dao.delete(id);
    }

    @Override
    public Prefix get(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("ID cannot be null");
        }
        return dao.get(id);
    }

    @Override
    public List<Prefix> list(int page, int size, String search) {
        return dao.list(page, size, search);
    }

    @Override
    public List<Prefix> listAll() {
        return dao.listAll();
    }

    @Override
    public void saveAll(List<Prefix> prefixes) {
        if (prefixes == null) {
            throw new IllegalArgumentException("Prefixes list cannot be null");
        }
        dao.saveAll(prefixes);
    }

    @Override
    public long count(String search) {
        List<Prefix> allPrefixes = dao.listAll();
        if (search == null || search.trim().isEmpty()) {
            return allPrefixes.size();
        }

        String searchLower = search.toLowerCase().trim();
        return allPrefixes.stream()
                .filter(p -> p.getSearchPrefix() != null &&
                        p.getSearchPrefix().toLowerCase().contains(searchLower))
                .count();
    }
}