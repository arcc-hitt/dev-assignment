package com.example.web;
import com.example.model.Prefix;
import com.example.service.PrefixService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/prefix")
public class PrefixRestController {
    @Autowired private PrefixService svc;

    @GetMapping
    public List<Prefix> list(@RequestParam(defaultValue="0") int page,
                             @RequestParam(defaultValue="10") int size,
                             @RequestParam(required=false) String search) {
        return svc.list(page, size, search);
    }

    @GetMapping("/all")
    public List<Prefix> listAll() {
        return svc.listAll();
    }

    @PostMapping
    public ResponseEntity<String> create(@RequestBody Prefix p){ 
        svc.save(p); 
        return ResponseEntity.ok("Prefix created successfully");
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<String> delete(@PathVariable Long id){ 
        svc.delete(id); 
        return ResponseEntity.ok("Prefix deleted successfully");
    }
}
