package com.example.service;

import com.example.model.Prefix;
import java.util.List;

public interface PrefixService {
    List<Prefix> getPrefixes(
            String search, String gender, String prefixOf,
            int page, int pageSize
    );
    long getPrefixCount(String search, String gender, String prefixOf);
    void save(Prefix p);
    void delete(Long id);
}
