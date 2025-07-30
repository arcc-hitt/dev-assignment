package com.example.service;

import com.example.dao.PrefixDao;
import com.example.model.Prefix;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.List;

/**
 * Service implementation for prefix management operations.
 * Handles business logic for prefix CRUD operations including validation and data processing.
 * 
 * @author Dev Assignment
 * @version 1.0
 */
@Service
@Transactional
public class PrefixServiceImpl implements PrefixService {
    
    private static final Logger logger = LoggerFactory.getLogger(PrefixServiceImpl.class);

    @Autowired 
    private PrefixDao prefixDao;

    /**
     * Retrieves a paginated list of prefixes based on search criteria.
     * 
     * @param searchTerm Search term to filter prefixes by searchPrefix field
     * @param genderFilter Gender filter to narrow down results
     * @param prefixOfFilter PrefixOf filter to narrow down results
     * @param pageNumber Current page number (1-based)
     * @param pageSize Number of records per page
     * @return List of prefixes matching the criteria
     */
    @Override
    public List<Prefix> getPrefixes(
            String searchTerm, String genderFilter, String prefixOfFilter,
            int pageNumber, int pageSize
    ) {
        logger.debug("Retrieving prefixes with search: '{}', gender: '{}', prefixOf: '{}', page: {}, size: {}", 
                searchTerm, genderFilter, prefixOfFilter, pageNumber, pageSize);
        
        try {
            int offset = (pageNumber - 1) * pageSize;
            List<Prefix> prefixes = prefixDao.list(searchTerm, genderFilter, prefixOfFilter, offset, pageSize);
            logger.debug("Retrieved {} prefixes from database", prefixes.size());
            return prefixes;
        } catch (Exception exception) {
            logger.error("Failed to retrieve prefixes: {}", exception.getMessage(), exception);
            throw new RuntimeException("Failed to retrieve prefix records", exception);
        }
    }

    /**
     * Gets the total count of prefixes matching the search criteria.
     * 
     * @param searchTerm Search term to filter prefixes by searchPrefix field
     * @param genderFilter Gender filter to narrow down results
     * @param prefixOfFilter PrefixOf filter to narrow down results
     * @return Total count of matching prefixes
     */
    @Override
    public long getPrefixCount(
            String searchTerm, String genderFilter, String prefixOfFilter
    ) {
        logger.debug("Counting prefixes with search: '{}', gender: '{}', prefixOf: '{}'", 
                searchTerm, genderFilter, prefixOfFilter);
        
        try {
            long count = prefixDao.count(searchTerm, genderFilter, prefixOfFilter);
            logger.debug("Found {} prefixes matching criteria", count);
            return count;
        } catch (Exception exception) {
            logger.error("Failed to count prefixes: {}", exception.getMessage(), exception);
            throw new RuntimeException("Failed to count prefix records", exception);
        }
    }

    /**
     * Saves a new prefix or updates an existing one.
     * Validates the prefix data before saving to ensure data integrity.
     * 
     * @param prefixToSave The prefix object to save
     * @throws IllegalArgumentException if prefix validation fails
     */
    @Override
    public void save(Prefix prefixToSave) {
        logger.debug("Saving prefix: {}", prefixToSave.getSearchPrefix());
        
        try {
            // Validate prefix data
            validatePrefixData(prefixToSave);
            
            // Save to database
            prefixDao.save(prefixToSave);
            logger.info("Successfully saved prefix: '{}'", prefixToSave.getSearchPrefix());
            
        } catch (IllegalArgumentException validationException) {
            logger.warn("Prefix validation failed: {}", validationException.getMessage());
            throw validationException;
        } catch (Exception exception) {
            logger.error("Failed to save prefix '{}': {}", prefixToSave.getSearchPrefix(), exception.getMessage(), exception);
            throw new RuntimeException("Failed to save prefix record", exception);
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
            prefixDao.delete(prefixId);
            logger.info("Successfully deleted prefix with ID: {}", prefixId);
        } catch (Exception exception) {
            logger.error("Failed to delete prefix with ID {}: {}", prefixId, exception.getMessage(), exception);
            throw new RuntimeException("Failed to delete prefix record", exception);
        }
    }

    /**
     * Retrieves all prefix records without pagination.
     * Used for Excel export and API endpoints that need complete data.
     * 
     * @return List of all prefixes in the database
     */
    @Override
    public List<Prefix> listAll() {
        logger.debug("Retrieving all prefix records");
        
        try {
            List<Prefix> allPrefixes = prefixDao.list("", "", "", 0, Integer.MAX_VALUE);
            logger.debug("Retrieved {} total prefix records", allPrefixes.size());
            return allPrefixes;
        } catch (Exception exception) {
            logger.error("Failed to retrieve all prefixes: {}", exception.getMessage(), exception);
            throw new RuntimeException("Failed to retrieve all prefix records", exception);
        }
    }

    /**
     * Validates prefix data before saving to ensure data integrity.
     * 
     * @param prefixToValidate The prefix object to validate
     * @throws IllegalArgumentException if validation fails
     */
    private void validatePrefixData(Prefix prefixToValidate) {
        if (prefixToValidate == null) {
            throw new IllegalArgumentException("Prefix object cannot be null");
        }
        
        if (!StringUtils.hasText(prefixToValidate.getSearchPrefix())) {
            throw new IllegalArgumentException("Prefix search term cannot be empty or null");
        }
        
        // Trim and validate search prefix length
        String trimmedSearchPrefix = prefixToValidate.getSearchPrefix().trim();
        if (trimmedSearchPrefix.length() > 50) {
            throw new IllegalArgumentException("Prefix search term cannot exceed 50 characters");
        }
        
        // Validate prefixOf length if provided
        if (StringUtils.hasText(prefixToValidate.getPrefixOf()) && 
            prefixToValidate.getPrefixOf().length() > 100) {
            throw new IllegalArgumentException("PrefixOf field cannot exceed 100 characters");
        }
        
        logger.debug("Prefix validation passed for: '{}'", trimmedSearchPrefix);
    }
}