using System;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using System.Web;
using System.Web.Security;
using TrainingStatusPortal.Utils;

namespace TrainingStatusPortal
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (User.Identity.IsAuthenticated && Session["PCNO"] != null)
                {
                    Response.Redirect("TrainingStatus.aspx");
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            lblError.Visible = false;
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (string.IsNullOrEmpty(username))
            {
                ShowError("Username is required.");
                return;
            }

            if (string.IsNullOrEmpty(password))
            {
                ShowError("Password is required.");
                return;
            }

            string pcno = null;

            try
            {
                // Authenticate against Active Directory LDAP
                pcno = ADHelper.AuthenticateAndGetPCNO(username, password);
            }
            catch (Exception ex)
            {
                ShowError("Authentication Failed: " + ex.Message);
                return;
            }

            if (string.IsNullOrEmpty(pcno))
            {
                ShowError("Invalid Active Directory credentials or user not found.");
                return;
            }

            // Look up employee name from hrdata.empdetails database schema
            string name = username;
            try
            {
                string query = "SELECT NAME FROM hrdata.empdetails WHERE PCNO = :PCNO AND ROWNUM <= 1";
                object res = DBHelper.ExecuteScalar(DBHelper.GetHRDATAConnectionString(), query, new OracleParameter("PCNO", pcno));
                if (res != null && res != DBNull.Value && !string.IsNullOrEmpty(res.ToString()))
                {
                    name = res.ToString();
                }
            }
            catch (Exception ex)
            {
                // Note: Graceful fallback if database service is temporarily unreachable during login name lookup
                System.Diagnostics.Debug.WriteLine("Name lookup notice: " + ex.Message);
            }

            // Establish Web Forms Session and Auth Cookie
            Session["PCNO"] = pcno;
            Session["Name"] = name;

            FormsAuthentication.SetAuthCookie(pcno, false);
            Response.Redirect("TrainingStatus.aspx");
        }

        private void ShowError(string message)
        {
            lblError.Text = message;
            lblError.Visible = true;
        }
    }
}
