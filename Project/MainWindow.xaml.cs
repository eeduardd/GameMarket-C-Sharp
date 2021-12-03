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

namespace Project
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private static string Host = "localhost";
        private static string Username = "postgres";
        private static string DBname = "GameMarket";
        private static string Password = "ICO3v$LN#KM2w";
        private static string Port = "5432";

        // Build connection string using parameters from portal
        string connString =
            String.Format(
                $"Server={Host};" +
                $"Username={Username};" +
                $"Database={DBname};" +
                $"Port={Port};" +
                $"Password={Password}");
        public MainWindow()
        {
            InitializeComponent();
        }

        private void Button_Load_Database(object sender, RoutedEventArgs e)
        {
            using (Npgsql.NpgsqlConnection conn = new NpgsqlConnection(connString))
            {
                conn.Open();
                if (conn.State == System.Data.ConnectionState.Open)
                    MessageBox.Show("Connected");

                NpgsqlCommand cmd = new NpgsqlCommand("SELECT * FROM ", conn);
                cmd.ExecuteNonQuery();
            }
        }
    }
}
