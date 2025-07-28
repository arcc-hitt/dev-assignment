package com.example.controller;

import com.example.model.Prefix;
import com.example.service.PrefixService;
import com.example.util.ExcelUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@Controller
@RequestMapping("/excel")
public class ExcelController {

    @Autowired
    private PrefixService prefixService;
    
    @Autowired
    private ExcelUtil excelUtil;

    @GetMapping("/download")
    public ResponseEntity<byte[]> downloadExcel() throws IOException {
        List<Prefix> prefixes = prefixService.listAll();
        byte[] excelData = excelUtil.exportToExcel(prefixes);
        
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"));
        headers.setContentDispositionFormData("attachment", "prefixes.xlsx");
        
        return ResponseEntity.ok()
                .headers(headers)
                .body(excelData);
    }

    @GetMapping("/template")
    public ResponseEntity<byte[]> downloadTemplate() throws IOException {
        byte[] templateData = excelUtil.createEmptyTemplate();
        
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"));
        headers.setContentDispositionFormData("attachment", "prefix_template.xlsx");
        
        return ResponseEntity.ok()
                .headers(headers)
                .body(templateData);
    }

    @PostMapping("/upload")
    @ResponseBody
    public String uploadExcel(@RequestParam("file") MultipartFile file) throws IOException {
        List<Prefix> prefixes = excelUtil.importFromExcel(file);
        prefixService.saveAll(prefixes);
        return "Successfully uploaded " + prefixes.size() + " records";
    }
}
