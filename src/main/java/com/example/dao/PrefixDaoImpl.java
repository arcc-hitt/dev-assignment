package com.example.dao;
import com.example.model.Prefix;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import javax.transaction.Transactional;
import java.util.List;

@Repository
@Transactional
public class PrefixDaoImpl implements PrefixDao {
    @Autowired private SessionFactory sf;

    @Override
    public void save(Prefix p) { sf.getCurrentSession().saveOrUpdate(p); }

    @Override
    public void delete(Long id) {
        Prefix p = get(id);
        if(p!=null) sf.getCurrentSession().delete(p);
    }

    @Override
    public Prefix get(Long id) {
        return sf.getCurrentSession().get(Prefix.class, id);
    }

    @Override
    public List<Prefix> list(int page, int size, String search) {
        var cb = sf.getCurrentSession().getCriteriaBuilder();
        var cq = cb.createQuery(Prefix.class);
        var root = cq.from(Prefix.class);
        if(search!=null && !search.isEmpty()) {
            cq.where(cb.like(root.get("searchPrefix"), "%" + search + "%"));
        }
        return sf.getCurrentSession()
                .createQuery(cq)
                .setFirstResult(page*size)
                .setMaxResults(size)
                .getResultList();
    }

    @Override
    public List<Prefix> listAll() {
        var cb = sf.getCurrentSession().getCriteriaBuilder();
        var cq = cb.createQuery(Prefix.class);
        var root = cq.from(Prefix.class);
        return sf.getCurrentSession().createQuery(cq).getResultList();
    }

    @Override
    public void saveAll(List<Prefix> prefixes) {
        for (Prefix prefix : prefixes) {
            sf.getCurrentSession().saveOrUpdate(prefix);
        }
    }
}
