package com.example.model;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "item_list")
public class Item {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String code;
    private String name;
    private String category;

    @Column(name = "created_on")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdOn;

    // getters/setters
}