Function Get-FifteenChoice($Thing) {
    $Yes = New-Object System.Management.Automation.Host.ChoiceDescription '&Yes', "Do the ""$Thing"" thing"
    $No = New-Object System.Management.Automation.Host.ChoiceDescription '&No', "Continue"
    $Question = "Do you want to do the thing?"
    $Options = [System.Management.Automation.Host.ChoiceDescription[]]($Yes, $No)
    $Result = $host.ui.PromptForChoice("$Thing - Thing", $Question, $Options, 0)
    Switch ($Result) {
        0 { "Do $Thing here" }
        1 { "" }
    }
}