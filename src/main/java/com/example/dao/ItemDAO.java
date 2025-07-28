package com.example.dao;

import com.mednetlabs.model.Item;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public class ItemDAO {
    @Autowired
    private SessionFactory sessionFactory;

    public List<Item> list(String search, String category, int offset, int limit) {
        var session = sessionFactory.getCurrentSession();
        var hql = new StringBuilder("from Item where 1=1");
        if (search != null && !search.isEmpty()) {
            hql.append(" and (code like :s or name like :s)");
        }
        if (category != null && !category.isEmpty()) {
            hql.append(" and category = :c");
        }
        var q = session.createQuery(hql.toString(), Item.class);
        if (search != null && !search.isEmpty()) {
            q.setParameter("s", "%" + search + "%");
        }
        if (category != null && !category.isEmpty()) {
            q.setParameter("c", category);
        }
        q.setFirstResult(offset);
        q.setMaxResults(limit);
        return q.list();
    }

    public long count(String search, String category) {
        var session = sessionFactory.getCurrentSession();
        var hql = new StringBuilder("select count(*) from Item where 1=1");
        if (search != null && !search.isEmpty()) hql.append(" and (code like :s or name like :s)");
        if (category != null && !category.isEmpty()) hql.append(" and category = :c");
        var q = session.createQuery(hql.toString(), Long.class);
        if (search != null && !search.isEmpty()) q.setParameter("s", "%" + search + "%");
        if (category != null && !category.isEmpty()) q.setParameter("c", category);
        return q.uniqueResult();
    }
}