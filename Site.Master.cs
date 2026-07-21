using System;
using System.Web;
using System.Web.Security;
using Oracle.ManagedDataAccess.Client;
using TrainingStatusPortal.Utils;

namespace TrainingStatusPortal
{
    public partial class SiteMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string pcno = Session["PCNO"] != null ? Session["PCNO"].ToString() : (Page.User.Identity.IsAuthenticated ? Page.User.Identity.Name : null);
                string name = Session["Name"] != null ? Session["Name"].ToString() : null;

                if (!string.IsNullOrEmpty(pcno))
                {
                    if (string.IsNullOrEmpty(name) || name == pcno)
                    {
                        try
                        {
                            string query = "SELECT NAME FROM hrdata.empdetails WHERE PCNO = :PCNO AND ROWNUM <= 1";
                            object res = DBHelper.ExecuteScalar(DBHelper.GetHRDATAConnectionString(), query, new OracleParameter("PCNO", pcno));
                            if (res != null && res != DBNull.Value && !string.IsNullOrEmpty(res.ToString()))
                            {
                                name = res.ToString();
                                Session["Name"] = name;
                            }
                        }
                        catch (Exception ex)
                        {
                            System.Diagnostics.Debug.WriteLine("Master name lookup error: " + ex.Message);
                        }
                    }

                    litUserInfo.Text = !string.IsNullOrEmpty(name) ? name : pcno;
                }
                else if (Page.User.Identity.IsAuthenticated)
                {
                    litUserInfo.Text = Page.User.Identity.Name;
                }
                else
                {
                    Response.Redirect("Login.aspx");
                }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            FormsAuthentication.SignOut();
            Response.Redirect("Login.aspx");
        }
    }
}
