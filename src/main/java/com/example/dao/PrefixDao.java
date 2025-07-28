package com.example.dao;

import com.example.model.Prefix;
import java.util.List;

public interface PrefixDao {
    void save(Prefix p);
    void delete(Long id);
    Prefix get(Long id);
    List<Prefix> list(int page, int size, String search);
    List<Prefix> listAll();
    void saveAll(List<Prefix> prefixes);
    long count(String search);  // Added count method for consistency
}