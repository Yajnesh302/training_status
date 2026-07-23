<%@ Page Title="Training Status Portal" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="TrainingStatus.aspx.cs" Inherits="TrainingStatusPortal.TrainingStatus" EnableEventValidation="false" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
        <style>
            /* Custom Modern Dashboard Styles */
            body {
                background-color: #f3f4f6;
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            }

            /* Page Banner */
            .portal-header-card {
                background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
                border-radius: 0.5rem;
                color: #ffffff;
                box-shadow: 0 0.25rem 0.75rem rgba(30, 60, 114, 0.15);
            }

            /* Filter Card Styling */
            .filter-card {
                border: none;
                border-top: 4px solid #2a5298;
                border-radius: 0.5rem;
                background-color: #ffffff;
                box-shadow: 0 0.125rem 0.375rem rgba(0, 0, 0, 0.05);
            }

            .filter-card-header {
                background-color: #ffffff;
                border-bottom: 1px solid #e2e8f0;
                padding: 1rem 1.25rem;
            }

            .filter-label {
                font-size: 0.78rem;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                color: #475569;
                margin-bottom: 0.35rem;
            }

            /* Input Controls */
            .form-control-custom {
                font-size: 0.875rem;
                border-radius: 0.375rem;
                border: 1px solid #cbd5e1;
                background-color: #f8fafc;
                color: #0f172a;
                transition: all 0.2s ease-in-out;
            }

            .form-control-custom:focus {
                background-color: #ffffff;
                border-color: #2563eb;
                box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
            }

            /* Autocomplete Suggestions Overlay Styling */
            .autocomplete-suggestions {
                position: absolute;
                top: 100%;
                left: 0;
                right: 0;
                z-index: 1050;
                background: #ffffff;
                border: 1px solid #94a3b8;
                border-radius: 0.375rem;
                box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.12);
                margin-top: 4px;
                max-height: 200px;
                overflow-y: auto;
                padding: 4px 0;
            }

            .autocomplete-suggestion {
                padding: 6px 12px;
                font-size: 0.85rem;
                line-height: 1.35;
                color: #334155;
                cursor: pointer;
                border-bottom: 1px solid #f8fafc;
                transition: background 0.15s ease;
            }

            .autocomplete-suggestion:last-child {
                border-bottom: none;
            }

            .autocomplete-suggestion:hover,
            .autocomplete-suggestion.active {
                background-color: #2563eb;
                color: #ffffff;
            }

            /* Single-Field Searchable Combobox Styling */
            .combobox-container {
                position: relative;
            }

            .combobox-field {
                background-color: #f8fafc !important;
                border: 1px solid #cbd5e1;
                border-radius: 0.375rem;
                padding: 0.375rem 2rem 0.375rem 0.75rem;
                font-size: 0.875rem;
                cursor: pointer;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
                user-select: none;
                display: flex;
                align-items: center;
                height: calc(1.8125rem + 10px);
                color: #0f172a;
                transition: all 0.2s ease-in-out;
            }

            .combobox-field:hover {
                border-color: #2563eb;
                background-color: #ffffff !important;
            }

            .combobox-icon {
                position: absolute;
                right: 12px;
                top: 50%;
                transform: translateY(-50%);
                pointer-events: none;
                color: #64748b;
                font-size: 0.75rem;
            }

            .combobox-dropdown {
                position: absolute;
                top: 100%;
                left: 0;
                right: 0;
                z-index: 1050;
                background: #ffffff;
                border: 1px solid #94a3b8;
                border-radius: 0.375rem;
                box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.12);
                margin-top: 4px;
                padding: 6px 0 2px 0;
            }

            .combobox-search-box {
                padding: 0 8px 6px 8px;
                border-bottom: 1px solid #f1f5f9;
            }

            .combobox-search-input {
                font-size: 0.8rem;
                padding: 0.3rem 0.6rem;
                border-radius: 0.25rem;
                border: 1px solid #cbd5e1;
                background-color: #f8fafc;
            }

            .combobox-search-input:focus {
                background-color: #ffffff;
                border-color: #2563eb;
                box-shadow: 0 0 0 2px rgba(37, 99, 235, 0.15);
            }

            .combobox-list {
                max-height: 200px;
                overflow-y: auto;
            }

            .combobox-item {
                padding: 6px 12px;
                font-size: 0.85rem;
                line-height: 1.35;
                color: #334155;
                cursor: pointer;
                border-bottom: 1px solid #f8fafc;
                transition: background 0.15s ease;
            }

            .combobox-item:last-child {
                border-bottom: none;
            }

            .combobox-item:hover,
            .combobox-item.active {
                background-color: #2563eb;
                color: #ffffff;
            }

            /* Results Card & GridView Styling */
            .grid-card {
                border: none;
                border-radius: 0.5rem;
                background-color: #ffffff;
                box-shadow: 0 0.125rem 0.375rem rgba(0, 0, 0, 0.05);
            }

            .grid-card-header {
                background-color: #ffffff;
                border-bottom: 1px solid #e2e8f0;
                padding: 1rem 1.25rem;
            }

            .custom-grid {
                border-collapse: separate;
                border-spacing: 0;
                width: 100%;
                table-layout: fixed;
            }

            .custom-grid th {
                background: linear-gradient(90deg, #1e3c72 0%, #2a5298 100%);
                color: #ffffff;
                font-size: 0.78rem;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                padding: 0.75rem 0.75rem;
                border: none;
                vertical-align: middle;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }

            .custom-grid td {
                font-size: 0.85rem;
                color: #334155;
                padding: 0.65rem 0.75rem;
                border-top: 1px solid #f1f5f9;
                vertical-align: middle;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            .text-truncate-cell {
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }

            .custom-grid tbody tr {
                transition: background-color 0.15s ease-in-out;
            }

            .custom-grid tbody tr:hover {
                background-color: #f1f5f9 !important;
            }

            /* Employee PCNO Badge */
            .pcno-badge {
                background-color: #eff6ff;
                color: #1d4ed8;
                border: 1px solid #bfdbfe;
                font-weight: 700;
                padding: 0.25rem 0.5rem;
                border-radius: 0.375rem;
                font-size: 0.8rem;
            }

            /* Status Dropdown Styling */
            .status-dropdown {
                font-size: 0.825rem;
                font-weight: 600;
                padding: 0.3rem 0.6rem;
                border-radius: 0.375rem;
                border: 1px solid #cbd5e1;
                background-color: #ffffff;
                color: #0f172a;
                cursor: pointer;
                width: 100%;
                max-width: 160px;
                text-overflow: ellipsis;
                overflow: hidden;
                white-space: nowrap;
                transition: all 0.2s ease;
            }

            .status-dropdown:hover,
            .status-dropdown:focus {
                border-color: #2563eb;
                box-shadow: 0 0 0 2px rgba(37, 99, 235, 0.15);
            }

            /* Floating Non-Shifting Saved Badge Overlay */
            .status-cell-container {
                position: relative;
                min-width: 160px;
            }

            .saved-badge-overlay {
                position: absolute;
                right: 8px;
                top: 50%;
                transform: translateY(-50%);
                font-size: 0.75rem;
                font-weight: 700;
                padding: 2px 8px;
                border-radius: 12px;
                background-color: #d1fae5;
                color: #047857;
                border: 1px solid #a7f3d0;
                white-space: nowrap;
                pointer-events: none;
                box-shadow: 0 0.2rem 0.4rem rgba(0, 0, 0, 0.1);
                z-index: 10;
            }

            /* Top-Right Floating Toast Notification */
            #toastContainer {
                position: fixed;
                top: 75px;
                right: 25px;
                z-index: 9999;
                min-width: 320px;
                max-width: 420px;
            }

            .toast-card {
                box-shadow: 0 0.5rem 1.5rem rgba(0, 0, 0, 0.15) !important;
                border: none;
                border-left: 0.35rem solid #10b981 !important;
                border-radius: 0.5rem;
                background-color: #ffffff;
                color: #0f172a;
            }

            /* Pagination Links */
            .pagination-custom table {
                margin: 0 auto;
            }

            .pagination-custom td {
                padding: 0 3px;
            }

            .pagination-custom a,
            .pagination-custom span {
                display: inline-block;
                padding: 0.35rem 0.75rem;
                font-size: 0.85rem;
                font-weight: 600;
                border-radius: 0.375rem;
                border: 1px solid #cbd5e1;
                color: #475569;
                background-color: #ffffff;
                text-decoration: none;
            }

            .pagination-custom a:hover {
                background-color: #f1f5f9;
                color: #1e3c72;
                border-color: #94a3b8;
            }

            .pagination-custom span {
                background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
                color: #ffffff;
                border-color: #1e3c72;
            }

            /* Course Type Badges */
            .badge-type-internal {
                background-color: #eff6ff;
                color: #1d4ed8;
                border: 1px solid #bfdbfe;
            }

            .badge-type-external {
                background-color: #f3e8ff;
                color: #6b21a8;
                border: 1px solid #e9d5ff;
            }

            .badge-type-workshop {
                background-color: #fffbeb;
                color: #b45309;
                border: 1px solid #fef3c7;
            }

            .badge-type-seminar {
                background-color: #ecfdf5;
                color: #047857;
                border: 1px solid #a7f3d0;
            }

            .badge-type-default {
                background-color: #f1f5f9;
                color: #475569;
                border: 1px solid #e2e8f0;
            }

            /* ═══════════════════════════════════════════════════
           PDF Report — Letter Document Preview Styles
           A4 letter format, single continuous page
        ═══════════════════════════════════════════════════ */

            /* modal-dialog-scrollable: Bootstrap's correct pattern for
           sticky header+footer with scrollable body inside the modal.
           Our div has BOTH 'modal-body' and 'pdf-modal-body' classes so
           Bootstrap's CSS targets it properly. */

            .pdf-modal-dialog {
                max-width: 900px;
                margin: 20px auto;
            }

            /* White document surface */
            #modalPdfPreview .modal-content {
                background-color: #ffffff !important;
                border: none !important;
                border-radius: 4px !important;
                box-shadow: 0 4px 40px rgba(0, 0, 0, 0.5) !important;
            }

            /* Scrollable letter body: Bootstrap handles overflow via modal-body class.
           White background fills any space below short content. */
            .pdf-modal-body {
                background-color: #ffffff !important;
                padding: 0 !important;
            }

            /* pdf-paper-card: A4 letter content — tight bottom padding so no blank 2nd-page look */
            .pdf-paper-card {
                background-color: #ffffff !important;
                color: #000000 !important;
                font-family: "Times New Roman", Times, serif;
                padding: 0 1.2cm 20px 1.2cm !important;
                border: none !important;
                box-shadow: none !important;
                margin: 0;
                font-size: 23px !important;
                line-height: 1.8;
            }

            /* Header image: bleeds edge-to-edge, larger gap below before No/Date */
            .pdf-header-img {
                width: calc(100% + 2.4cm) !important;
                margin-left: -1.2cm !important;
                height: auto !important;
                min-height: 160px !important;
                max-height: none !important;
                object-fit: cover;
                object-position: center top;
                display: block;
                margin-top: 0;
                margin-bottom: 3.5em;
                /* gap: header → No/Date */
            }

            /* No: and Date: row — 18pt = 23px */
            .pdf-meta-text {
                font-size: 23px !important;
                color: #000000 !important;
                font-weight: normal !important;
                margin-bottom: 2.5em !important;
                /* gap: No/Date → Sub */
            }

            /* Subject line: 20pt = 26px, bold, centred */
            .pdf-subject-text {
                font-size: 26px !important;
                font-weight: bold !important;
                color: #000000 !important;
                display: block;
                text-align: center;
                margin-top: 0;
                /* No/Date already has margin-bottom */
                margin-bottom: 2.5em;
                /* gap: Sub → Paragraph */
            }

            /* Paragraph body: 18pt = 23px */
            .pdf-paragraph-text {
                font-size: 23px !important;
                line-height: 1.8;
                color: #000000 !important;
                margin-top: 0;
                /* Sub already has margin-bottom */
                margin-bottom: 2.5em;
                /* gap: Paragraph → Table */
                text-align: justify;
                text-indent: 2em;
            }

            /* Summary table: 18pt = 23px */
            .pdf-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 0;
                /* paragraph already has margin-bottom */
                margin-bottom: 1.5em;
            }

            .pdf-table th,
            .pdf-table td {
                border: 1px solid #000000 !important;
                padding: 8px 12px;
                text-align: left;
                vertical-align: middle;
                font-size: 23px !important;
                color: #000000 !important;
            }

            .pdf-table th {
                background-color: #eeeeee;
                font-weight: bold;
            }

            /* Signature: right-aligned, table gap + 3 extra lines of signing space */
            .pdf-signature-container {
                float: right;
                text-align: center;
                margin-top: 174px;
                /* 60px base + 3 lines × 38px */
                min-width: 240px;
                color: #000000 !important;
            }

            .pdf-signature-container div {
                color: #000000 !important;
                font-weight: bold !important;
                font-size: 23px !important;
            }

            /* Editable highlight in preview mode only */
            .pdf-paper-card [contenteditable="true"] {
                outline: 1px dashed #93c5fd;
                border-radius: 3px;
                transition: outline 0.2s;
            }

            .pdf-paper-card [contenteditable="true"]:focus,
            .pdf-paper-card [contenteditable="true"]:hover {
                outline: 2px solid #2563eb;
            }

            /* Footer: white background so it doesn't look grey after signature */
            #modalPdfPreview .modal-footer {
                background-color: #ffffff !important;
                border-top: 1px solid #e2e8f0;
            }

            /* Print / Save as PDF */
            @media print {
                body * {
                    visibility: hidden !important;
                }

                #pdfReportPage,
                #pdfReportPage * {
                    visibility: visible !important;
                }

                #pdfReportPage {
                    position: fixed !important;
                    left: 0;
                    top: 0;
                    width: 100% !important;
                    padding: 0 1.2cm 20px 1.2cm !important;
                    background: #ffffff !important;
                }

                .no-print {
                    display: none !important;
                }

                .pdf-paper-card [contenteditable="true"] {
                    outline: none !important;
                }

                .pdf-header-img {
                    width: calc(100% + 2.4cm) !important;
                    margin-left: -1.2cm !important;
                }
            }
        </style>
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

        <!-- Page Welcome Hero Banner -->
        <div class="portal-header-card p-4 mb-4">
            <div class="d-md-flex align-items-center justify-content-between">
                <div>
                    <h2 class="h4 font-weight-bold mb-1"><i class="fas fa-graduation-cap mr-2"></i>Employee Training
                        Status Directory</h2>
                    <p class="mb-0 text-white-50 small">Filter employee training profiles &amp; manage real-time
                        progress updates</p>
                </div>
                <div class="mt-3 mt-md-0">
                    <button type="button" class="btn btn-light text-primary font-weight-bold shadow-sm"
                        onclick="openPdfConfigModal();">
                        <i class="fas fa-file-pdf text-danger mr-2"></i>Generate Course Report PDF
                    </button>
                </div>
            </div>
        </div>

        <!-- UpdatePanel for Instant Auto-Updating Grid -->
        <asp:UpdatePanel ID="upMain" runat="server" UpdateMode="Conditional">
            <ContentTemplate>

                <!-- Top-Right Floating Toast Notification -->
                <div id="toastContainer">
                    <asp:Panel ID="pnlAlert" runat="server" Visible="false"
                        CssClass="alert alert-dismissible fade show toast-card" role="alert">
                        <div class="d-flex align-items-center pr-3">
                            <i class="fas fa-check-circle fa-lg text-success mr-3"></i>
                            <div>
                                <span class="small font-weight-bold text-dark">
                                    <asp:Label ID="lblAlertMessage" runat="server"></asp:Label>
                                </span>
                            </div>
                        </div>
                        <button type="button" class="close py-2" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </asp:Panel>
                </div>

                <!-- Search & Filter Panel Card -->
                <div class="card filter-card mb-4">
                    <div class="filter-card-header d-flex align-items-center justify-content-between">
                        <h6 class="m-0 font-weight-bold text-dark"><i
                                class="fas fa-sliders-h text-primary mr-2"></i>Search &amp; Filter Directory</h6>
                        <span class="text-muted small"><i class="fas fa-info-circle mr-1"></i>Type or select filters to
                            refine results</span>
                    </div>
                    <div class="card-body p-4">
                        <div class="row">
                            <!-- Course Type Searchable Dropdown -->
                            <div class="col-lg-3 col-md-6 mb-3">
                                <label class="filter-label"><i class="fas fa-tags text-primary mr-1"></i>Course
                                    Type:</label>
                                <div class="combobox-container">
                                    <asp:DropDownList ID="ddlCourseType" runat="server" CssClass="d-none"
                                        AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed"
                                        clientidmode="Static">
                                    </asp:DropDownList>
                                    <div id="combo_ddlCourseType" class="combobox-field">
                                        <span class="combobox-selected-text"></span>
                                        <i class="fas fa-chevron-down combobox-icon"></i>
                                    </div>
                                    <div id="drop_ddlCourseType" class="combobox-dropdown d-none">
                                        <div class="combobox-search-box">
                                            <input type="text" class="form-control combobox-search-input"
                                                placeholder="Search course type..." autocomplete="off" />
                                        </div>
                                        <div class="combobox-list"></div>
                                    </div>
                                </div>
                            </div>

                            <!-- Course Category Searchable Dropdown -->
                            <div class="col-lg-3 col-md-6 mb-3">
                                <label class="filter-label"><i class="fas fa-layer-group text-primary mr-1"></i>Course
                                    Category:</label>
                                <div class="combobox-container">
                                    <asp:DropDownList ID="ddlCourseCategory" runat="server" CssClass="d-none"
                                        AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed"
                                        clientidmode="Static">
                                    </asp:DropDownList>
                                    <div id="combo_ddlCourseCategory" class="combobox-field">
                                        <span class="combobox-selected-text"></span>
                                        <i class="fas fa-chevron-down combobox-icon"></i>
                                    </div>
                                    <div id="drop_ddlCourseCategory" class="combobox-dropdown d-none">
                                        <div class="combobox-search-box">
                                            <input type="text" class="form-control combobox-search-input"
                                                placeholder="Search course category..." autocomplete="off" />
                                        </div>
                                        <div class="combobox-list"></div>
                                    </div>
                                </div>
                            </div>

                            <!-- Course Name Searchable Dropdown -->
                            <div class="col-lg-4 col-md-6 mb-3">
                                <label class="filter-label"><i class="fas fa-book text-primary mr-1"></i>Course
                                    Name:</label>
                                <div class="combobox-container">
                                    <asp:DropDownList ID="ddlCourseName" runat="server" CssClass="d-none"
                                        AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed"
                                        clientidmode="Static">
                                    </asp:DropDownList>
                                    <div id="combo_ddlCourseName" class="combobox-field">
                                        <span class="combobox-selected-text"></span>
                                        <i class="fas fa-chevron-down combobox-icon"></i>
                                    </div>
                                    <div id="drop_ddlCourseName" class="combobox-dropdown d-none">
                                        <div class="combobox-search-box">
                                            <input type="text" class="form-control combobox-search-input"
                                                placeholder="Search course name..." autocomplete="off" />
                                        </div>
                                        <div class="combobox-list"></div>
                                    </div>
                                </div>
                            </div>

                            <!-- Training Status Searchable Dropdown -->
                            <div class="col-lg-2 col-md-6 mb-3">
                                <label class="filter-label"><i class="fas fa-tasks text-primary mr-1"></i>Training
                                    Status:</label>
                                <div class="combobox-container">
                                    <asp:DropDownList ID="ddlFilterStatus" runat="server" CssClass="d-none"
                                        AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed"
                                        clientidmode="Static">
                                    </asp:DropDownList>
                                    <div id="combo_ddlFilterStatus" class="combobox-field">
                                        <span class="combobox-selected-text"></span>
                                        <i class="fas fa-chevron-down combobox-icon"></i>
                                    </div>
                                    <div id="drop_ddlFilterStatus" class="combobox-dropdown d-none">
                                        <div class="combobox-search-box">
                                            <input type="text" class="form-control combobox-search-input"
                                                placeholder="Search status..." autocomplete="off" />
                                        </div>
                                        <div class="combobox-list"></div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row align-items-end pt-2">
                            <!-- Start Date Filter -->
                            <div class="col-lg-3 col-md-6 mb-3">
                                <label class="filter-label"><i class="far fa-calendar-alt text-primary mr-1"></i>Start
                                    Date (From):</label>
                                <asp:TextBox ID="txtStartDate" runat="server" TextMode="Date"
                                    CssClass="form-control form-control-custom" AutoPostBack="true"
                                    OnTextChanged="Filter_Changed"></asp:TextBox>
                            </div>

                            <!-- End Date Filter -->
                            <div class="col-lg-3 col-md-6 mb-3">
                                <label class="filter-label"><i class="far fa-calendar-alt text-primary mr-1"></i>End
                                    Date (To):</label>
                                <asp:TextBox ID="txtEndDate" runat="server" TextMode="Date"
                                    CssClass="form-control form-control-custom" AutoPostBack="true"
                                    OnTextChanged="Filter_Changed"></asp:TextBox>
                            </div>

                            <!-- Buttons -->
                            <div class="col-lg-6 col-md-12 mb-3 text-right">
                                <asp:Button ID="btnSearch" runat="server"
                                    CssClass="btn btn-primary btn-sm px-4 font-weight-bold mr-2 shadow-sm"
                                    Text="Apply Filter" OnClick="btnSearch_Click" />
                                <asp:Button ID="btnClear" runat="server"
                                    CssClass="btn btn-outline-secondary btn-sm px-3 font-weight-bold"
                                    Text="Reset Filters" OnClick="btnClear_Click" />
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Results Grid Card -->
                <div class="card grid-card mb-4">
                    <div class="grid-card-header d-flex align-items-center justify-content-between">
                        <h6 class="m-0 font-weight-bold text-dark"><i
                                class="fas fa-list-alt text-primary mr-2"></i>Training Records Directory</h6>
                        <asp:Label ID="lblRecordCount" runat="server"
                            CssClass="badge badge-primary px-3 py-2 font-weight-bold" Text="0 Records Found">
                        </asp:Label>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <asp:GridView ID="gvTraining" runat="server" AutoGenerateColumns="False"
                                CssClass="custom-grid m-0" AllowPaging="True" PageSize="20"
                                OnPageIndexChanging="gvTraining_PageIndexChanging" AllowSorting="True"
                                OnSorting="gvTraining_Sorting" OnRowDataBound="gvTraining_RowDataBound"
                                DataKeyNames="ROW_ID">
                                <PagerStyle CssClass="pagination-custom p-3 bg-white" />
                                <EmptyDataTemplate>
                                    <div class="text-center py-5 text-muted">
                                        <i class="fas fa-folder-open fa-3x mb-3 text-gray-300"></i>
                                        <p class="h6 font-weight-bold text-dark">No training records match your filter
                                            criteria.</p>
                                        <span class="small text-muted">Try resetting filters or adjusting date
                                            ranges.</span>
                                    </div>
                                </EmptyDataTemplate>
                                <Columns>
                                    <asp:TemplateField HeaderText="Employee Name" HeaderStyle-Width="16%"
                                        SortExpression="EMP_NAME">
                                        <ItemTemplate>
                                            <div class="d-flex align-items-center text-truncate-cell"
                                                title='<%# Eval("EMP_NAME") %>'>
                                                <i class="fas fa-user-circle text-primary fa-lg mr-2 flex-shrink-0"></i>
                                                <span class="font-weight-bold text-dark text-truncate">
                                                    <%# Eval("EMP_NAME") %>
                                                </span>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="PCNO" HeaderStyle-Width="8%" SortExpression="PCNO">
                                        <ItemTemplate>
                                            <span class="pcno-badge">
                                                <%# Eval("PCNO") %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Course Name" HeaderStyle-Width="22%"
                                        SortExpression="COURSENAME">
                                        <ItemTemplate>
                                            <div class="text-truncate-cell font-weight-medium text-dark"
                                                title='<%# Eval("COURSENAME") %>'>
                                                <%# Eval("COURSENAME") %>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Course Type" HeaderStyle-Width="11%"
                                        SortExpression="COURSETYPE">
                                        <ItemTemplate>
                                            <%# FormatCourseType(Eval("COURSETYPE")) %>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Course Category" HeaderStyle-Width="14%"
                                        SortExpression="CATEGORY_DESC">
                                        <ItemTemplate>
                                            <div class="text-truncate-cell" title='<%# Eval("CATEGORY_DESC") %>'>
                                                <%# Eval("CATEGORY_DESC") %>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Start Date" HeaderStyle-Width="10%"
                                        ItemStyle-CssClass="text-nowrap" SortExpression="STARTDATE">
                                        <ItemTemplate>
                                            <span class="text-muted text-nowrap"><i
                                                    class="far fa-calendar-alt mr-1"></i>
                                                <%# Eval("STARTDATE") !=DBNull.Value && Eval("STARTDATE") !=null ?
                                                    string.Format("{0:dd/MM/yyyy}", Eval("STARTDATE")) : "" %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="End Date" HeaderStyle-Width="10%"
                                        ItemStyle-CssClass="text-nowrap" SortExpression="ENDDATE">
                                        <ItemTemplate>
                                            <span class="text-muted text-nowrap"><i
                                                    class="far fa-calendar-alt mr-1"></i>
                                                <%# Eval("ENDDATE") !=DBNull.Value && Eval("ENDDATE") !=null ?
                                                    string.Format("{0:dd/MM/yyyy}", Eval("ENDDATE")) : "" %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Training Status" HeaderStyle-Width="17%"
                                        ItemStyle-CssClass="status-cell-container" SortExpression="STATUS_DESC">
                                        <ItemTemplate>
                                            <div
                                                style="position: relative; display: flex; align-items: center; width: 100%;">
                                                <asp:DropDownList ID="ddlRowStatus" runat="server"
                                                    CssClass="status-dropdown" AutoPostBack="true"
                                                    OnSelectedIndexChanged="ddlRowStatus_SelectedIndexChanged">
                                                </asp:DropDownList>
                                                <asp:HiddenField ID="hfRowId" runat="server"
                                                    Value='<%# Eval("ROW_ID") %>' />
                                                <asp:HiddenField ID="hfCurrentStatus" runat="server"
                                                    Value='<%# Eval("TRAINING_STATUS") %>' />
                                                <asp:Panel ID="pnlSavedBadge" runat="server" Visible="false"
                                                    CssClass="saved-badge-overlay">
                                                    <i class="fas fa-check-circle mr-1"></i>Saved
                                                </asp:Panel>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>

            </ContentTemplate>
        </asp:UpdatePanel>

        <!-- Modal 1: PDF Generation Setup -->
        <div class="modal fade" id="modalPdfConfig" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content shadow-lg border-0">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title font-weight-bold"><i class="fas fa-file-invoice mr-2"></i>Generate Course
                            Completion Report</h5>
                        <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close"
                            onclick="$('#modalPdfConfig').modal('hide');">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="form-group mb-3">
                            <label class="font-weight-bold text-dark"><i
                                    class="fas fa-book text-primary mr-1"></i>Select Course Name:</label>
                            <div class="combobox-container">
                                <select id="ddlPdfCourse" class="d-none">
                                    <option value="">-- Select Course --</option>
                                </select>
                                <div id="combo_ddlPdfCourse" class="combobox-field">
                                    <span class="combobox-selected-text">-- Select Course --</span>
                                    <i class="fas fa-chevron-down combobox-icon"></i>
                                </div>
                                <div id="drop_ddlPdfCourse" class="combobox-dropdown d-none">
                                    <div class="combobox-search-box">
                                        <input type="text" class="form-control combobox-search-input"
                                            placeholder="Search course name..." autocomplete="off" />
                                    </div>
                                    <div class="combobox-list"></div>
                                </div>
                            </div>
                        </div>

                        <!-- Start & End Date Live Display Panel -->
                        <div id="pnlPdfCourseDates" class="alert alert-light border mb-3 py-2 px-3 d-none"
                            style="border-left: 4px solid #2563eb !important; background-color: #f8fafc;">
                            <div class="d-flex justify-content-between align-items-center small">
                                <div><i class="far fa-calendar-alt text-primary mr-1"></i><strong>Start Date:</strong>
                                    <span id="lblPdfModalStartDate" class="text-dark font-weight-bold">--</span>
                                </div>
                                <div><i class="far fa-calendar-check text-success mr-1"></i><strong>End Date:</strong>
                                    <span id="lblPdfModalEndDate" class="text-dark font-weight-bold">--</span>
                                </div>
                            </div>
                        </div>

                        <div class="form-group mb-3">
                            <label class="font-weight-bold text-dark"><i
                                    class="fas fa-hashtag text-primary mr-1"></i>Document Reference No (`No:`):</label>
                            <input type="text" id="txtPdfDocNo" class="form-control form-control-custom"
                                placeholder="e.g. LRDE/DKRM/2026/01" value="LRDE/DKRM/2026/01" />
                        </div>

                        <div class="form-group mb-3">
                            <label class="font-weight-bold text-dark"><i
                                    class="fas fa-user-shield text-primary mr-1"></i>Select Division Officer (Sc F &amp;
                                Above):</label>
                            <select id="ddlPdfOfficer" class="form-control form-control-custom">
                                <option value="">-- Loading Officers... --</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer bg-light">
                        <button type="button" class="btn btn-secondary font-weight-bold" data-dismiss="modal"
                            onclick="$('#modalPdfConfig').modal('hide');">Cancel</button>
                        <button type="button" class="btn btn-primary font-weight-bold shadow-sm"
                            onclick="generateReportPreview();">
                            <i class="fas fa-eye mr-1"></i>Preview &amp; Edit Report
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal 2: Live Editable Document Preview & PDF Export -->
        <div class="modal fade" id="modalPdfPreview" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-scrollable pdf-modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header bg-dark text-white no-print">
                        <h5 class="modal-title font-weight-bold"><i class="fas fa-file-pdf text-danger mr-2"></i>Report
                            Document Live Editor &amp; Preview</h5>
                        <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body pdf-modal-body">
                        <!-- Live Editable Paper Document -->
                        <div id="pdfReportPage" class="pdf-paper-card">
                            <!-- Top Header Image -->
                            <img src="Static/Images/satisfactory_header.png" alt="Header" class="pdf-header-img" />

                            <!-- Metadata Line (No Left, Date Right) -->
                            <div class="d-flex justify-content-between align-items-center mb-4 pdf-meta-text">
                                <div><strong>No:</strong> <span id="lblPdfDocNoVal" contenteditable="true"></span></div>
                                <div><strong>Date:</strong> <span id="lblPdfDate"></span></div>
                            </div>

                            <!-- Subject Line -->
                            <div class="text-center font-weight-bold my-4 pdf-subject-text" id="lblPdfSubject"
                                contenteditable="true">
                                Sub:
                            </div>

                            <!-- Paragraph Body -->
                            <div class="my-4 text-justify pdf-paragraph-text" id="lblPdfParagraph"
                                contenteditable="true">
                                The following training program on <strong id="lblPdfCourseNameText"></strong>
                                was
                                conducted from <strong id="lblPdfStartDateText"></strong> to <strong
                                    id="lblPdfEndDateText"></strong> for <strong id="lblPdfCourseTypeText"></strong>.
                            </div>

                            <!-- Summary Table -->
                            <table class="pdf-table">
                                <thead>
                                    <tr>
                                        <th>Course Name</th>
                                        <th>Start Date</th>
                                        <th>End Date</th>
                                        <th>Participant / Officer</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td id="tblCourseName"></td>
                                        <td id="tblStartDate"></td>
                                        <td id="tblEndDate"></td>
                                        <td id="tblOfficer"></td>
                                    </tr>
                                </tbody>
                            </table>

                            <!-- Bottom-Right Signature Block with ample signing space -->
                            <div class="pdf-signature-container" id="pdfSignatureBlock" contenteditable="true">
                                <div id="lblSigName" style="color:#000000;font-weight:bold;font-size:23px;"></div>
                                <div id="lblSigDesig" style="color:#000000;font-weight:bold;font-size:23px;"></div>
                                <div style="color:#000000;font-weight:bold;font-size:23px;margin-top:4px;">For Director
                                </div>
                            </div>
                            <div style="clear: both;"></div>
                        </div>
                    </div>
                    <div class="modal-footer no-print d-flex justify-content-between">
                        <button type="button" class="btn btn-outline-secondary font-weight-bold"
                            onclick="$('#modalPdfPreview').modal('hide'); $('#modalPdfConfig').modal('show');">
                            <i class="fas fa-arrow-left mr-1"></i>Back to Options
                        </button>
                        <div>
                            <button type="button" class="btn btn-info font-weight-bold mr-2 shadow-sm"
                                onclick="window.print();">
                                <i class="fas fa-print mr-1"></i>Print / Save as PDF
                            </button>
                            <button type="button" class="btn btn-success font-weight-bold shadow-sm"
                                onclick="downloadPdfDocument();">
                                <i class="fas fa-download mr-1"></i>Download PDF File
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </asp:Content>

    <asp:Content ID="Content3" ContentPlaceHolderID="ScriptsContent" runat="server">
        <script>
            function openPdfConfigModal() {
                var $pdfCourse = $('#ddlPdfCourse');
                $pdfCourse.empty().append('<option value="">-- Select Course --</option>');

                $('#ddlCourseName option').each(function () {
                    var val = $(this).val();
                    var txt = $(this).text();
                    if (val !== "") {
                        $pdfCourse.append(new Option(txt, val));
                    }
                });

                // Reset date display card
                $('#pnlPdfCourseDates').addClass('d-none');
                $('#lblPdfModalStartDate').text('--');
                $('#lblPdfModalEndDate').text('--');

                // Setup searchable combobox for PDF course dropdown
                setupSearchableDropdown('ddlPdfCourse');

                // Attach change listener to fetch and show Start Date and End Date when course is selected
                $pdfCourse.off('change.pdfCourse').on('change.pdfCourse', function () {
                    var selectedCourse = $(this).val();
                    if (selectedCourse) {
                        $.ajax({
                            type: "POST",
                            url: "TrainingStatus.aspx/GetCourseDetailsByName",
                            data: JSON.stringify({ courseName: selectedCourse }),
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (res) {
                                var details = res.d;
                                if (details && (details.StartDate || details.EndDate)) {
                                    $('#lblPdfModalStartDate').text(details.StartDate || "N/A");
                                    $('#lblPdfModalEndDate').text(details.EndDate || "N/A");
                                    $('#pnlPdfCourseDates').removeClass('d-none');
                                } else {
                                    $('#pnlPdfCourseDates').addClass('d-none');
                                }
                            },
                            error: function () {
                                $('#pnlPdfCourseDates').addClass('d-none');
                            }
                        });
                    } else {
                        $('#pnlPdfCourseDates').addClass('d-none');
                    }
                });

                $.ajax({
                    type: "POST",
                    url: "TrainingStatus.aspx/GetDivisionOfficers",
                    data: JSON.stringify({ userPcno: "" }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (res) {
                        var list = res.d;
                        var $ddlOff = $('#ddlPdfOfficer');
                        $ddlOff.empty();
                        if (list && list.length > 0) {
                            $.each(list, function (i, item) {
                                var $opt = $('<option></option>').val(item.Pcno).text(item.FormattedText);
                                $opt.data('name', item.Name);
                                $opt.data('desig', item.Designation);
                                $ddlOff.append($opt);
                            });
                        } else {
                            $ddlOff.append('<option value="">No Sc F/G/H officers found in division</option>');
                        }
                    },
                    error: function () {
                        $('#ddlPdfOfficer').empty().append('<option value="">Error loading officers</option>');
                    }
                });

                $('#modalPdfConfig').modal('show');
            }

            function generateReportPreview() {
                var courseName = $('#ddlPdfCourse').val();
                if (!courseName) {
                    alert("Please select a course name first.");
                    return;
                }

                var docNo = $('#txtPdfDocNo').val() || "LRDE/DKRM/2026/01";
                var $selectedOfficerOpt = $('#ddlPdfOfficer option:selected');
                var officerName = $selectedOfficerOpt.data('name') || $selectedOfficerOpt.text();
                var officerDesig = $selectedOfficerOpt.data('desig') || "";

                $.ajax({
                    type: "POST",
                    url: "TrainingStatus.aspx/GetCourseDetailsByName",
                    data: JSON.stringify({ courseName: courseName }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (res) {
                        var details = res.d;
                        var startDate = details.StartDate || "";
                        var endDate = details.EndDate || "";
                        var courseType = details.CourseType || "";

                        var today = new Date();
                        var dd = String(today.getDate()).padStart(2, '0');
                        var mm = String(today.getMonth() + 1).padStart(2, '0');
                        var yyyy = today.getFullYear();
                        var dateStr = dd + '/' + mm + '/' + yyyy;

                        var subjectText = "Sub: " + courseType + " on " + courseName;
                        if (courseType && courseName.toLowerCase().indexOf(courseType.toLowerCase()) === 0) {
                            subjectText = "Sub: " + courseName;
                        }

                        $('#lblPdfDate').text(dateStr);
                        $('#lblPdfDocNoVal').text(docNo);
                        $('#lblPdfSubject').text(subjectText);

                        $('#lblPdfCourseNameText').text(courseName);
                        $('#lblPdfStartDateText').text(startDate);
                        $('#lblPdfEndDateText').text(endDate);
                        $('#lblPdfCourseTypeText').text(courseType);

                        $('#tblCourseName').text(courseName);
                        $('#tblStartDate').text(startDate);
                        $('#tblEndDate').text(endDate);
                        $('#tblOfficer').text(officerName + (officerDesig ? " (" + officerDesig + ")" : ""));

                        $('#lblSigName').text(officerName);
                        $('#lblSigDesig').text(officerDesig);

                        $('#modalPdfConfig').modal('hide');
                        $('#modalPdfPreview').modal('show');
                    },
                    error: function () {
                        alert("Error fetching course details.");
                    }
                });
            }

            function downloadPdfDocument() {
                window.print();
            }

            function triggerToastAutoDismiss() {
                var $toast = $('#toastContainer .toast-card');
                if ($toast.length && $toast.is(':visible')) {
                    setTimeout(function () {
                        $toast.fadeOut(400, function () {
                            $(this).hide();
                        });
                    }, 3000);
                }

                var $badge = $('.saved-badge-overlay');
                if ($badge.length && $badge.is(':visible')) {
                    setTimeout(function () {
                        $badge.fadeOut(500);
                    }, 2000);
                }
            }

            function setupSearchableDropdown(selectId) {
                var $select = $('#' + selectId);
                var $field = $('#combo_' + selectId);
                var $drop = $('#drop_' + selectId);
                var $searchInput = $drop.find('.combobox-search-input');
                var $list = $drop.find('.combobox-list');

                if (!$select.length || !$field.length || !$drop.length) return;

                function updateFieldText() {
                    var $selectedOpt = $select.find('option:selected');
                    var text = ($selectedOpt.length && $selectedOpt.val() !== "") ? $selectedOpt.text() : ($select.find('option').first().text() || "-- All --");
                    $field.find('.combobox-selected-text').text(text);
                }
                updateFieldText();

                function selectOption(val, text) {
                    var $opt = $select.find('option').filter(function () { return $(this).val() === val; });
                    if ($opt.length === 0) {
                        $select.append(new Option(text, val));
                    }
                    $select.val(val);
                    updateFieldText();
                    $drop.addClass('d-none');

                    var selectName = $select.attr('name');
                    if (typeof __doPostBack === 'function' && selectName) {
                        __doPostBack(selectName, '');
                    } else {
                        $select.trigger('change');
                    }
                }

                function populateListItems(filterText) {
                    $list.empty();
                    var filter = (filterText || '').toLowerCase().trim();
                    var count = 0;

                    $select.find('option').each(function () {
                        var text = $(this).text();
                        var val = $(this).val();

                        if (!filter || text.toLowerCase().indexOf(filter) > -1 || val === "") {
                            var $item = $('<div class="combobox-item"></div>').text(text).data('val', val);
                            if (val === $select.val()) {
                                $item.addClass('active');
                            }
                            $item.on('mousedown', function (e) {
                                e.preventDefault();
                                selectOption(val, text);
                            });
                            $list.append($item);
                            count++;
                        }
                    });

                    if (count === 0) {
                        $list.append('<div class="combobox-item text-muted" style="cursor:default;">No matches found</div>');
                    }
                }

                $field.off('click').on('click', function (e) {
                    e.stopPropagation();
                    var isCurrentlyOpen = !$drop.hasClass('d-none');
                    $('.combobox-dropdown').addClass('d-none');

                    if (!isCurrentlyOpen) {
                        $searchInput.val('');
                        populateListItems('');
                        $drop.removeClass('d-none');
                        setTimeout(function () { $searchInput.focus(); }, 50);
                    }
                });

                $searchInput.off('input keyup').on('input keyup', function () {
                    populateListItems($(this).val());
                });
            }

            function initSearchableDropdowns() {
                ['ddlCourseType', 'ddlCourseCategory', 'ddlCourseName', 'ddlFilterStatus'].forEach(function (id) {
                    setupSearchableDropdown(id);
                });

                $(document).off('click.combobox').on('click.combobox', function (e) {
                    if (!$(e.target).closest('.combobox-container').length) {
                        $('.combobox-dropdown').addClass('d-none');
                    }
                });

                triggerToastAutoDismiss();
            }

            $(document).ready(function () {
                initSearchableDropdowns();
                if (typeof Sys !== 'undefined' && Sys.WebForms && Sys.WebForms.PageRequestManager) {
                    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
                        initSearchableDropdowns();
                    });
                }
            });
        </script>
    </asp:Content>