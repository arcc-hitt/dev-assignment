package com.example.web;
import com.example.model.Prefix;
import com.example.service.PrefixService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/prefix")
public class PrefixRestController {
    @Autowired private PrefixService svc;

    @GetMapping
    public List<Prefix> list(@RequestParam(defaultValue="1") int page,
                             @RequestParam(defaultValue="10") int size,
                             @RequestParam(required=false) String search,
                             @RequestParam(required=false) String gender,
                             @RequestParam(required=false) String prefixOf) {
        return svc.getPrefixes(search, gender, prefixOf, page, size);
    }

    @GetMapping("/all")
    public List<Prefix> listAll() {
        return svc.listAll();
    }

    @GetMapping("/count")
    public Map<String, Object> getCount(@RequestParam(required=false) String search,
                                        @RequestParam(required=false) String gender,
                                        @RequestParam(required=false) String prefixOf) {
        Map<String, Object> response = new HashMap<>();
        response.put("count", svc.getPrefixCount(search, gender, prefixOf));
        return response;
    }

    @PostMapping
    public ResponseEntity<String> create(@RequestBody Prefix p){
        try {
            svc.save(p);
            return ResponseEntity.ok("Prefix created successfully");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error: " + e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<String> delete(@PathVariable Long id){
        try {
            svc.delete(id);
            return ResponseEntity.ok("Prefix deleted successfully");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error: " + e.getMessage());
        }
    }
}