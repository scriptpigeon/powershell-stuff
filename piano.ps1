$y = 0
[System.Windows.Forms.SendKeys]::SendWait("{END}") 
do {
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
if ($x.VirtualKeyCode -eq 13) {
    # Enter
} elseif ($x.VirtualKeyCode -eq 90) {
    [System.Console]::Beep(174.6,200) # F (Z)
} elseif ($x.VirtualKeyCode -eq 83) {
    [System.Console]::Beep(185.0,200) # F# (S)
} elseif ($x.VirtualKeyCode -eq 88) {
    [System.Console]::Beep(196.0,200) # G (X)
} elseif ($x.VirtualKeyCode -eq 68) {
    [System.Console]::Beep(207.7,200) # G# (D)
} elseif ($x.VirtualKeyCode -eq 67) {
    [System.Console]::Beep(220.0,200) # A (C)
} elseif ($x.VirtualKeyCode -eq 70) {
    [System.Console]::Beep(233.1,200) # Bb (F)
} elseif ($x.VirtualKeyCode -eq 86) {
    [System.Console]::Beep(246.9,200) # B (V)


} elseif ($x.VirtualKeyCode -eq 66) {
    [System.Console]::Beep(261.6,200) # Middle C (B)
} elseif ($x.VirtualKeyCode -eq 72) {
    [System.Console]::Beep(277.2,200) # C# (H)
} elseif ($x.VirtualKeyCode -eq 78) {
    [System.Console]::Beep(293.7,200) # D (N)
} elseif ($x.VirtualKeyCode -eq 74) {
    [System.Console]::Beep(311.1,200) # Eb (J)
} elseif ($x.VirtualKeyCode -eq 77) {
    [System.Console]::Beep(329.6,200) # E (,)
} elseif ($x.VirtualKeyCode -eq 188) {
    [System.Console]::Beep(349.2,200) # F (.)
} elseif ($x.VirtualKeyCode -eq 76) {
    [System.Console]::Beep(370.0,200) # F# (l)
} elseif ($x.VirtualKeyCode -eq 190) {
    [System.Console]::Beep(392.0,200) # G (.)
} elseif ($x.VirtualKeyCode -eq 186) {
    [System.Console]::Beep(415.3,200) # G# (;)
} elseif ($x.VirtualKeyCode -eq 191) {
    [System.Console]::Beep(440.0,200) # A (/)
} elseif ($x.VirtualKeyCode -eq 192) {
    [System.Console]::Beep(466.2,200) # Bb (')
} elseif ($x.VirtualKeyCode -eq 16) {
    [System.Console]::Beep(493.9,200) # B (RShift)
} else {
    Write-Host $x.Character + $x.VirtualKeyCode
}
$y ++
} while ($y -lt 2000)

# Music

# Octave 1
<#
    # [System.Console]::Beep(16.35,600) # C
    # [System.Console]::Beep(17.32,600) # C#
    # [System.Console]::Beep(18.35,600) # D
    # [System.Console]::Beep(19.45,600) # Eb
    # [System.Console]::Beep(20.60,600) # E
    # [System.Console]::Beep(21.83,600) # F
    # [System.Console]::Beep(23.12,600) # F#
    # [System.Console]::Beep(24.50,600) # G
    # [System.Console]::Beep(25.96,600) # G#
    # [System.Console]::Beep(27.50,600) # A
    # [System.Console]::Beep(29.14,600) # Bb
    # [System.Console]::Beep(30.87,600) # B
#>

# Octave 2
<#
    # [System.Console]::Beep(32.70,600) # C
    # [System.Console]::Beep(34.65,600) # C#
    # [System.Console]::Beep(36.71,600) # D
    # [System.Console]::Beep(38.89,600) # Eb
    # [System.Console]::Beep(41.20,600) # E
    # [System.Console]::Beep(43.65,600) # F
    # [System.Console]::Beep(46.25,600) # F#
    # [System.Console]::Beep(49.00,600) # G
    # [System.Console]::Beep(51.91,600) # G#
    # [System.Console]::Beep(55.00,600) # A
    # [System.Console]::Beep(58.27,600) # Bb
    # [System.Console]::Beep(61.74,600) # B
#>

# Octave 3
<#
    # [System.Console]::Beep(65.41,600) # C
    # [System.Console]::Beep(69.30,600) # C#
    # [System.Console]::Beep(73.42,600) # D
    # [System.Console]::Beep(77.78,600) # Eb
    # [System.Console]::Beep(82.41,600) # E
    # [System.Console]::Beep(87.31,600) # F
    # [System.Console]::Beep(92.50,600) # F#
    # [System.Console]::Beep(98.00,600) # G
    # [System.Console]::Beep(103.8,600) # G#
    # [System.Console]::Beep(110.0,600) # A
    # [System.Console]::Beep(116.5,600) # Bb
    # [System.Console]::Beep(123.5,600) # B
#>

# Octave 4
<#
    # [System.Console]::Beep(130.8,600) # C
    # [System.Console]::Beep(138.6,600) # C#
    # [System.Console]::Beep(146.8,600) # D
    # [System.Console]::Beep(155.6,600) # Eb
    # [System.Console]::Beep(164.8,600) # E
    # [System.Console]::Beep(174.6,600) # F
    # [System.Console]::Beep(185.0,600) # F#
    # [System.Console]::Beep(196.0,600) # G
    # [System.Console]::Beep(207.7,600) # G#
    # [System.Console]::Beep(220.0,600) # A
    # [System.Console]::Beep(233.1,600) # Bb
    # [System.Console]::Beep(246.9,600) # B
#>
# Octave 5
<#
    # [System.Console]::Beep(261.6,600) # Middle C
    # [System.Console]::Beep(277.2,600) # C#
    # [System.Console]::Beep(293.7,600) # D
    # [System.Console]::Beep(311.1,600) # Eb
    # [System.Console]::Beep(329.6,600) # E
    # [System.Console]::Beep(349.2,600) # F
    # [System.Console]::Beep(370.0,600) # F#
    # [System.Console]::Beep(392.0,600) # G
    # [System.Console]::Beep(415.3,600) # G#
    # [System.Console]::Beep(440.0,600) # A
    # [System.Console]::Beep(466.2,600) # Bb
    # [System.Console]::Beep(493.9,600) # B
#>

# Octave 6
<#
    # [System.Console]::Beep(523.3,600) # C
    # [System.Console]::Beep(554.4,600) # C#
    # [System.Console]::Beep(587.3,600) # D
    # [System.Console]::Beep(622.3,600) # Eb
    # [System.Console]::Beep(659.3,600) # E
    # [System.Console]::Beep(698.5,600) # F
    # [System.Console]::Beep(740.0,600) # F#
    # [System.Console]::Beep(784.0,600) # G
    # [System.Console]::Beep(830.6,600) # G#
    # [System.Console]::Beep(880.0,600) # A
    # [System.Console]::Beep(932.3,600) # Bb
    # [System.Console]::Beep(987.8,600) # B
#>

# Octave 7
<#
    # [System.Console]::Beep(1047,600) # C
    # [System.Console]::Beep(1109,600) # C#
    # [System.Console]::Beep(1175,600) # D
    # [System.Console]::Beep(1245,600) # Eb
    # [System.Console]::Beep(1319,600) # E
    # [System.Console]::Beep(1397,600) # F
    # [System.Console]::Beep(1480,600) # F#
    # [System.Console]::Beep(1568,600) # G
    # [System.Console]::Beep(1661,600) # G#
    # [System.Console]::Beep(1760,600) # A
    # [System.Console]::Beep(1865,600) # Bb
    # [System.Console]::Beep(1976,600) # B
#>

# Octave 8
<#
    # [System.Console]::Beep(2093,600) # C
    # [System.Console]::Beep(2217,600) # C#
    # [System.Console]::Beep(2349,600) # D
    # [System.Console]::Beep(2489,600) # Eb
    # [System.Console]::Beep(2637,600) # E
    # [System.Console]::Beep(2794,600) # F
    # [System.Console]::Beep(2960,600) # F#
    # [System.Console]::Beep(3136,600) # G
    # [System.Console]::Beep(3322,600) # G#
    # [System.Console]::Beep(3520,600) # A
    # [System.Console]::Beep(3729,600) # Bb
    # [System.Console]::Beep(3951,600) # B
#>

# Octave 9
<#
    # [System.Console]::Beep(4186,600) # C
    # [System.Console]::Beep(4435,600) # C#
    # [System.Console]::Beep(4699,600) # D
    # [System.Console]::Beep(4978,600) # Eb
    # [System.Console]::Beep(5274,600) # E
    # [System.Console]::Beep(5588,600) # F
    # [System.Console]::Beep(5920,600) # F#
    # [System.Console]::Beep(6272,600) # G
    # [System.Console]::Beep(6645,600) # G#
    # [System.Console]::Beep(7040,600) # A
    # [System.Console]::Beep(7459,600) # Bb
    # [System.Console]::Beep(7902,600) # B
#>

# [System.Media.SystemSounds]::Beep.Play()
# [System.Media.SystemSounds]::Hand.Play()
# [System.Media.SystemSounds]::Asterisk.Play()
# [System.Media.SystemSounds]::Exclamation.Play()