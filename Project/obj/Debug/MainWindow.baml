   M S B A M L   `   `   `  ����B  >Project, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null!clr-namespace:ProjectProject  5   	       Project.MainWindow   5   	   R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35\ XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35D 9http://schemas.microsoft.com/winfx/2006/xaml/presentation    5   	   R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5   	   @d2http://schemas.microsoft.com/expression/blend/2008     5   	   Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     5   	   'localclr-namespace:Project     5   	     � Title$  
MainWindow��5   	   $	��450��6   $	��800��6)   .��5	      �  � RowDefinitions 5
   
   �� 5      $��300px �6   �� 5      $
��80px �6    � ColumnDefinitions 5   
   �� 5      $	��64* �6   �� 5      $	��91* �6   �� 5      $
��245* �6   �� 5      $
��400* �6   .+�5   
   &   System.Windows.Controls.DataGrid  -   5          Name$ dataGrid��5      $	��200��6%   $��4��62   $
��Left=�6F   $	��Top=�6a   $	��772��6y   $��14,0,0,0q�6�    � ContextMenu 5      �� 5      -   5        $��gridContextMenu��5       �� 	StaysOpen . .@�5      m� -   5        $��Удалить��5      60   5      5      �� 5   
   -   5         ��Name$ loadDataButton��5      $��61,50,125,0q�6)   $	��150��6>   $!��Загрузить базу��6J   $��1��6c   $��1��6�   $��2��6�   �� 5   
   -   5        $ updateDataButton��5      $��125,50,125,0q�6+   $	��150��6A   $��Обновить базу��6M   $��1��6e   $��3��6r   6�   �� 5   
   -   5        $ searchDataButton��5      $��170,50,325,0q�6+   $	��150��6A   $��Поиск по базе��6M   $��1��6e   $��2��6r   $��2��6�   6�   �� 5!   
   -   5         ��Name$ loadDataList��5!      $	��Top=�6)   $	��200��6A   $��1��6M   $��1��6Z   $��
36,0,100,0q�6j   $��2��6~   5#      5$      5%      