<%@ Page Title="Training Status Portal" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TrainingStatus.aspx.cs" Inherits="TrainingStatusPortal.TrainingStatus" %>

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

        .combobox-item:hover, .combobox-item.active {
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
        }

        .custom-grid th {
            background: linear-gradient(90deg, #1e3c72 0%, #2a5298 100%);
            color: #ffffff;
            font-size: 0.78rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 0.75rem 1rem;
            border: none;
            vertical-align: middle;
        }

        .custom-grid td {
            font-size: 0.875rem;
            color: #334155;
            padding: 0.75rem 1rem;
            border-top: 1px solid #f1f5f9;
            vertical-align: middle;
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
            transition: all 0.2s ease;
        }

        .status-dropdown:hover, .status-dropdown:focus {
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
            box-shadow: 0 0.2rem 0.4rem rgba(0,0,0,0.1);
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

        .pagination-custom a, .pagination-custom span {
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
        .badge-type-internal { background-color: #eff6ff; color: #1d4ed8; border: 1px solid #bfdbfe; }
        .badge-type-external { background-color: #f3e8ff; color: #6b21a8; border: 1px solid #e9d5ff; }
        .badge-type-workshop { background-color: #fffbeb; color: #b45309; border: 1px solid #fef3c7; }
        .badge-type-seminar { background-color: #ecfdf5; color: #047857; border: 1px solid #a7f3d0; }
        .badge-type-default { background-color: #f1f5f9; color: #475569; border: 1px solid #e2e8f0; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Page Welcome Hero Banner -->
    <div class="portal-header-card p-4 mb-4">
        <div>
            <h2 class="h4 font-weight-bold mb-1"><i class="fas fa-graduation-cap mr-2"></i>Employee Training Status Directory</h2>
            <p class="mb-0 text-white-50 small">Filter employee training profiles & manage real-time progress updates</p>
        </div>
    </div>

    <!-- UpdatePanel for Instant Auto-Updating Grid -->
    <asp:UpdatePanel ID="upMain" runat="server" UpdateMode="Conditional">
        <ContentTemplate>

            <!-- Top-Right Floating Toast Notification -->
            <div id="toastContainer">
                <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-dismissible fade show toast-card" role="alert">
                    <div class="d-flex align-items-center pr-3">
                        <i class="fas fa-check-circle fa-lg text-success mr-3"></i>
                        <div>
                            <span class="small font-weight-bold text-dark"><asp:Label ID="lblAlertMessage" runat="server"></asp:Label></span>
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
                    <h6 class="m-0 font-weight-bold text-dark"><i class="fas fa-sliders-h text-primary mr-2"></i>Search &amp; Filter Directory</h6>
                    <span class="text-muted small"><i class="fas fa-info-circle mr-1"></i>Type or select filters to refine results</span>
                </div>
                <div class="card-body p-4">
                    <div class="row">
                        <!-- Course Type Searchable Dropdown -->
                        <div class="col-lg-3 col-md-6 mb-3">
                            <label class="filter-label"><i class="fas fa-tags text-primary mr-1"></i>Course Type:</label>
                            <div class="combobox-container">
                                <asp:DropDownList ID="ddlCourseType" runat="server" CssClass="d-none" AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed" clientidmode="Static">
                                </asp:DropDownList>
                                <div id="combo_ddlCourseType" class="combobox-field">
                                    <span class="combobox-selected-text"></span>
                                    <i class="fas fa-chevron-down combobox-icon"></i>
                                </div>
                                <div id="drop_ddlCourseType" class="combobox-dropdown d-none">
                                    <div class="combobox-search-box">
                                        <input type="text" class="form-control combobox-search-input" placeholder="Search course type..." autocomplete="off" />
                                    </div>
                                    <div class="combobox-list"></div>
                                </div>
                            </div>
                        </div>

                        <!-- Course Category Searchable Dropdown -->
                        <div class="col-lg-3 col-md-6 mb-3">
                            <label class="filter-label"><i class="fas fa-layer-group text-primary mr-1"></i>Course Category:</label>
                            <div class="combobox-container">
                                <asp:DropDownList ID="ddlCourseCategory" runat="server" CssClass="d-none" AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed" clientidmode="Static">
                                </asp:DropDownList>
                                <div id="combo_ddlCourseCategory" class="combobox-field">
                                    <span class="combobox-selected-text"></span>
                                    <i class="fas fa-chevron-down combobox-icon"></i>
                                </div>
                                <div id="drop_ddlCourseCategory" class="combobox-dropdown d-none">
                                    <div class="combobox-search-box">
                                        <input type="text" class="form-control combobox-search-input" placeholder="Search course category..." autocomplete="off" />
                                    </div>
                                    <div class="combobox-list"></div>
                                </div>
                            </div>
                        </div>

                        <!-- Course Name Autocomplete Filter -->
                        <div class="col-lg-4 col-md-6 mb-3 position-relative">
                            <label class="filter-label"><i class="fas fa-book text-primary mr-1"></i>Course Name (Autocomplete):</label>
                            <asp:TextBox ID="txtCourseName" runat="server" CssClass="form-control form-control-custom" placeholder="Type course name to search..." autocomplete="off" clientidmode="Static" AutoPostBack="true" OnTextChanged="Filter_Changed"></asp:TextBox>
                            <div id="courseNameSuggestions" class="autocomplete-suggestions d-none"></div>
                        </div>

                        <!-- Training Status Searchable Dropdown -->
                        <div class="col-lg-2 col-md-6 mb-3">
                            <label class="filter-label"><i class="fas fa-tasks text-primary mr-1"></i>Training Status:</label>
                            <div class="combobox-container">
                                <asp:DropDownList ID="ddlFilterStatus" runat="server" CssClass="d-none" AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed" clientidmode="Static">
                                </asp:DropDownList>
                                <div id="combo_ddlFilterStatus" class="combobox-field">
                                    <span class="combobox-selected-text"></span>
                                    <i class="fas fa-chevron-down combobox-icon"></i>
                                </div>
                                <div id="drop_ddlFilterStatus" class="combobox-dropdown d-none">
                                    <div class="combobox-search-box">
                                        <input type="text" class="form-control combobox-search-input" placeholder="Search status..." autocomplete="off" />
                                    </div>
                                    <div class="combobox-list"></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row align-items-end pt-2">
                        <!-- Start Date Filter -->
                        <div class="col-lg-3 col-md-6 mb-3">
                            <label class="filter-label"><i class="far fa-calendar-alt text-primary mr-1"></i>Start Date (From):</label>
                            <asp:TextBox ID="txtStartDate" runat="server" TextMode="Date" CssClass="form-control form-control-custom" AutoPostBack="true" OnTextChanged="Filter_Changed"></asp:TextBox>
                        </div>

                        <!-- End Date Filter -->
                        <div class="col-lg-3 col-md-6 mb-3">
                            <label class="filter-label"><i class="far fa-calendar-alt text-primary mr-1"></i>End Date (To):</label>
                            <asp:TextBox ID="txtEndDate" runat="server" TextMode="Date" CssClass="form-control form-control-custom" AutoPostBack="true" OnTextChanged="Filter_Changed"></asp:TextBox>
                        </div>

                        <!-- Buttons -->
                        <div class="col-lg-6 col-md-12 mb-3 text-right">
                            <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary btn-sm px-4 font-weight-bold mr-2 shadow-sm" Text="Apply Filter" OnClick="btnSearch_Click" />
                            <asp:Button ID="btnClear" runat="server" CssClass="btn btn-outline-secondary btn-sm px-3 font-weight-bold" Text="Reset Filters" OnClick="btnClear_Click" />
                        </div>
                    </div>
                </div>
            </div>

            <!-- Results Grid Card -->
            <div class="card grid-card mb-4">
                <div class="grid-card-header d-flex align-items-center justify-content-between">
                    <h6 class="m-0 font-weight-bold text-dark"><i class="fas fa-list-alt text-primary mr-2"></i>Training Records Directory</h6>
                    <asp:Label ID="lblRecordCount" runat="server" CssClass="badge badge-primary px-3 py-2 font-weight-bold" Text="0 Records Found"></asp:Label>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <asp:GridView ID="gvTraining" runat="server" AutoGenerateColumns="False" 
                            CssClass="custom-grid m-0" 
                            AllowPaging="True" PageSize="20" OnPageIndexChanging="gvTraining_PageIndexChanging"
                            OnRowDataBound="gvTraining_RowDataBound"
                            DataKeyNames="ROW_ID">
                            <PagerStyle CssClass="pagination-custom p-3 bg-white" />
                            <EmptyDataTemplate>
                                <div class="text-center py-5 text-muted">
                                    <i class="fas fa-folder-open fa-3x mb-3 text-gray-300"></i>
                                    <p class="h6 font-weight-bold text-dark">No training records match your filter criteria.</p>
                                    <span class="small text-muted">Try resetting filters or adjusting date ranges.</span>
                                </div>
                            </EmptyDataTemplate>
                            <Columns>
                                <asp:TemplateField HeaderText="Employee Name">
                                    <ItemTemplate>
                                        <div class="d-flex align-items-center">
                                            <i class="fas fa-user-circle text-primary fa-lg mr-2"></i>
                                            <span class="font-weight-bold text-dark"><%# Eval("EMP_NAME") %></span>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="PCNO">
                                    <ItemTemplate>
                                        <span class="pcno-badge"><%# Eval("PCNO") %></span>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:BoundField DataField="COURSENAME" HeaderText="Course Name" ItemStyle-CssClass="font-weight-medium text-dark" />

                                <asp:TemplateField HeaderText="Course Type">
                                    <ItemTemplate>
                                        <%# FormatCourseType(Eval("COURSETYPE")) %>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:BoundField DataField="CATEGORY_DESC" HeaderText="Course Category" />

                                <asp:TemplateField HeaderText="Start Date">
                                    <ItemTemplate>
                                        <span class="text-muted"><i class="far fa-calendar-alt mr-1"></i><%# Eval("STARTDATE") != DBNull.Value && Eval("STARTDATE") != null ? string.Format("{0:dd/MM/yyyy}", Eval("STARTDATE")) : "" %></span>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="End Date">
                                    <ItemTemplate>
                                        <span class="text-muted"><i class="far fa-calendar-alt mr-1"></i><%# Eval("ENDDATE") != DBNull.Value && Eval("ENDDATE") != null ? string.Format("{0:dd/MM/yyyy}", Eval("ENDDATE")) : "" %></span>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Training Status" ItemStyle-CssClass="status-cell-container">
                                    <ItemTemplate>
                                        <div style="position: relative; display: flex; align-items: center; width: 100%;">
                                            <asp:DropDownList ID="ddlRowStatus" runat="server" CssClass="status-dropdown" AutoPostBack="true" OnSelectedIndexChanged="ddlRowStatus_SelectedIndexChanged">
                                            </asp:DropDownList>
                                            <asp:HiddenField ID="hfRowId" runat="server" Value='<%# Eval("ROW_ID") %>' />
                                            <asp:HiddenField ID="hfCurrentStatus" runat="server" Value='<%# Eval("TRAINING_STATUS") %>' />
                                            <asp:Panel ID="pnlSavedBadge" runat="server" Visible="false" CssClass="saved-badge-overlay">
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

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
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

            // Display currently selected option text inside the main field
            function updateFieldText() {
                var $selectedOpt = $select.find('option:selected');
                var text = ($selectedOpt.length) ? $selectedOpt.text() : ($select.find('option').first().text() || "-- All --");
                $field.find('.combobox-selected-text').text(text);
            }
            updateFieldText();

            // Populate option list filtered by search input inside dropdown popup
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
                            $select.val(val);
                            updateFieldText();
                            $drop.addClass('d-none');
                            __doPostBack(selectId, '');
                        });
                        $list.append($item);
                        count++;
                    }
                });

                if (count === 0) {
                    $list.append('<div class="combobox-item text-muted" style="cursor:default;">No matches found</div>');
                }
            }

            // Toggle dropdown overlay on field click
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

            // Filter list as user types in search box inside dropdown popup
            $searchInput.off('input keyup').on('input keyup', function () {
                populateListItems($(this).val());
            });
        }

        function initSearchableDropdowns() {
            ['ddlCourseType', 'ddlCourseCategory', 'ddlFilterStatus'].forEach(function (id) {
                setupSearchableDropdown(id);
            });

            var $input = $('#txtCourseName');
            var $suggestions = $('#courseNameSuggestions');
            var timeoutId = null;

            $input.off('keyup focus').on('keyup focus', function () {
                var query = $(this).val();
                clearTimeout(timeoutId);

                if (query.length < 1) {
                    $suggestions.addClass('d-none').empty();
                    return;
                }

                timeoutId = setTimeout(function () {
                    $.ajax({
                        type: "POST",
                        url: "TrainingStatus.aspx/GetCourseNames",
                        data: JSON.stringify({ query: query }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            var list = response.d;
                            $suggestions.empty();
                            if (list && list.length > 0) {
                                $.each(list, function (i, item) {
                                    $('<div class="autocomplete-suggestion"></div>')
                                        .text(item)
                                        .appendTo($suggestions)
                                        .on('click', function () {
                                            $input.val(item).trigger('change');
                                            $suggestions.addClass('d-none').empty();
                                        });
                                });
                                $suggestions.removeClass('d-none');
                            } else {
                                $suggestions.addClass('d-none').empty();
                            }
                        },
                        error: function () {
                            $suggestions.addClass('d-none').empty();
                        }
                    });
                }, 250);
            });

            $(document).off('click.combobox').on('click.combobox', function (e) {
                if (!$(e.target).closest('.combobox-container, #txtCourseName, #courseNameSuggestions').length) {
                    $('.combobox-dropdown').addClass('d-none');
                    $suggestions.addClass('d-none');
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
