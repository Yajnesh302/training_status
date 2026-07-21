using System;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using System.Configuration;

namespace TrainingStatusPortal.Utils
{
    public static class DBHelper
    {
        public static string GetHRIMSConnectionString()
        {
            ConnectionStringSettings settings = ConfigurationManager.ConnectionStrings["HRIMS_DB"];
            if (settings == null || string.IsNullOrEmpty(settings.ConnectionString))
            {
                return "User Id=system;Password=root;Data Source=//127.0.0.1:1521/xe";
            }
            return settings.ConnectionString;
        }

        public static string GetHRDATAConnectionString()
        {
            ConnectionStringSettings settings = ConfigurationManager.ConnectionStrings["HRDATA_DB"];
            if (settings == null || string.IsNullOrEmpty(settings.ConnectionString))
            {
                return "User Id=system;Password=root;Data Source=//127.0.0.1:1521/xe";
            }
            return settings.ConnectionString;
        }

        public static OracleConnection GetHRIMSConnection()
        {
            OracleConnection conn = new OracleConnection(GetHRIMSConnectionString());
            conn.Open();
            return conn;
        }

        public static OracleConnection GetHRDATAConnection()
        {
            OracleConnection conn = new OracleConnection(GetHRDATAConnectionString());
            conn.Open();
            return conn;
        }

        public static DataTable ExecuteQuery(string connString, string commandText, params OracleParameter[] parameters)
        {
            DataTable dt = new DataTable();
            using (OracleConnection conn = new OracleConnection(connString))
            {
                using (OracleCommand cmd = new OracleCommand(commandText, conn))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.BindByName = true;
                    if (parameters != null && parameters.Length > 0)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }
                    using (OracleDataAdapter adapter = new OracleDataAdapter(cmd))
                    {
                        adapter.Fill(dt);
                    }
                }
            }
            return dt;
        }

        public static object ExecuteScalar(string connString, string commandText, params OracleParameter[] parameters)
        {
            using (OracleConnection conn = new OracleConnection(connString))
            {
                using (OracleCommand cmd = new OracleCommand(commandText, conn))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.BindByName = true;
                    if (parameters != null && parameters.Length > 0)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }
                    conn.Open();
                    return cmd.ExecuteScalar();
                }
            }
        }

        public static int ExecuteNonQuery(string connString, string commandText, params OracleParameter[] parameters)
        {
            using (OracleConnection conn = new OracleConnection(connString))
            {
                using (OracleCommand cmd = new OracleCommand(commandText, conn))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.BindByName = true;
                    if (parameters != null && parameters.Length > 0)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }
                    conn.Open();
                    return cmd.ExecuteNonQuery();
                }
            }
        }
    }
}
