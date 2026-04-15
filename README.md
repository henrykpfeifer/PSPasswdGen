# PSPasswdGen
Password Generator (PS Script)

PowerShell-based password generator. Creates secure, readable passwords and writes them to a text file.

## Output Format

Generated passwords follow a fixed pattern (14 characters):

```
Nebax&Usibe843
Gigiq,Emezu497
Lecuv$Asaqu276
```

**Security features:**

- Consecutive identical characters are avoided
- Easily confused characters are excluded (`1`, `l`, `I`, `o`, `O`, `0`)

## Usage

### Via batch file (recommended)

Run `genpasswds.cmd` – generates 10 passwords into `generated-password.txt` in the same directory.

### Directly via PowerShell

```powershell
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File ".\passwdgen.ps1" -Count 10 -OutputFile ".\generated-password.txt"
```

### Parameters

| Parameter | Description |
|---|---|
| `-Count` | Number of passwords to generate |
| `-OutputFile` | Path to the output file |

## Requirements

- Windows with PowerShell 5.1+

## License

[MIT](LICENSE)
