#Build WPF XAML in Visual studio first.
#ERASE ALL THIS AND PUT XAML BELOW between the @" "@
#Attach logic to controls. The script will do the necessary replacements to the XAML to make it work in powershell.
#Reference: https://foxdeploy.com/2015/04/16/part-ii-deploying-powershell-guis-in-minutes-using-visual-studio/

$inputXML = @"
<Window x:Class="WpfApp1.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApp1"
        mc:Ignorable="d"
        Title="WPF App 1" Height="350" Width="525">
    <Grid>
        <Image x:Name="tubeImage" HorizontalAlignment="Left" Height="100" Margin="35,45,0,0" VerticalAlignment="Top" Width="100" Source="C:\Users\GILLAPB\source\repos\WpfApp1\tube.png" Stretch="UniformToFill"/>
        <TextBlock x:Name="descriptionTextBlock" HorizontalAlignment="Left" Margin="151,45,0,0" TextWrapping="Wrap" Text="Use this tool as an example for sorting out disk information using WPF in visual studio." VerticalAlignment="Top" Height="62" Width="339" FontSize="16"/>
        <Button x:Name="okButton1" Content="OK" HorizontalAlignment="Left" Margin="389,257,0,0" VerticalAlignment="Top" Width="101" Height="56"/>
        <Label x:Name="userNameLabel" Content="UserName" HorizontalAlignment="Left" Margin="99,163,0,0" VerticalAlignment="Top" RenderTransformOrigin="0.512,0.322" FontSize="14"/>
        <TextBox x:Name="userNameTextBox" HorizontalAlignment="Left" Height="23" Margin="178,168,0,0" TextWrapping="Wrap" Text="TextBox" VerticalAlignment="Top" Width="120"/>

    </Grid>
</Window>
"@       
 
$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N'  -replace '^<Win.*', '<Window'
 
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = $inputXML
#Read XAML
 
    $reader=(New-Object System.Xml.XmlNodeReader $xaml)
  try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
catch{Write-Host "Unable to load Windows.Markup.XamlReader. Double-check syntax and ensure .net is installed."}
 
#===========================================================================
# Load XAML Objects In PowerShell
#===========================================================================
 
$xaml.SelectNodes("//*[@Name]") | %{Set-Variable -Name "WPF$($_.Name)" -Value $Form.FindName($_.Name)}
 
Function Get-FormVariables{
if ($global:ReadmeDisplay -ne $true){Write-host "If you need to reference this display again, run Get-FormVariables" -ForegroundColor Yellow;$global:ReadmeDisplay=$true}
write-host "Found the following interactable elements from our form" -ForegroundColor Cyan
get-variable WPF*
}
 
Get-FormVariables
 
#===========================================================================
# Actually make the objects work
#===========================================================================
 
#Sample entry of how to add data to a field
 
#$vmpicklistView.items.Add([pscustomobject]@{'VMName'=($_).Name;Status=$_.Status;Other="Yes"})

$WPFuserNameTextBox.Text = 'My Dudes'
 
#===========================================================================
# Shows the form
#===========================================================================
write-host "To show the form, run the following" -ForegroundColor Cyan
$Form.ShowDialog() | out-null
