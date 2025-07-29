package com.example.dao;

import com.example.model.Item;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public class ItemDAO {
    @Autowired private SessionFactory sessionFactory;

    public List<Item> list(
            String name, String code, String category,
            String department, String status,
            int offset, int limit
    ) {
        var hql = new StringBuilder("from Item where 1=1");
        if (!isEmpty(name))       hql.append(" and name like :name");
        if (!isEmpty(code))       hql.append(" and code like :code");
        if (!isEmpty(category))   hql.append(" and category = :cat");
        if (!isEmpty(department)) hql.append(" and department = :dept");
        if (!isEmpty(status))     hql.append(" and status = :stat");

        var session = sessionFactory.getCurrentSession();
        var q = session.createQuery(hql.toString(), Item.class);

        if (!isEmpty(name))       q.setParameter("name","%"+name+"%");
        if (!isEmpty(code))       q.setParameter("code","%"+code+"%");
        if (!isEmpty(category))   q.setParameter("cat",category);
        if (!isEmpty(department)) q.setParameter("dept",department);
        if (!isEmpty(status))     q.setParameter("stat",status);

        q.setFirstResult(offset);
        q.setMaxResults(limit);
        return q.list();
    }

    public long count(
            String name, String code, String category,
            String department, String status
    ) {
        var hql = new StringBuilder("select count(*) from Item where 1=1");
        if (!isEmpty(name))       hql.append(" and name like :name");
        if (!isEmpty(code))       hql.append(" and code like :code");
        if (!isEmpty(category))   hql.append(" and category = :cat");
        if (!isEmpty(department)) hql.append(" and department = :dept");
        if (!isEmpty(status))     hql.append(" and status = :stat");

        var q = sessionFactory.getCurrentSession()
                .createQuery(hql.toString(), Long.class);
        if (!isEmpty(name))       q.setParameter("name","%"+name+"%");
        if (!isEmpty(code))       q.setParameter("code","%"+code+"%");
        if (!isEmpty(category))   q.setParameter("cat",category);
        if (!isEmpty(department)) q.setParameter("dept",department);
        if (!isEmpty(status))     q.setParameter("stat",status);

        return q.uniqueResult();
    }

    private boolean isEmpty(String s){
        return s==null || s.trim().isEmpty();
    }
}
