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
using System.Windows.Shapes;

namespace Project
{
    /// <summary>
    /// Interaction logic for Auth.xaml
    /// </summary>
    public partial class Auth : Window
    {
        MainWindow mainWindow = new MainWindow();
        public Auth()
        {
            InitializeComponent();
        }
        private void Click_Authorization(object sender, RoutedEventArgs e)
        {
            if (textHost.Text == mainWindow.Host
                & textUsername.Text == mainWindow.UserName
                & textDBname.Text == mainWindow.DBName
                & textPassword.Password == mainWindow.Password
                & textPort.Text == mainWindow.Port)
            {
                this.Close();
                mainWindow.Show();
            }
            else MessageBox.Show("Введите корректные данные!");
        }
    }
}
