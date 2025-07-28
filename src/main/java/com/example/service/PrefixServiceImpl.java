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

        // Trim whitespace to ensure consistent comparison
        if (p.getSearchPrefix() != null) {
            p.setSearchPrefix(p.getSearchPrefix().trim());
        }

        if (p.getSearchPrefix() == null || p.getSearchPrefix().isEmpty()) {
            throw new IllegalArgumentException("Search prefix cannot be empty");
        }

        // Check for existing prefix with case-insensitive comparison
        Prefix existing = dao.findBySearchPrefix(p.getSearchPrefix());

        // For new records (p.getId() == null), reject if any duplicate exists
        // For updates (p.getId() != null), allow only if it's the same record being updated
        if (existing != null && (p.getId() == null || !existing.getId().equals(p.getId()))) {
            throw new IllegalArgumentException(
                    "Prefix '" + p.getSearchPrefix() + "' already exists."
            );
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

        // Validate each prefix before batch save
        for (Prefix prefix : prefixes) {
            if (prefix.getSearchPrefix() != null) {
                prefix.setSearchPrefix(prefix.getSearchPrefix().trim());
            }

            if (prefix.getSearchPrefix() == null || prefix.getSearchPrefix().isEmpty()) {
                throw new IllegalArgumentException("Search prefix cannot be empty for batch save");
            }

            // Check for duplicates within the batch and against existing data
            Prefix existing = dao.findBySearchPrefix(prefix.getSearchPrefix());
            if (existing != null && (prefix.getId() == null || !existing.getId().equals(prefix.getId()))) {
                throw new IllegalArgumentException(
                        "Prefix '" + prefix.getSearchPrefix() + "' already exists in batch save."
                );
            }
        }

        dao.saveAll(prefixes);
    }

    @Override
    public long count(String search) {
        return dao.count(search);
    }
}