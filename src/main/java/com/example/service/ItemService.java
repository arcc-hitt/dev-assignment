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
    @Autowired
    private ItemDAO itemDAO;

    public List<Item> getItems(String search, String category, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        return itemDAO.list(search, category, offset, pageSize);
    }

    public long getItemCount(String search, String category) {
        return itemDAO.count(search, category);
    }
}