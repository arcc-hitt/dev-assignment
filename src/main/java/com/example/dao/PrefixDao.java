package com.example.dao;

import com.example.model.Prefix;
import java.util.List;

public interface PrefixDao {
    List<Prefix> list(
            String search, String gender, String prefixOf,
            int offset, int limit
    );
    long count(String search, String gender, String prefixOf);
    void save(Prefix p);
    void delete(Long id);
}
