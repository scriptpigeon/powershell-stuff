$speaker = New-Object -ComObject "SAPI.SpVoice"
$voices = $speaker.GetVoices()

Function Speak([Int32]$index, [Int32]$rate, [String]$words){
  $speaker.Rate = $rate
  $speaker.Voice = $voices.Item($index)
  $colour = switch($index){0 {"Red"} 1 {"Green"}}
  $speaker.Speak($words, 1) | Out-Null
  Write-Host $words -ForegroundColor $colour
  $speaker.WaitUntilDone(600) | Out-Null
}

Speak 0 2 "Thank you for visiting qwerty.design"
Speak 1 0 "He really appreciates it"
Speak 0 2 "Shut up!"
Speak 1 0 "No seriously, he does!"
Speak 0 2 "That is true"