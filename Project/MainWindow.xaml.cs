using Npgsql;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Data;
using System.Data.SqlClient;

namespace Project
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private readonly static string host = "localhost";
        private readonly static string userName = "postgres";
        private readonly static string dBName = "GameMarket";
        private readonly static string password = "ICO3v$LN#KM2w";
        private readonly static string port = "5432";

        public string Host { get { return host; } set { Host = value; } }
        public string UserName { get { return userName; } set { UserName = value; } }
        public string DBName { get { return dBName; } set { DBName = value; } }
        public string Password { get { return password; } set { Password = value; } }
        public string Port { get { return port; } set { Port = value; } }


        // Build connection string using parameters from portal
        static readonly string connString =
            String.Format(
                $"Server={host};" +
                $"Username={userName};" +
                $"Database={dBName};" +
                $"Port={port};" +
                $"Password={password}");

        Npgsql.NpgsqlConnection conn = new NpgsqlConnection(connString);
        List<string> table_names = new List<string>();
        DataTable dataTable = new DataTable();
        DataTable tables = new DataTable();
        NpgsqlDataAdapter adapter = new NpgsqlDataAdapter();
        public MainWindow()
        {
            InitializeComponent();

            // получение данных о всех таблицах
            tables = conn.GetSchema("Tables");

            foreach (DataRow row in tables.Rows)
                table_names.Add(Convert.ToString(row["table_name"]));

            foreach (string item in table_names)
                loadDataList.Items.Add(item);
        }

        private void Load_DataBase_Button(object sender, RoutedEventArgs e)
        {
            conn.Open();

            adapter = new NpgsqlDataAdapter($"select * from {loadDataList.SelectedItem}", conn);

            adapter.Fill(dataTable);
            adapter.Update(dataTable);

            dataGrid.ItemsSource = dataTable.AsDataView();

            conn.Close();
        }

        private void Update_Data_Button(object sender, RoutedEventArgs e)
        {
            conn.Open();

            try
            {
                NpgsqlCommandBuilder comandbuilder = new NpgsqlCommandBuilder(adapter);
                adapter.Update(dataTable);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }

            conn.Close();
        }

        private void ContextMenu_Delete_Button(object sender, RoutedEventArgs e)
        {
            conn.Open();

            try
            {
                dataTable.Rows.RemoveAt(dataGrid.SelectedIndex);
                adapter.Update(dataTable);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }

            conn.Close();
        }

        private void searchDataButton_Click(object sender, RoutedEventArgs e)
        {

        }
    }

}
