<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Dev Assignment - Multi-Tab Application</title>
    
    <!-- DWR Scripts - Order is important for proper initialization -->
    <script type='text/javascript' src="${pageContext.request.contextPath}/dwr/engine.js"></script>
    <script type='text/javascript' src="${pageContext.request.contextPath}/dwr/util.js"></script>
    <script type='text/javascript' src="${pageContext.request.contextPath}/dwr/interface/prefixService.js"></script>
    <script type='text/javascript' src="${pageContext.request.contextPath}/dwr/interface/itemService.js"></script>

    <!-- External CSS Libraries -->
    <link rel="stylesheet" href="<c:url value='/resources/css/bootstrap.min.css'/>"/>
    <link rel="stylesheet" href="<c:url value='/resources/extjs/build/development/extjs/classic/resources/extjs-all.css'/>"/>
    <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
    
    <!-- External JavaScript Libraries -->
    <script src="<c:url value='/resources/extjs/ext/build/ext-all.js'/>"></script>
    <script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>
    <script src="<c:url value='/resources/js/jquery.min.js'/>"></script>
    <script src="<c:url value='/resources/js/bootstrap.bundle.min.js'/>"></script>

    <!-- DWR Service Availability Check and Error Handling -->
    <script type="text/javascript">
        /**
         * Checks DWR service availability and logs status for debugging.
         * This helps identify issues with DWR configuration and service loading.
         */
        function checkDwrServiceAvailability() {
            const dwrCheckDelay = 1000; // 1 second delay to ensure scripts are loaded
            
            setTimeout(function() {
                const serviceStatus = {
                    dwrEngine: false,
                    prefixService: false,
                    itemService: false
                };
                
                // Check DWR engine availability
                if (typeof dwr === 'undefined') {
                    console.error('DWR Engine Error: DWR not loaded! Check if DWR servlet is running at /dwr/engine.js');
                    displayDwrError('DWR Engine not available');
                } else {
                    console.log('DWR Engine Status: Loaded successfully');
                    serviceStatus.dwrEngine = true;
                    
                    // Configure DWR engine for better error handling
                    try {
                        dwr.engine.setAsync(true);
                        dwr.engine.setErrorHandler(function(message, exception) {
                            console.error('DWR Engine Error:', message, exception);
                        });
                        console.log('DWR Engine Configuration: Applied successfully');
                    } catch (configError) {
                        console.warn('DWR Engine Configuration Warning:', configError.message);
                    }
                }
                
                // Check prefixService availability
                if (typeof prefixService === 'undefined') {
                    console.error('DWR Service Error: prefixService not loaded!');
                    displayDwrError('Prefix Service not available');
                } else {
                    console.log('DWR Service Status: prefixService loaded successfully');
                    serviceStatus.prefixService = true;
                }
                
                // Check itemService availability
                if (typeof itemService === 'undefined') {
                    console.error('DWR Service Error: itemService not loaded!');
                    displayDwrError('Item Service not available');
                } else {
                    console.log('DWR Service Status: itemService loaded successfully');
                    serviceStatus.itemService = true;
                }
                
                // Log overall service status
                const allServicesAvailable = serviceStatus.dwrEngine && serviceStatus.prefixService && serviceStatus.itemService;
                if (allServicesAvailable) {
                    console.log('DWR Services Status: All services loaded and ready');
                } else {
                    console.warn('DWR Services Status: Some services are not available');
                }
                
            }, dwrCheckDelay);
        }
        
        /**
         * Displays DWR-related errors to the user interface.
         * 
         * @param {string} errorMessage - The error message to display
         */
        function displayDwrError(errorMessage) {
            // Create error notification if not already present
            if (!document.getElementById('dwrErrorNotification')) {
                const errorDiv = document.createElement('div');
                errorDiv.id = 'dwrErrorNotification';
                errorDiv.className = 'alert alert-warning alert-dismissible fade show position-fixed';
                errorDiv.style.cssText = 'top: 10px; right: 10px; z-index: 9999; max-width: 400px;';
                errorDiv.innerHTML = `
                    <strong>DWR Service Warning:</strong> ${errorMessage}
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                `;
                document.body.appendChild(errorDiv);
                
                // Auto-hide after 10 seconds
                setTimeout(function() {
                    if (errorDiv.parentNode) {
                        errorDiv.remove();
                    }
                }, 10000);
            }
        }
        
        /**
         * Initializes the application when the page loads.
         * Sets up DWR service checks and tab functionality.
         */
        function initializeApplication() {
            // Check DWR service availability
            checkDwrServiceAvailability();
            
            // Initialize tab functionality with error handling
            initializeTabNavigation();
        }
        
        /**
         * Initializes tab navigation with proper event handling.
         */
        function initializeTabNavigation() {
            try {
                // Ensure Bootstrap tabs are properly initialized
                if (typeof $ !== 'undefined' && $.fn.tab) {
                    console.log('Tab Navigation: Bootstrap tabs initialized');
                } else {
                    console.warn('Tab Navigation: Bootstrap tabs not available');
                }
            } catch (tabError) {
                console.error('Tab Navigation Error:', tabError.message);
            }
        }
        
        // Initialize application when DOM is ready
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', initializeApplication);
        } else {
            initializeApplication();
        }
    </script>
</head>
<body>
    <!-- Main Navigation Tabs -->
    <ul class="nav nav-tabs" id="mainTabNavigation" role="tablist" aria-label="Main application tabs">
        <li class="nav-item" role="presentation">
            <a class="nav-link active"
               id="home-tab"
               data-toggle="tab"
               href="#tab1"
               role="tab"
               aria-controls="tab1"
               aria-selected="true">
                <i class="fas fa-home"></i> Home
            </a>
        </li>
        <li class="nav-item" role="presentation">
            <a class="nav-link"
               id="popup-modal-tab"
               data-toggle="tab"
               href="#tab2"
               role="tab"
               aria-controls="tab2"
               aria-selected="false">
                <i class="fas fa-window-maximize"></i> Pop-Up Modal
            </a>
        </li>
        <li class="nav-item" role="presentation">
            <a class="nav-link"
               id="data-list-tab"
               data-toggle="tab"
               href="#tab3"
               role="tab"
               aria-controls="tab3"
               aria-selected="false">
                <i class="fas fa-list"></i> Data List
            </a>
        </li>
        <li class="nav-item" role="presentation">
            <a class="nav-link"
               id="data-entry-tab"
               data-toggle="tab"
               href="#tab4"
               role="tab"
               aria-controls="tab4"
               aria-selected="false">
                <i class="fas fa-edit"></i> Data Entry
            </a>
        </li>
        <li class="nav-item" role="presentation">
            <a class="nav-link"
               id="excel-operations-tab"
               data-toggle="tab"
               href="#tab5"
               role="tab"
               aria-controls="tab5"
               aria-selected="false">
                <i class="fas fa-file-excel"></i> Excel Operations
            </a>
        </li>
        <li class="nav-item" role="presentation">
            <a class="nav-link"
               id="rest-api-tab"
               data-toggle="tab"
               href="#tab6"
               role="tab"
               aria-controls="tab6"
               aria-selected="false">
                <i class="fas fa-code"></i> REST API
            </a>
        </li>
        <li class="nav-item" role="presentation">
            <a class="nav-link"
               id="pdf-generation-tab"
               data-toggle="tab"
               href="#tab7"
               role="tab"
               aria-controls="tab7"
               aria-selected="false">
                <i class="fas fa-file-pdf"></i> PDF Generation
            </a>
        </li>
    </ul>

    <!-- Tab Content Container -->
    <div class="tab-content p-4" id="mainTabContentContainer" role="main">
        <!-- Tab 1: Home/Dropdowns -->
        <div class="tab-pane fade show active"
             id="tab1"
             role="tabpanel"
             aria-labelledby="home-tab">
            <jsp:include page="views/tab1.jsp"/>
        </div>
        
        <!-- Tab 2: Pop-up Modal -->
        <div class="tab-pane fade"
             id="tab2"
             role="tabpanel"
             aria-labelledby="popup-modal-tab">
            <jsp:include page="views/tab2.jsp"/>
        </div>
        
        <!-- Tab 3: Data List with Pagination -->
        <div class="tab-pane fade"
             id="tab3"
             role="tabpanel"
             aria-labelledby="data-list-tab">
            <jsp:include page="views/tab3.jsp"/>
        </div>
        
        <!-- Tab 4: Data Entry with DWR -->
        <div class="tab-pane fade"
             id="tab4"
             role="tabpanel"
             aria-labelledby="data-entry-tab">
            <jsp:include page="views/tab4.jsp"/>
        </div>
        
        <!-- Tab 5: Excel Upload/Download -->
        <div class="tab-pane fade"
             id="tab5"
             role="tabpanel"
             aria-labelledby="excel-operations-tab">
            <jsp:include page="views/tab5.jsp"/>
        </div>
        
        <!-- Tab 6: REST API Operations -->
        <div class="tab-pane fade"
             id="tab6"
             role="tabpanel"
             aria-labelledby="rest-api-tab">
            <jsp:include page="views/tab6.jsp"/>
        </div>
        
        <!-- Tab 7: PDF Generation -->
        <div class="tab-pane fade"
             id="tab7"
             role="tabpanel"
             aria-labelledby="pdf-generation-tab">
            <jsp:include page="views/tab7.jsp"/>
        </div>
    </div>

    <!-- Application Footer -->
    <footer class="bg-light text-center text-muted py-3 mt-4">
    </footer>
</body>
</html>