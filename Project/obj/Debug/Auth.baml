   M S B A M L   `   `   `  ����B  >Project, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null!clr-namespace:ProjectProject  5   	       Project.Auth   5   	   R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35\ XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35D 9http://schemas.microsoft.com/winfx/2006/xaml/presentation    5   	   R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5   	   @d2http://schemas.microsoft.com/expression/blend/2008     5   	   Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     5   	   'localclr-namespace:Project     5   	     � Title$
  Auth��5   	   $	��450��6   $	��800��6#   .��5	      � -   5         �Name$
 grid��5	       � RowDefinitions 5
   
   �� 5      �� 5      �� 5      �� 5      �� 5      �� 5      �� 5       � ColumnDefinitions 5   
   �� 5      �� 5      �� 5      �� 5      .+�5   
   �� $
��30pt(�6    �� TextAlignment$ Center=�5      $��Authorization��5      $��0��5      $��1��5      $��2��5       �� 5"   
   $
��30pt(�6   $��Host:��5#      $��1��5$      $��1��5%      �� 5&   
   $
��30pt(�6   $��	Username:��5'      $��2��5(      $��1��5)      �� 5*   
   $
��30pt(�6   $��DBname:��5+      $��3��5,      $��1��5-      �� 5.   
   $
��30pt(�6   $��	Password:��5/      $��4��50      $��1��51      �� 52   
   $
��30pt(�6   $��Port:��53      $��5��54      $��1��55      �� 57   
   -   5         ��Name$ textHost��57      $��	localhost��58      $��1��59      $��2��5:      $
��15pt(�5;      $��Center=�5<      �� 5=   
   -   5        $ textUsername��5=      $��postgres��5>      $��2��5?      $��2��5@      $
��15pt(�5A      $��Center=�5B      �� 5C   
   -   5        $ 
textDBname��5C      $��
GameMarket��5D      $��3��5E      $��2��5F      $
��15pt(�5G      $��Center=�5H      G� 5I   
   -   5         G�Name$ textPassword��5I       G� PasswordChar$	 ●��5J       G� Password$ ICO3v$LN#KM2w��5K      $��4��5L      $��2��5M      $
��15pt(�5N      $��Center=�5O      �� 5P   
   -   5        $ textPort��5P      $
��5432��5Q      $��5��5R      $��2��5S      $
��15pt(�5T      $��Center=�5U      �� 5W   
   -   5        	 ��Name$	 
authButton��5W      $��Log in��5X      $��6��5Y      $��1��5Z      $��2��5[      $��Center=�5\      $
��20,0q�5]      5^      5_      5`      