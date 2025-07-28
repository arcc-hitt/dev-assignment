package com.example.dao;

import com.example.model.Prefix;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import java.util.List;

@Repository
@Transactional
public class PrefixDaoImpl implements PrefixDao {

    @Autowired
    private SessionFactory sf;

    @Override
    public void save(Prefix p) {
        try {
            sf.getCurrentSession().saveOrUpdate(p);
        } catch (Exception e) {
            throw new RuntimeException("Error saving prefix: " + e.getMessage(), e);
        }
    }

    @Override
    public void delete(Long id) {
        try {
            Prefix p = get(id);
            if (p != null) {
                sf.getCurrentSession().delete(p);
            } else {
                throw new RuntimeException("Prefix with ID " + id + " not found");
            }
        } catch (Exception e) {
            throw new RuntimeException("Error deleting prefix: " + e.getMessage(), e);
        }
    }

    @Override
    public Prefix get(Long id) {
        try {
            return sf.getCurrentSession().get(Prefix.class, id);
        } catch (Exception e) {
            throw new RuntimeException("Error retrieving prefix: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Prefix> list(int page, int size, String search) {
        try {
            CriteriaBuilder cb = sf.getCurrentSession().getCriteriaBuilder();
            CriteriaQuery<Prefix> cq = cb.createQuery(Prefix.class);
            Root<Prefix> root = cq.from(Prefix.class);

            // Add search condition if provided
            if (search != null && !search.trim().isEmpty()) {
                Predicate searchPredicate = cb.like(
                        cb.lower(root.get("searchPrefix")),
                        "%" + search.toLowerCase().trim() + "%"
                );
                cq.where(searchPredicate);
            }

            // Add ordering
            cq.orderBy(cb.asc(root.get("searchPrefix")));

            Query<Prefix> query = sf.getCurrentSession().createQuery(cq);
            query.setFirstResult(page * size);
            query.setMaxResults(size);

            return query.getResultList();
        } catch (Exception e) {
            throw new RuntimeException("Error listing prefixes: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Prefix> listAll() {
        try {
            CriteriaBuilder cb = sf.getCurrentSession().getCriteriaBuilder();
            CriteriaQuery<Prefix> cq = cb.createQuery(Prefix.class);
            Root<Prefix> root = cq.from(Prefix.class);
            cq.orderBy(cb.asc(root.get("searchPrefix")));

            return sf.getCurrentSession().createQuery(cq).getResultList();
        } catch (Exception e) {
            throw new RuntimeException("Error listing all prefixes: " + e.getMessage(), e);
        }
    }

    @Override
    public void saveAll(List<Prefix> prefixes) {
        try {
            for (Prefix prefix : prefixes) {
                sf.getCurrentSession().saveOrUpdate(prefix);
            }
        } catch (Exception e) {
            throw new RuntimeException("Error saving prefixes: " + e.getMessage(), e);
        }
    }

    @Override
    public long count(String search) {
        try {
            CriteriaBuilder cb = sf.getCurrentSession().getCriteriaBuilder();
            CriteriaQuery<Long> cq = cb.createQuery(Long.class);
            Root<Prefix> root = cq.from(Prefix.class);
            cq.select(cb.count(root));

            // Add search condition if provided
            if (search != null && !search.trim().isEmpty()) {
                Predicate searchPredicate = cb.like(
                        cb.lower(root.get("searchPrefix")),
                        "%" + search.toLowerCase().trim() + "%"
                );
                cq.where(searchPredicate);
            }

            return sf.getCurrentSession().createQuery(cq).getSingleResult();
        } catch (Exception e) {
            throw new RuntimeException("Error counting prefixes: " + e.getMessage(), e);
        }
    }

    @Override
    public Prefix findBySearchPrefix(String searchPrefix) {
        try {
                        return sf.getCurrentSession()
                                         .createQuery(
                                             "SELECT p FROM Prefix p WHERE lower(p.searchPrefix) = :sp",
                                             Prefix.class
                                                 )
                                         .setParameter("sp", searchPrefix.toLowerCase().trim())
                                         .uniqueResult();
                    } catch (Exception e) {
                        throw new RuntimeException("Error looking up prefix by searchPrefix: "
                                                           + e.getMessage(), e);
                    }
            }
}