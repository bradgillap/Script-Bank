<#
    .Description
    Allow a user to input a list of numbers (1 per line) and validate them against the Luhn Mod 10 Algorithm.
#>
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Luhn Mod 10 Validation'
$form.Width = 540
$form.Height = 640

$label = New-Object System.Windows.Forms.Label
$label.Text = 'Enter the list of numbers to validate:'
$label.Location = New-Object System.Drawing.Point(10,20)
$label.AutoSize = $true
$form.Controls.Add($label)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Multiline = $true
$textBox.AcceptsReturn = $true
$textBox.Location = New-Object System.Drawing.Point(10,50)
$textBox.Size = New-Object System.Drawing.Size(240,500)

# Set the textbox to allow only numeric input
$textBox.Add_KeyPress({
    $key = $_.KeyChar
    if (-not [char]::IsDigit($key) -and $key -ne "`r" -and $key -ne "`t" -and $key -ne "`b") {
        $_.Handled = $true
    }
})
$textBox.ShortcutsEnabled = $true
$form.Controls.Add($textBox)

$resultsTextBox = New-Object System.Windows.Forms.TextBox
$resultsTextBox.Multiline = $true
$resultsTextBox.Location = New-Object System.Drawing.Point(260, 50)
$resultsTextBox.Size = New-Object System.Drawing.Size(240, 500)
$resultsTextBox.ReadOnly = $true
$form.Controls.Add($resultsTextBox)

$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(200,560)
$button.Size = New-Object System.Drawing.Size(120,30)
$button.Text = 'Validate'
$form.AcceptButton = $button
$form.Controls.Add($button)

$clearButton = New-Object System.Windows.Forms.Button
$clearButton.Location = New-Object System.Drawing.Point(340,560)
$clearButton.Size = New-Object System.Drawing.Size(120,30)
$clearButton.Text = 'Clear'
$form.Controls.Add($clearButton)

$pasteButton = New-Object System.Windows.Forms.Button
$pasteButton.Location = New-Object System.Drawing.Point(80,560)
$pasteButton.Size = New-Object System.Drawing.Size(120,30)
$pasteButton.Text = 'Paste'
$form.Controls.Add($pasteButton)

# Add a Click event handler for the Clear button
$clearButton.Add_Click({
    $textBox.Text = ''
    $resultsTextBox.Text = ''
})

# Add a Click event handler for the Paste button
$pasteButton.Add_Click({
    $textBox.Paste()
})
# Add a Click event handler that calculates the luhn mod10 algorithm.
$button.Add_Click({
    $input = $textBox.Text -split '\s+'
    $f = {
        param($s)
        $s[$s.Length..0]|%{(1+$i++%2)*"$_"}|%{$r+=$_-9*($_-gt9)}
        !($r%10)
    }

    $results = $input | ForEach-Object {
        $s = $_
        $result = &$f $s
        "$s : $($result)"
    }
    $resultsTextBox.Text = $results -join "`r`n"
})

$form.Topmost = $True
$result = $form.ShowDialog()
