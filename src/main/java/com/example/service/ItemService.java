package com.example.service;

import com.example.dao.ItemDAO;
import com.example.model.Item;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
@Transactional
public class ItemService {
    @Autowired private ItemDAO dao;

    public List<Item> getItems(
            String name, String code, String category,
            String department, String status,
            int page, int pageSize
    ) {
        int offset = (page - 1) * pageSize;
        return dao.list(name, code, category, department, status, offset, pageSize);
    }

    public long getItemCount(
            String name, String code, String category,
            String department, String status
    ) {
        return dao.count(name, code, category, department, status);
    }
}
