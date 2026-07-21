using System;
using System.Collections.Generic;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using System.Configuration;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using TrainingStatusPortal.Utils;

namespace TrainingStatusPortal
{
    public partial class TrainingStatus : System.Web.UI.Page
    {
        protected override PageStatePersister PageStatePersister
        {
            get { return new SessionPageStatePersister(this); }
        }

        private static string TrainingTableName 
        { 
            get { return ConfigurationManager.AppSettings["TrainingTableName"] ?? "hrims.bkup_hr_emp_training_21jul2026"; } 
        }

        private static string CourseCategoryTableName 
        { 
            get { return ConfigurationManager.AppSettings["CourseCategoryTableName"] ?? "hrims.hr_course_category"; } 
        }

        private static string TrainingStatusTableName 
        { 
            get { return ConfigurationManager.AppSettings["TrainingStatusTableName"] ?? "hrims.hr_training_status"; } 
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                PopulateFilterDropdowns();
                BindGrid();
            }
        }

        public string FormatCourseType(object courseTypeObj)
        {
            if (courseTypeObj == null || courseTypeObj == DBNull.Value || string.IsNullOrEmpty(courseTypeObj.ToString().Trim()))
            {
                return "<span class=\"badge badge-type-default px-2 py-1\">(Blank)</span>";
            }
            string val = courseTypeObj.ToString().Trim();
            string cssClass = "badge-type-default";
            string lower = val.ToLower();

            if (lower.Contains("internal")) cssClass = "badge-type-internal";
            else if (lower.Contains("external")) cssClass = "badge-type-external";
            else if (lower.Contains("workshop")) cssClass = "badge-type-workshop";
            else if (lower.Contains("seminar")) cssClass = "badge-type-seminar";

            return string.Format("<span class=\"badge {0} px-2 py-1\">{1}</span>", cssClass, Server.HtmlEncode(val));
        }

        protected void Filter_Changed(object sender, EventArgs e)
        {
            gvTraining.PageIndex = 0;
            BindGrid();
        }

        private void PopulateFilterDropdowns()
        {
            try
            {
                // 1. Course Type Dropdown
                string typeQuery = string.Format("SELECT DISTINCT coursetype FROM {0} ORDER BY coursetype NULLS FIRST", TrainingTableName);
                DataTable dtTypes = DBHelper.ExecuteQuery(DBHelper.GetHRIMSConnectionString(), typeQuery);
                
                ddlCourseType.Items.Clear();
                ddlCourseType.Items.Add(new ListItem("-- All Course Types --", ""));
                ddlCourseType.Items.Add(new ListItem("(Blank / NULL)", "BLANK"));

                foreach (DataRow row in dtTypes.Rows)
                {
                    if (row["coursetype"] != DBNull.Value && !string.IsNullOrEmpty(row["coursetype"].ToString()))
                    {
                        string val = row["coursetype"].ToString();
                        ddlCourseType.Items.Add(new ListItem(val, val));
                    }
                }

                // 2. Course Category Dropdown
                string catQuery = string.Format("SELECT code, description FROM {0} ORDER BY code", CourseCategoryTableName);
                DataTable dtCat = DBHelper.ExecuteQuery(DBHelper.GetHRIMSConnectionString(), catQuery);

                ddlCourseCategory.Items.Clear();
                ddlCourseCategory.Items.Add(new ListItem("-- All Categories --", ""));
                foreach (DataRow row in dtCat.Rows)
                {
                    ddlCourseCategory.Items.Add(new ListItem(row["description"].ToString(), row["code"].ToString()));
                }

                // 3. Training Status Filter Dropdown
                string statusQuery = string.Format("SELECT code, description FROM {0} ORDER BY code", TrainingStatusTableName);
                DataTable dtStatus = DBHelper.ExecuteQuery(DBHelper.GetHRIMSConnectionString(), statusQuery);

                ddlFilterStatus.Items.Clear();
                ddlFilterStatus.Items.Add(new ListItem("-- All Statuses --", ""));
                foreach (DataRow row in dtStatus.Rows)
                {
                    ddlFilterStatus.Items.Add(new ListItem(row["description"].ToString(), row["code"].ToString()));
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Database Initialization Error: " + ex.Message, "alert-danger");
            }
        }

        private void BindGrid()
        {
            try
            {
                List<OracleParameter> parameters = new List<OracleParameter>();
                string query = string.Format(@"
                    SELECT 
                        t.ROWID AS ROW_ID, 
                        t.pcno, 
                        t.coursetype, 
                        t.coursename, 
                        t.startdate, 
                        t.enddate, 
                        t.course_category, 
                        c.description AS CATEGORY_DESC, 
                        t.training_status, 
                        s.description AS STATUS_DESC 
                    FROM {0} t 
                    LEFT JOIN {1} c ON t.course_category = c.code 
                    LEFT JOIN {2} s ON t.training_status = s.code 
                    WHERE 1=1", TrainingTableName, CourseCategoryTableName, TrainingStatusTableName);

                // Apply Filters
                if (!string.IsNullOrEmpty(ddlCourseType.SelectedValue))
                {
                    if (ddlCourseType.SelectedValue == "BLANK")
                    {
                        query += " AND t.coursetype IS NULL";
                    }
                    else
                    {
                        query += " AND t.coursetype = :coursetype";
                        parameters.Add(new OracleParameter("coursetype", ddlCourseType.SelectedValue));
                    }
                }

                if (!string.IsNullOrEmpty(ddlCourseCategory.SelectedValue))
                {
                    query += " AND t.course_category = :course_category";
                    parameters.Add(new OracleParameter("course_category", Convert.ToInt32(ddlCourseCategory.SelectedValue)));
                }

                if (!string.IsNullOrEmpty(txtCourseName.Text.Trim()))
                {
                    query += " AND LOWER(t.coursename) LIKE :coursename";
                    parameters.Add(new OracleParameter("coursename", "%" + txtCourseName.Text.Trim().ToLower() + "%"));
                }

                if (!string.IsNullOrEmpty(ddlFilterStatus.SelectedValue))
                {
                    query += " AND t.training_status = :training_status";
                    parameters.Add(new OracleParameter("training_status", Convert.ToInt32(ddlFilterStatus.SelectedValue)));
                }

                if (!string.IsNullOrEmpty(txtStartDate.Text.Trim()))
                {
                    query += " AND t.startdate >= TO_DATE(:startdate, 'YYYY-MM-DD')";
                    parameters.Add(new OracleParameter("startdate", txtStartDate.Text.Trim()));
                }

                if (!string.IsNullOrEmpty(txtEndDate.Text.Trim()))
                {
                    query += " AND t.enddate <= TO_DATE(:enddate, 'YYYY-MM-DD')";
                    parameters.Add(new OracleParameter("enddate", txtEndDate.Text.Trim()));
                }

                query += " ORDER BY t.startdate DESC, t.pcno ASC";

                DataTable dt = DBHelper.ExecuteQuery(DBHelper.GetHRIMSConnectionString(), query, parameters.ToArray());

                // Resolve Employee Names from hrdata.empdetails via PCNO
                dt.Columns.Add("EMP_NAME", typeof(string));

                Dictionary<string, string> nameCache = new Dictionary<string, string>();
                foreach (DataRow row in dt.Rows)
                {
                    string pcno = row["pcno"] != DBNull.Value ? row["pcno"].ToString() : "";
                    if (!string.IsNullOrEmpty(pcno))
                    {
                        if (!nameCache.ContainsKey(pcno))
                        {
                            string empName = GetEmployeeNameByPCNO(pcno);
                            nameCache[pcno] = empName;
                        }
                        row["EMP_NAME"] = nameCache[pcno];
                    }
                    else
                    {
                        row["EMP_NAME"] = "N/A";
                    }
                }

                gvTraining.DataSource = dt;
                gvTraining.DataBind();

                lblRecordCount.Text = dt.Rows.Count + " Record(s) Found";
            }
            catch (Exception ex)
            {
                ShowAlert("Error Loading Training Records: " + ex.Message, "alert-danger");
            }
        }

        private string GetEmployeeNameByPCNO(string pcno)
        {
            try
            {
                string empQuery = "SELECT NAME FROM hrdata.empdetails WHERE PCNO = :PCNO AND ROWNUM <= 1";
                object res = DBHelper.ExecuteScalar(DBHelper.GetHRDATAConnectionString(), empQuery, new OracleParameter("PCNO", pcno));
                if (res != null && res != DBNull.Value && !string.IsNullOrEmpty(res.ToString()))
                {
                    return res.ToString();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Emp lookup error for " + pcno + ": " + ex.Message);
            }
            return pcno;
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            gvTraining.PageIndex = 0;
            BindGrid();
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ddlCourseType.SelectedIndex = 0;
            ddlCourseCategory.SelectedIndex = 0;
            ddlFilterStatus.SelectedIndex = 0;
            txtCourseName.Text = string.Empty;
            txtStartDate.Text = string.Empty;
            txtEndDate.Text = string.Empty;

            gvTraining.PageIndex = 0;
            BindGrid();
            ShowAlert("Filters reset successfully.", "alert-info");
        }

        protected void gvTraining_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvTraining.PageIndex = e.NewPageIndex;
            BindGrid();
        }

        protected void gvTraining_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DropDownList ddlRowStatus = (DropDownList)e.Row.FindControl("ddlRowStatus");
                HiddenField hfCurrentStatus = (HiddenField)e.Row.FindControl("hfCurrentStatus");

                if (ddlRowStatus != null && hfCurrentStatus != null)
                {
                    ddlRowStatus.Items.Clear();
                    try
                    {
                        string statusQuery = string.Format("SELECT code, description FROM {0} ORDER BY code", TrainingStatusTableName);
                        DataTable dtStatus = DBHelper.ExecuteQuery(DBHelper.GetHRIMSConnectionString(), statusQuery);

                        foreach (DataRow statusRow in dtStatus.Rows)
                        {
                            ddlRowStatus.Items.Add(new ListItem(statusRow["description"].ToString(), statusRow["code"].ToString()));
                        }
                    }
                    catch
                    {
                        ddlRowStatus.Items.Add(new ListItem("Nominated", "1"));
                        ddlRowStatus.Items.Add(new ListItem("Done in OG", "2"));
                        ddlRowStatus.Items.Add(new ListItem("Done in RG", "3"));
                        ddlRowStatus.Items.Add(new ListItem("Ongoing", "4"));
                        ddlRowStatus.Items.Add(new ListItem("Completed", "5"));
                    }

                    string currentStatus = hfCurrentStatus.Value;
                    if (!string.IsNullOrEmpty(currentStatus) && ddlRowStatus.Items.FindByValue(currentStatus) != null)
                    {
                        ddlRowStatus.SelectedValue = currentStatus;
                    }
                }
            }
        }

        protected void ddlRowStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddlRowStatus = (DropDownList)sender;
            GridViewRow row = (GridViewRow)ddlRowStatus.NamingContainer;

            HiddenField hfRowId = (HiddenField)row.FindControl("hfRowId");
            Panel pnlSavedBadge = (Panel)row.FindControl("pnlSavedBadge");

            if (ddlRowStatus != null && hfRowId != null && !string.IsNullOrEmpty(hfRowId.Value))
            {
                int newStatus = Convert.ToInt32(ddlRowStatus.SelectedValue);
                string rowId = hfRowId.Value;

                try
                {
                    string updateQuery = string.Format("UPDATE {0} SET training_status = :training_status WHERE ROWID = :row_id", TrainingTableName);
                    int affected = DBHelper.ExecuteNonQuery(DBHelper.GetHRIMSConnectionString(), updateQuery,
                        new OracleParameter("training_status", newStatus),
                        new OracleParameter("row_id", rowId));

                    if (affected > 0)
                    {
                        if (pnlSavedBadge != null)
                        {
                            pnlSavedBadge.Visible = true;
                        }
                        ShowAlert("Status updated to \"" + ddlRowStatus.SelectedItem.Text + "\" successfully!", "alert-success");
                    }
                    else
                    {
                        ShowAlert("Update failed: Target record not found.", "alert-warning");
                    }
                }
                catch (Exception ex)
                {
                    ShowAlert("Database Update Error: " + ex.Message, "alert-danger");
                }
            }
        }

        [WebMethod]
        public static List<string> GetCourseNames(string query)
        {
            List<string> list = new List<string>();
            if (string.IsNullOrEmpty(query)) return list;

            try
            {
                string sql = string.Format("SELECT DISTINCT coursename FROM {0} WHERE LOWER(coursename) LIKE :query AND ROWNUM <= 20 ORDER BY coursename", TrainingTableName);
                DataTable dt = DBHelper.ExecuteQuery(DBHelper.GetHRIMSConnectionString(), sql, new OracleParameter("query", "%" + query.ToLower() + "%"));

                foreach (DataRow row in dt.Rows)
                {
                    if (row["coursename"] != DBNull.Value)
                    {
                        list.Add(row["coursename"].ToString());
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Course autocomplete error: " + ex.Message);
            }

            return list;
        }

        private void ShowAlert(string message, string alertCssClass)
        {
            lblAlertMessage.Text = message;
            pnlAlert.CssClass = "alert alert-dismissible fade show toast-card";
            pnlAlert.Visible = true;
        }
    }
}
