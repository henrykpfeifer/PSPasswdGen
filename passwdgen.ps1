param(
    [int]$Count = 10,
    [string]$OutputFile
)

# default output:
if (-not $OutputFile) {
    $OutputFile = Join-Path -Path $PSScriptRoot -ChildPath 'generated-password.txt'
}

# Config of allowed chars
$vowels       = @('a','e','i','u')                               # no 'o'
$firstVowels  = @('a','e','u')                                   # no 'I'
$consonants   = @('b','c','d','f','g','h','j','k','m','n','p','q','r','s','t','v','w','x','y','z') # no 'l'
$separators   = @(':','%','-','.','@','_','!','#','?','&','+','$')
$digits       = @('2','3','4','5','6','7','8','9')               # no '0' & '1'

# Cryptographically secure random number generator
$Rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()

function Get-SecureIndex {
    param(
        [int]$MaxValue
    )
    $bytes = New-Object byte[] 4
    $Rng.GetBytes($bytes)
    $value = [BitConverter]::ToUInt32($bytes, 0)
    return [int]($value % $MaxValue)
}

function New-PseudoWord {
    param(
        [bool]$StartWithVowel
    )
    $chars = New-Object System.Collections.Generic.List[string]

    if ($StartWithVowel) {
        # V C V C V
        $pattern = @('V','C','V','C','V')
    } else {
        # C V C V C
        $pattern = @('C','V','C','V','C')
    }

    $lastChar = $null
    foreach ($slot in $pattern) {
        if ($slot -eq 'C') {
            $set = $consonants
        } else {
            # 1st letter of word -> no 'i' => not beginning with 'I'
            if ($chars.Count -eq 0 -and $StartWithVowel) {
                $set = $firstVowels
            } else {
                $set = $vowels
            }
        }

        do {
            $index = Get-SecureIndex -MaxValue $set.Length
            $c = $set[$index]
        } while ($lastChar -ne $null -and $c -eq $lastChar) # No duplicate characters next to each other

        $chars.Add($c)
        $lastChar = $c
    }

    $word = -join $chars
    return ($word.Substring(0,1).ToUpper() + $word.Substring(1))
}

function New-Digits {
    param(
        [int]$Length
    )
    $chars = New-Object System.Collections.Generic.List[string]
    $lastChar = $null

    for ($i = 0; $i -lt $Length; $i++) {
        do {
            $index = Get-SecureIndex -MaxValue $digits.Length
            $d = $digits[$index]
        } while ($lastChar -ne $null -and $d -eq $lastChar) # No duplicate digits next to each other

        $chars.Add($d)
        $lastChar = $d
    }

    return -join $chars
}

$lastPassword = $null
$passwords    = @()

for ($i = 0; $i -lt $Count; $i++) {
    $word1 = New-PseudoWord -StartWithVowel:$false
    $word2 = New-PseudoWord -StartWithVowel:$true
    $sep   = $separators[(Get-SecureIndex -MaxValue $separators.Length)]
    $nums  = New-Digits -Length 3

    $pwd = "$word1$sep$word2$nums"
    $lastPassword = $pwd
    $passwords += $pwd   # <<--- NEU

    # optional: Comment out the line below if you want the output to be displayed in the console
    #$pwd
}

if ($passwords.Count -gt 0) {
    # overwrites the file, with one password per line
    Set-Content -Path $OutputFile -Value $passwords
}

$Rng.Dispose()
