$Speaker = New-Object -ComObject "SAPI.SpVoice"
$Voices = $Speaker.GetVoices()

Function Get-FifteenTalk([Int32]$Index, [Int32]$Rate, [String]$Words) {

    $Speaker.Rate = $Rate
    $Speaker.Voice = $Voices.Item($Index)
    $Colour = switch($Index){0 {"Red"} 1 {"Green"}}
    $Speaker.Speak($Words, 1) | Out-Null
    Write-Host $Words -ForegroundColor $Colour
    $Speaker.WaitUntilDone(600) | Out-Null

}

Get-FifteenTalk 0 2 "Knock knock"
Get-FifteenTalk 1 0 "Who''s there?"
Get-FifteenTalk 0 2 "Short-term memory loss"
Get-FifteenTalk 1 0 "Short-term memory loss Who?"
Get-FifteenTalk 0 2 "Knock knock"