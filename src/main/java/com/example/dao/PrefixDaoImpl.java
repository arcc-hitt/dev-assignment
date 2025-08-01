package com.example.dao;

import com.example.model.Prefix;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.util.StringUtils;

import java.util.List;

/**
 * Data Access Object implementation for Prefix entity.
 * Handles database operations for prefix records using Hibernate.
 */
@Repository
public class PrefixDaoImpl implements PrefixDao {
    
    private static final Logger logger = LoggerFactory.getLogger(PrefixDaoImpl.class);

    @Autowired 
    private SessionFactory sessionFactory;

    /**
     * Checks if a string is null or empty after trimming.
     * 
     * @param stringToCheck The string to validate
     * @return true if the string is null or empty, false otherwise
     */
    private boolean isNullOrEmpty(String stringToCheck) {
        return !StringUtils.hasText(stringToCheck);
    }

    /**
     * Retrieves a paginated list of prefixes based on search criteria.
     * 
     * @param searchTerm Search term to filter prefixes by searchPrefix field
     * @param genderFilter Gender filter to narrow down results
     * @param prefixOfFilter PrefixOf filter to narrow down results
     * @param offset Starting position for pagination
     * @param limit Maximum number of records to return
     * @return List of prefixes matching the criteria
     */
    @Override
    public List<Prefix> list(
            String searchTerm, String genderFilter, String prefixOfFilter,
            int offset, int limit
    ) {
        logger.debug("Querying prefixes with search: '{}', gender: '{}', prefixOf: '{}', offset: {}, limit: {}", 
                searchTerm, genderFilter, prefixOfFilter, offset, limit);
        
        try {
            Session currentSession = sessionFactory.getCurrentSession();
            
            // Build dynamic HQL query based on provided filters
            StringBuilder hqlQuery = new StringBuilder("FROM Prefix WHERE 1=1");
            
            if (!isNullOrEmpty(searchTerm)) {
                hqlQuery.append(" AND LOWER(searchPrefix) LIKE :searchParam");
            }
            if (!isNullOrEmpty(genderFilter)) {
                hqlQuery.append(" AND gender = :genderParam");
            }
            if (!isNullOrEmpty(prefixOfFilter)) {
                hqlQuery.append(" AND prefixOf LIKE :prefixOfParam");
            }

            // Create and configure query
            Query<Prefix> query = currentSession.createQuery(hqlQuery.toString(), Prefix.class);
            
            // Set parameters for dynamic query
            if (!isNullOrEmpty(searchTerm)) {
                query.setParameter("searchParam", "%" + searchTerm.toLowerCase() + "%");
            }
            if (!isNullOrEmpty(genderFilter)) {
                query.setParameter("genderParam", genderFilter);
            }
            if (!isNullOrEmpty(prefixOfFilter)) {
                query.setParameter("prefixOfParam", "%" + prefixOfFilter + "%");
            }

            // Set pagination parameters
            query.setFirstResult(offset);
            query.setMaxResults(limit);
            
            List<Prefix> results = query.list();
            logger.debug("Retrieved {} prefixes from database", results.size());
            return results;
            
        } catch (Exception exception) {
            logger.error("Failed to retrieve prefixes from database: {}", exception.getMessage(), exception);
            throw new RuntimeException("Database error while retrieving prefixes", exception);
        }
    }

    /**
     * Counts the total number of prefixes matching the search criteria.
     * 
     * @param searchTerm Search term to filter prefixes by searchPrefix field
     * @param genderFilter Gender filter to narrow down results
     * @param prefixOfFilter PrefixOf filter to narrow down results
     * @return Total count of matching prefixes
     */
    @Override
    public long count(
            String searchTerm, String genderFilter, String prefixOfFilter
    ) {
        logger.debug("Counting prefixes with search: '{}', gender: '{}', prefixOf: '{}'", 
                searchTerm, genderFilter, prefixOfFilter);
        
        try {
            Session currentSession = sessionFactory.getCurrentSession();
            
            // Build dynamic count query based on provided filters
            StringBuilder countHql = new StringBuilder("SELECT COUNT(*) FROM Prefix WHERE 1=1");
            
            if (!isNullOrEmpty(searchTerm)) {
                countHql.append(" AND LOWER(searchPrefix) LIKE :searchParam");
            }
            if (!isNullOrEmpty(genderFilter)) {
                countHql.append(" AND gender = :genderParam");
            }
            if (!isNullOrEmpty(prefixOfFilter)) {
                countHql.append(" AND prefixOf LIKE :prefixOfParam");
            }

            // Create and configure count query
            Query<Long> countQuery = currentSession.createQuery(countHql.toString(), Long.class);
            
            // Set parameters for dynamic query
            if (!isNullOrEmpty(searchTerm)) {
                countQuery.setParameter("searchParam", "%" + searchTerm.toLowerCase() + "%");
            }
            if (!isNullOrEmpty(genderFilter)) {
                countQuery.setParameter("genderParam", genderFilter);
            }
            if (!isNullOrEmpty(prefixOfFilter)) {
                countQuery.setParameter("prefixOfParam", "%" + prefixOfFilter + "%");
            }

            Long result = countQuery.uniqueResult();
            long count = result != null ? result : 0;
            logger.debug("Found {} prefixes matching criteria", count);
            return count;
            
        } catch (Exception exception) {
            logger.error("Failed to count prefixes in database: {}", exception.getMessage(), exception);
            throw new RuntimeException("Database error while counting prefixes", exception);
        }
    }

    /**
     * Saves a new prefix or updates an existing one.
     * 
     * @param prefixToSave The prefix object to save or update
     */
    @Override
    public void save(Prefix prefixToSave) {
        logger.debug("Saving prefix: '{}'", prefixToSave.getSearchPrefix());
        
        try {
            Session currentSession = sessionFactory.getCurrentSession();
            currentSession.saveOrUpdate(prefixToSave);
            logger.debug("Successfully saved prefix: '{}'", prefixToSave.getSearchPrefix());
            
        } catch (Exception exception) {
            logger.error("Failed to save prefix '{}': {}", prefixToSave.getSearchPrefix(), exception.getMessage(), exception);
            throw new RuntimeException("Database error while saving prefix", exception);
        }
    }

    /**
     * Deletes a prefix by its ID.
     * 
     * @param prefixId The ID of the prefix to delete
     */
    @Override
    public void delete(Long prefixId) {
        logger.debug("Deleting prefix with ID: {}", prefixId);
        
        try {
            Session currentSession = sessionFactory.getCurrentSession();
            
            // First retrieve the prefix to ensure it exists
            Prefix prefixToDelete = currentSession.get(Prefix.class, prefixId);
            
            if (prefixToDelete != null) {
                currentSession.delete(prefixToDelete);
                logger.debug("Successfully deleted prefix with ID: {}", prefixId);
            } else {
                logger.warn("Attempted to delete non-existent prefix with ID: {}", prefixId);
                // Optionally throw an exception for non-existent records
                // throw new IllegalArgumentException("Prefix with ID " + prefixId + " not found");
            }
            
        } catch (Exception exception) {
            logger.error("Failed to delete prefix with ID {}: {}", prefixId, exception.getMessage(), exception);
            throw new RuntimeException("Database error while deleting prefix", exception);
        }
    }
}
