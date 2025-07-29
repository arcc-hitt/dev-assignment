package com.example.model;

import javax.persistence.*;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.Date;

@Entity
@Table(name="item_list")
public class Item {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable=false)
    private String code;

    @Column(nullable=false)
    private String name;

    @Column
    private String category;

    @Column
    private String phone;

    @Column
    private String department;

    @Column
    private String status;

    @Column(name="created_on")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdOn;

    public Item(){}

    @PrePersist
    protected void onCreate(){
        if (createdOn==null) createdOn=new Date();
    }

    @JsonProperty public Integer getId(){ return id; }
    public void setId(Integer id){ this.id=id; }

    @JsonProperty public String getCode(){ return code; }
    public void setCode(String code){ this.code=code; }

    @JsonProperty public String getName(){ return name; }
    public void setName(String name){ this.name=name; }

    @JsonProperty public String getCategory(){ return category; }
    public void setCategory(String category){ this.category=category; }

    @JsonProperty public String getPhone(){ return phone; }
    public void setPhone(String phone){ this.phone=phone; }

    @JsonProperty public String getDepartment(){ return department; }
    public void setDepartment(String department){ this.department=department; }

    @JsonProperty public String getStatus(){ return status; }
    public void setStatus(String status){ this.status=status; }

    @JsonProperty public Date getCreatedOn(){ return createdOn; }
    public void setCreatedOn(Date createdOn){ this.createdOn=createdOn; }
}
