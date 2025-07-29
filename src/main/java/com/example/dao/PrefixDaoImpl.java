package com.example.dao;

import com.example.model.Prefix;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public class PrefixDaoImpl implements PrefixDao {
    @Autowired private SessionFactory sf;

    private boolean isEmpty(String s){
        return s==null || s.trim().isEmpty();
    }

    @Override
    public List<Prefix> list(
            String search, String gender, String prefixOf,
            int offset, int limit
    ) {
        var hql = new StringBuilder("FROM Prefix WHERE 1=1");
        if(!isEmpty(search))   hql.append(" AND LOWER(searchPrefix) LIKE :s");
        if(!isEmpty(gender))   hql.append(" AND gender = :g");
        if(!isEmpty(prefixOf)) hql.append(" AND prefixOf LIKE :p");

        var sess = sf.getCurrentSession();
        var q = sess.createQuery(hql.toString(), Prefix.class);
        if(!isEmpty(search))   q.setParameter("s","%"+search.toLowerCase()+"%");
        if(!isEmpty(gender))   q.setParameter("g",gender);
        if(!isEmpty(prefixOf)) q.setParameter("p","%"+prefixOf+"%");

        q.setFirstResult(offset);
        q.setMaxResults(limit);
        return q.list();
    }

    @Override
    public long count(
            String search, String gender, String prefixOf
    ) {
        var hql = new StringBuilder("SELECT COUNT(*) FROM Prefix WHERE 1=1");
        if(!isEmpty(search))   hql.append(" AND LOWER(searchPrefix) LIKE :s");
        if(!isEmpty(gender))   hql.append(" AND gender = :g");
        if(!isEmpty(prefixOf)) hql.append(" AND prefixOf LIKE :p");

        var q = sf.getCurrentSession().createQuery(hql.toString(), Long.class);
        if(!isEmpty(search))   q.setParameter("s","%"+search.toLowerCase()+"%");
        if(!isEmpty(gender))   q.setParameter("g",gender);
        if(!isEmpty(prefixOf)) q.setParameter("p","%"+prefixOf+"%");

        return q.uniqueResult();
    }

    @Override
    public void save(Prefix p){
        sf.getCurrentSession().saveOrUpdate(p);
    }

    @Override
    public void delete(Long id){
        var obj = sf.getCurrentSession().get(Prefix.class,id);
        if(obj!=null) sf.getCurrentSession().delete(obj);
    }
}
