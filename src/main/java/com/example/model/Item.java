package com.example.model;

import javax.persistence.*;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.Date;

@Entity
@Table(name = "item_list")
public class Item {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "code", nullable = false)
    private String code;

    @Column(name = "name", nullable = false)
    private String name;

    @Column(name = "category")
    private String category;

    @Column(name = "created_on")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdOn;

    // Constructors
    public Item() {}

    public Item(String code, String name, String category) {
        this.code = code;
        this.name = name;
        this.category = category;
        this.createdOn = new Date();
    }

    // Getters and Setters with JSON annotations
    @JsonProperty("id")
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    @JsonProperty("code")
    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    @JsonProperty("name")
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @JsonProperty("category")
    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    @JsonProperty("createdOn")
    public Date getCreatedOn() {
        return createdOn;
    }

    public void setCreatedOn(Date createdOn) {
        this.createdOn = createdOn;
    }

    @PrePersist
    protected void onCreate() {
        if (createdOn == null) {
            createdOn = new Date();
        }
    }

    @Override
    public String toString() {
        return "Item{" +
                "id=" + id +
                ", code='" + code + '\'' +
                ", name='" + name + '\'' +
                ", category='" + category + '\'' +
                ", createdOn=" + createdOn +
                '}';
    }
}