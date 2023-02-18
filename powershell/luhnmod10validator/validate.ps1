<#
    .Description
    Allow a user to input a list of numbers (1 per line) and validate them against the Luhn Mod 10 Algorithm.
#>

# Load the Windows Forms assembly and enable visual styles
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

# Create the main form and set its properties
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Luhn Mod 10 Validation'
$form.Width = 560
$form.Height = 640

# Create a label for the text box
$label = New-Object System.Windows.Forms.Label
$label.Text = 'Enter the list of numbers to validate:'
$label.Location = New-Object System.Drawing.Point(10,20)
$label.AutoSize = $true
$form.Controls.Add($label)

# Create the text box for input and set its properties
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Multiline = $true
$textBox.AcceptsReturn = $true
$textBox.Location = New-Object System.Drawing.Point(10,50)
$textBox.Size = New-Object System.Drawing.Size(240,500)

# Set the textbox to allow only numeric input and the ability to paste
$textBox.Add_KeyPress({
    $key = $_.KeyChar
    $ctrlV = [System.Windows.Forms.Keys]::Control -bor [System.Windows.Forms.Keys]::V
    if (-not [char]::IsDigit($key) -and $_.KeyCode -ne $ctrlV -and $key -ne "`r" -and $key -ne "`t" -and $key -ne "`b") {
        $_.Handled = $true
    }
})
$textBox.ShortcutsEnabled = $true
$form.Controls.Add($textBox)

# Create a text box to display the results and set its properties
$resultsTextBox = New-Object System.Windows.Forms.TextBox
$resultsTextBox.Multiline = $true
$resultsTextBox.Location = New-Object System.Drawing.Point(260, 50)
$resultsTextBox.Size = New-Object System.Drawing.Size(240, 500)
$resultsTextBox.ReadOnly = $true
$form.Controls.Add($resultsTextBox)

# Create a button that opens a dialogue to choose a file of barcodes
$fileButton = New-Object System.Windows.Forms.Button
$fileButton.Location = New-Object System.Drawing.Point(10,560)
$fileButton.Size = New-Object System.Drawing.Size(60,30)
$fileButton.Text = 'Open'
$form.Controls.Add($fileButton)

$openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$openFileDialog.Filter = 'txt files (*.txt)|*.txt'

# Add a Click event handler for the Open button
$fileButton.Add_Click({
    if ($openFileDialog.ShowDialog() -eq 'OK') {
        $file = $openFileDialog.FileName
        $textBox.Text = Get-Content $file -Raw
    }
})

# Create a button to validate the input and set its properties
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(200,560)
$button.Size = New-Object System.Drawing.Size(120,30)
$button.Text = 'Validate'
$form.AcceptButton = $button
$form.Controls.Add($button)

# Create a button to clear the input and results and set its properties
$clearButton = New-Object System.Windows.Forms.Button
$clearButton.Location = New-Object System.Drawing.Point(340,560)
$clearButton.Size = New-Object System.Drawing.Size(120,30)
$clearButton.Text = 'Clear'
$form.Controls.Add($clearButton)

# Create a button to paste text into the text box and set its properties
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

# Add a Click event handler for the Paste button to allow standard keyboard shortcut (CTRL+V) to paste text
$pasteButton.Add_Click({
    $textBox.Paste()
})

# Add a Click event handler that calculates the luhn mod10 algorithm.
$button.Add_Click({
    # Check if the textbox is empty
    if ([string]::IsNullOrWhiteSpace($textBox.Text)) {
        [System.Windows.Forms.MessageBox]::Show("Please enter at least one number to validate.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    # Split the input into individual numbers
    $input = $textBox.Text -split '\s+'

    # Define the luhn mod 10 algorithm
    $f = {
        param($s)
        $s[$s.Length..0] | % {
            (1 + $i++ % 2) * "$_" # double every other digit, starting from the second-to-last
        } | % {
            $r += $_ - 9 * ($_ -gt 9) # sum the digits of each doubled number
        }
        !($r % 10) # return true if the sum is divisible by 10
    }

    # Apply the luhn mod 10 algorithm to each number and format the results
    $results = $input | ForEach-Object {
        $s = $_
        $result = &$f $s
        "$s : $($result)"
    }

    # Display the results in the results text box
    $resultsTextBox.Text = $results -join "`r`n"
})
$form.TopMost = $true
$result = $form.ShowDialog()
