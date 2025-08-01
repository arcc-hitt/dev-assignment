package com.example.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import javax.persistence.*;
import java.util.Objects;

/**
 * Entity class representing a prefix record in the database.
 * Contains information about search prefixes, gender associations, and prefix relationships.
 */
@Entity
@Table(name = "prefix")
public class Prefix {
    
    /**
     * Unique identifier for the prefix record.
     * Auto-generated using database identity strategy.
     */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * The search prefix term. This is the primary searchable field.
     * Cannot be null or empty.
     */
    @Column(name = "search_prefix", nullable = false, length = 50)
    private String searchPrefix;

    /**
     * Gender association for the prefix (e.g., "Male", "Female", "Unisex").
     * Optional field that can be null.
     */
    @Column(name = "gender", length = 20)
    private String gender;

    /**
     * Additional prefix information or description.
     * Optional field that can be null.
     */
    @Column(name = "prefix_of", length = 100)
    private String prefixOf;

    // Default constructor required by JPA
    public Prefix() {
    }

    /**
     * Constructor with required fields.
     * 
     * @param searchPrefix The search prefix term
     */
    public Prefix(String searchPrefix) {
        this.searchPrefix = searchPrefix;
    }

    /**
     * Constructor with all fields.
     * 
     * @param searchPrefix The search prefix term
     * @param gender The gender association
     * @param prefixOf Additional prefix information
     */
    public Prefix(String searchPrefix, String gender, String prefixOf) {
        this.searchPrefix = searchPrefix;
        this.gender = gender;
        this.prefixOf = prefixOf;
    }

    /**
     * Gets the unique identifier for this prefix record.
     * 
     * @return The prefix ID
     */
    @JsonProperty("id")
    public Long getId() {
        return id;
    }

    /**
     * Sets the unique identifier for this prefix record.
     * 
     * @param id The prefix ID to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * Gets the search prefix term.
     * 
     * @return The search prefix
     */
    @JsonProperty("searchPrefix")
    public String getSearchPrefix() {
        return searchPrefix;
    }

    /**
     * Sets the search prefix term.
     * 
     * @param searchPrefix The search prefix to set
     */
    public void setSearchPrefix(String searchPrefix) {
        this.searchPrefix = searchPrefix;
    }

    /**
     * Gets the gender association for this prefix.
     * 
     * @return The gender value
     */
    @JsonProperty("gender")
    public String getGender() {
        return gender;
    }

    /**
     * Sets the gender association for this prefix.
     * 
     * @param gender The gender value to set
     */
    public void setGender(String gender) {
        this.gender = gender;
    }

    /**
     * Gets the additional prefix information.
     * 
     * @return The prefixOf value
     */
    @JsonProperty("prefixOf")
    public String getPrefixOf() {
        return prefixOf;
    }

    /**
     * Sets the additional prefix information.
     * 
     * @param prefixOf The prefixOf value to set
     */
    public void setPrefixOf(String prefixOf) {
        this.prefixOf = prefixOf;
    }

    /**
     * Compares this prefix with another object for equality.
     * Two prefixes are considered equal if they have the same ID.
     * 
     * @param obj The object to compare with
     * @return true if the objects are equal, false otherwise
     */
    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || getClass() != obj.getClass()) {
            return false;
        }
        Prefix prefix = (Prefix) obj;
        return Objects.equals(id, prefix.id);
    }

    /**
     * Generates a hash code for this prefix object.
     * 
     * @return The hash code
     */
    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    /**
     * Returns a string representation of this prefix object.
     * 
     * @return String representation
     */
    @Override
    public String toString() {
        return "Prefix{" +
                "id=" + id +
                ", searchPrefix='" + searchPrefix + '\'' +
                ", gender='" + gender + '\'' +
                ", prefixOf='" + prefixOf + '\'' +
                '}';
    }
}
