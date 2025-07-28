<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Dev Assignment</title>
    <link rel="stylesheet" href="<c:url value='/resources/css/bootstrap.min.css'/>"/>
    <link rel="stylesheet" href="<c:url value='/resources/extjs/build/development/extjs/classic/resources/extjs-all.css'/>"/>
    <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
    <script src="<c:url value='/resources/extjs/ext/build/ext-all.js'/>"></script>
    <script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>
    <script type="text/javascript" src="<c:url value='/dwr/engine.js'/>"></script>
    <script type="text/javascript" src="<c:url value='/dwr/util.js'/>"></script>
    <script src="<c:url value='/dwr/interface/prefixService.js'/>"></script>
    <script src="<c:url value='/resources/js/jquery.min.js'/>"></script>
    <script src="<c:url value='/resources/js/bootstrap.bundle.min.js'/>"></script>
</head>
<body>
<!-- Nav tabs -->
<ul class="nav nav-tabs" id="mainTabNav" role="tablist">
    <li class="nav-item">
        <a class="nav-link active"
           id="dropdowns-tab"
           data-toggle="tab"
           href="#tab1"
           role="tab"
           aria-controls="tab1"
           aria-selected="true">
            Home
        </a>
    </li>
    <li class="nav-item">
        <a class="nav-link"
           id="popup-tab"
           data-toggle="tab"
           href="#tab2"
           role="tab"
           aria-controls="tab2"
           aria-selected="false">
            Pop-Up
        </a>
    </li>
    <li class="nav-item">
        <a class="nav-link"
           id="list-tab"
           data-toggle="tab"
           href="#tab3"
           role="tab"
           aria-controls="tab3"
           aria-selected="false">
            List
        </a>
    </li>
    <li class="nav-item">
        <a class="nav-link"
           id="dwr-tab"
           data-toggle="tab"
           href="#tab4"
           role="tab"
           aria-controls="tab4"
           aria-selected="false">
            Entry Screen
        </a>
    </li>
    <li class="nav-item">
        <a class="nav-link"
           id="excel-tab"
           data-toggle="tab"
           href="#tab5"
           role="tab"
           aria-controls="tab5"
           aria-selected="false">
            Excel upload and download
        </a>
    </li>
    <li class="nav-item">
        <a class="nav-link"
           id="rest-tab"
           data-toggle="tab"
           href="#tab6"
           role="tab"
           aria-controls="tab6"
           aria-selected="false">
            Node Js (Preview and Print)
        </a>
    </li>
    <li class="nav-item">
        <a class="nav-link"
           id="pdf-tab"
           data-toggle="tab"
           href="#tab7"
           role="tab"
           aria-controls="tab7"
           aria-selected="false">
            PDF Generation
        </a>
    </li>
</ul>

<!-- Tab panes -->
<div class="tab-content p-4" id="mainTabContent">
    <div class="tab-pane fade show active"
         id="tab1"
         role="tabpanel"
         aria-labelledby="dropdowns-tab">
        <jsp:include page="views/tab1.jsp"/>
    </div>
    <div class="tab-pane fade"
         id="tab2"
         role="tabpanel"
         aria-labelledby="popup-tab">
        <jsp:include page="views/tab2.jsp"/>
    </div>
    <div class="tab-pane fade"
         id="tab3"
         role="tabpanel"
         aria-labelledby="list-tab">
        <jsp:include page="views/tab3.jsp"/>
    </div>
    <div class="tab-pane fade"
         id="tab4"
         role="tabpanel"
         aria-labelledby="dwr-tab">
        <jsp:include page="views/tab4.jsp"/>
    </div>
    <div class="tab-pane fade"
         id="tab5"
         role="tabpanel"
         aria-labelledby="excel-tab">
        <jsp:include page="views/tab5.jsp"/>
    </div>
    <div class="tab-pane fade"
         id="tab6"
         role="tabpanel"
         aria-labelledby="rest-tab">
        <jsp:include page="views/tab6.jsp"/>
    </div>
    <div class="tab-pane fade"
         id="tab7"
         role="tabpanel"
         aria-labelledby="pdf-tab">
        <jsp:include page="views/tab7.jsp"/>
    </div>
</div>
</body>
</html>
