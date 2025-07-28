package com.example.model;
import javax.persistence.*;
import com.fasterxml.jackson.annotation.JsonProperty;

@Entity
@Table(name="prefix")
public class Prefix {
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private Long id;

    @Column(name="search_prefix", nullable=false)
    private String searchPrefix;

    @Column(name="gender")
    private String gender;

    @Column(name="prefix_of")
    private String prefixOf;

    // Jackson will use this to emit "id"
    @JsonProperty("id")
    public Long getId() {
        return id;
    }
    public void setId(Long id) {
        this.id = id;
    }

    // Jackson will use this to emit "searchPrefix"
    @JsonProperty("searchPrefix")
    public String getSearchPrefix() {
        return searchPrefix;
    }
    public void setSearchPrefix(String searchPrefix) {
        this.searchPrefix = searchPrefix;
    }

    // Jackson will use this to emit "gender"
    @JsonProperty("gender")
    public String getGender() {
        return gender;
    }
    public void setGender(String gender) {
        this.gender = gender;
    }

    // Jackson will use this to emit "prefixOf"
    @JsonProperty("prefixOf")
    public String getPrefixOf() {
        return prefixOf;
    }
    public void setPrefixOf(String prefixOf) {
        this.prefixOf = prefixOf;
    }
}
