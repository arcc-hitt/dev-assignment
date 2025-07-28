# Dev Assignment - Mednet Labs

This is a Java web application built with Spring MVC, Hibernate, and DWR that implements all the requirements specified in the training assignment.

## Features Implemented

### Tab 1: Simple HTML Select and ExtJS Combo Dropdowns
- HTML select dropdown for Department selection
- ExtJS ComboBox for static value selection
- Both dropdowns are fully functional with hardcoded values

### Tab 2: Simple Popup with HTML Editor
- Patient details popup with form fields
- Medical categories display
- CKEditor integration for rich text editing
- Pre-populated with medical terms

### Tab 3: List Page with Paging Feature
- Data table with search and filter controls
- Pagination functionality
- Sample data showing medical staff information
- Responsive design with Bootstrap

### Tab 4: Entry Screen with Delete and List Functionality
- CRUD operations using Hibernate and DWR
- Form for adding new prefix records
- Data table with delete functionality
- Real-time updates using DWR

### Tab 5: Excel Download and Upload Feature
- Download all records in Excel format
- Download empty Excel template
- Upload Excel file with data import
- Sample data structure display

### Tab 6: Entry Screen with Delete and List Functionality using Web Service
- REST API implementation using Spring MVC
- CRUD operations via web services
- Same functionality as Tab 4 but using REST endpoints
- JSON-based communication

### Tab 7: PDF Generation from HTML Code
- Generate "Hello World" PDF
- Custom HTML to PDF conversion
- Real-time HTML preview
- Downloadable PDF files

## Technology Stack

- **Backend**: Java 11, Spring MVC 5.3.27, Hibernate 5.6.15
- **Frontend**: Bootstrap 4, jQuery, ExtJS, CKEditor 5
- **Database**: MySQL 8.0
- **Build Tool**: Maven
- **Additional Libraries**: Apache POI (Excel), DWR (Direct Web Remoting)

## Setup Instructions

1. **Database Setup**:
   - Create a MySQL database
   - Run the `prefix_schema.sql` file to create tables and sample data

2. **Configuration**:
   - Update database connection settings in `src/main/resources/application.properties`
   - Ensure all dependencies are properly configured in `pom.xml`

3. **Build and Run**:
   ```bash
   mvn clean install
   mvn tomcat7:run
   ```

4. **Access Application**:
   - Open browser and navigate to `http://localhost:8080/dev-assignment`

## API Endpoints

### REST API (Tab 6)
- `GET /api/prefix` - List prefixes with pagination
- `GET /api/prefix/all` - List all prefixes
- `POST /api/prefix` - Create new prefix
- `DELETE /api/prefix/{id}` - Delete prefix by ID

### Excel API (Tab 5)
- `GET /excel/download` - Download all records as Excel
- `GET /excel/template` - Download empty Excel template
- `POST /excel/upload` - Upload Excel file

### PDF API (Tab 7)
- `GET /pdf/hello-world` - Generate Hello World PDF
- `POST /pdf/generate` - Generate PDF from custom HTML

## DWR Services (Tab 4)
- `prefixService.list()` - List prefixes
- `prefixService.listAll()` - List all prefixes
- `prefixService.create()` - Create new prefix
- `prefixService.delete()` - Delete prefix

## Database Schema

The application uses a single table `prefix` with the following structure:
- `id` (BIGINT, Primary Key)
- `search_prefix` (VARCHAR(255), NOT NULL)
- `gender` (VARCHAR(50))
- `prefix_of` (VARCHAR(255))

## Notes

- The PDF generation feature uses HTML to PDF conversion as a simplified implementation
- All CRUD operations are fully functional with proper error handling
- The application is responsive and works on different screen sizes
- Sample data is included for demonstration purposes

## Requirements Met

✅ Tab 1: Simple HTML Select and ExtJS Combo Dropdowns (10 minutes)  
✅ Tab 2: Simple Popup with HTML Editor (10 minutes)  
✅ Tab 3: List Page with Paging Feature (60 minutes)  
✅ Tab 4: Entry Screen with Delete and List Functionality (60 minutes)  
✅ Tab 5: Excel Download and Upload Feature (60 minutes)  
✅ Tab 6: Entry Screen with Delete and List Functionality using Web Service (60 minutes)  
✅ Tab 7: PDF Generation from HTML Code using Puppeteer Library (10 minutes) 