using System;
using System.DirectoryServices;
using System.Configuration;

namespace TrainingStatusPortal.Utils
{
    public static class ADHelper
    {
        public static string AuthenticateAndGetPCNO(string username, string password)
        {
            if (string.IsNullOrEmpty(username))
            {
                throw new ArgumentException("Username cannot be empty.");
            }

            string pcno = null;
            string ldapPath = ConfigurationManager.AppSettings["ADConnectionPath"];
            if (string.IsNullOrEmpty(ldapPath))
            {
                ldapPath = "LDAP://192.168.0.106/DC=ad01,DC=yajnesh,DC=com";
            }

            try
            {
                using (DirectoryEntry entry = new DirectoryEntry(ldapPath, username, password))
                {
                    object native = entry.NativeObject;

                    using (DirectorySearcher search = new DirectorySearcher(entry))
                    {
                        search.Filter = "(sAMAccountName=" + username + ")";
                        search.PropertiesToLoad.Add("EmployeeID");
                        search.PropertiesToLoad.Add("sAMAccountName");

                        SearchResult result = search.FindOne();

                        if (result != null)
                        {
                            using (DirectoryEntry dsresult = result.GetDirectoryEntry())
                            {
                                if (dsresult.Properties.Contains("EmployeeID") && dsresult.Properties["EmployeeID"].Count > 0)
                                {
                                    pcno = dsresult.Properties["EmployeeID"][0].ToString();
                                }
                                else
                                {
                                    pcno = username;
                                }
                            }
                        }
                        else
                        {
                            pcno = username;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Active Directory Authentication Error: " + ex.Message, ex);
            }

            return pcno;
        }
    }
}
