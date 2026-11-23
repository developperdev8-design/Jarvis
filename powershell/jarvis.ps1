#Requires -Version 5.1
<#
  J A R V I S  -  assistant IA en PowerShell (voix Windows + Gemini)
  Aucune installation : juste Windows + une cle API Gemini (gratuite).
  Lancer :  clic droit sur lancer-jarvis.bat  ->  Executer
       ou :  powershell -ExecutionPolicy Bypass -File jarvis.ps1
#>

try {
  [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
  [Console]::InputEncoding  = [System.Text.Encoding]::UTF8
} catch {}

# -------------------- Configuration (cle API) --------------------
$ConfigPath = Join-Path $PSScriptRoot "jarvis.config.json"
$cfg = $null
if (Test-Path $ConfigPath) {
  try { $cfg = Get-Content $ConfigPath -Raw -Encoding UTF8 | ConvertFrom-Json } catch { $cfg = $null }
}
if (-not $cfg) { $cfg = [pscustomobject]@{ apiKey = ""; model = "gemini-flash-latest" } }
if (-not ($cfg.PSObject.Properties.Name -contains 'model')) {
  $cfg | Add-Member -NotePropertyName model -NotePropertyValue "gemini-flash-latest"
}
if (-not $cfg.apiKey) {
  Write-Host "Cle API Gemini requise - gratuite sur https://aistudio.google.com/api-keys" -ForegroundColor Yellow
  $cfg.apiKey = (Read-Host "Colle ta cle API Gemini").Trim()
  $cfg | ConvertTo-Json | Set-Content $ConfigPath -Encoding UTF8
  Write-Host "Cle enregistree dans jarvis.config.json (gardee en local)." -ForegroundColor DarkGray
}

# -------------------- Voix (synthese Windows) --------------------
Add-Type -AssemblyName System.Speech
$synth = New-Object System.Speech.Synthesis.SpeechSynthesizer
$frVoice = $synth.GetInstalledVoices() |
  Where-Object { $_.Enabled -and $_.VoiceInfo.Culture.Name -like 'fr*' } |
  Select-Object -First 1
if ($frVoice) { $synth.SelectVoice($frVoice.VoiceInfo.Name) }
function Speak([string]$text) {
  if ($text) { [void]$synth.SpeakAsyncCancelAll(); [void]$synth.SpeakAsync($text) }
}

# -------------------- Actions locales (sans IA) --------------------
function Invoke-Local([string]$q) {
  $ql = $q.ToLower()
  if ($ql -match '^(ouvre|lance|demarre|démarre)\s+(.+)$') {
    $name = $Matches[2].Trim(' .!?')
    $map = @{
      'bloc-notes'='notepad'; 'bloc notes'='notepad'; 'notepad'='notepad';
      'calculatrice'='calc'; 'calculette'='calc'; 'chrome'='chrome'; 'edge'='msedge';
      'navigateur'='msedge'; 'explorateur'='explorer'; 'parametres'='ms-settings:';
      'paramètres'='ms-settings:'; 'spotify'='spotify'; 'word'='winword'; 'excel'='excel'
    }
    $cmd = if ($map.ContainsKey($name)) { $map[$name] } else { $name }
    try { Start-Process $cmd -ErrorAction Stop; return "J'ouvre $name." }
    catch { return "Je n'ai pas pu ouvrir $name." }
  }
  if ($ql -match '^(cherche|recherche)\s+(.+)$') {
    $term = $Matches[2].Trim()
    Start-Process ("https://www.google.com/search?q=" + [uri]::EscapeDataString($term))
    return "Je recherche $term sur le web."
  }
  if ($ql -match 'quelle heure|l.?heure est') { return (Get-Date -Format "'Il est 'HH'h'mm'.'") }
  if ($ql -match 'quel jour|quelle date|on est quel') { return (Get-Date -Format "'Nous sommes le 'dddd' 'd' 'MMMM' 'yyyy'.'") }
  return $null
}

# -------------------- Cerveau Gemini --------------------
function Ask-Gemini([string]$q) {
  $sys = "Tu es Jarvis, un assistant personnel en francais, concis et poli. Reponds en 1 a 3 phrases, sans listes, sans markdown, sans URL."
  $payload = @{
    systemInstruction = @{ parts = @(@{ text = $sys }) }
    contents          = @(@{ role = "user"; parts = @(@{ text = $q }) })
    generationConfig  = @{ temperature = 0.6 }
  }
  $json = $payload | ConvertTo-Json -Depth 10 -Compress
  $url  = "https://generativelanguage.googleapis.com/v1beta/models/$($cfg.model):generateContent?key=$($cfg.apiKey)"
  try {
    $resp = Invoke-RestMethod -Uri $url -Method Post -ContentType "application/json; charset=utf-8" `
              -Body ([System.Text.Encoding]::UTF8.GetBytes($json))
    $parts = $resp.candidates[0].content.parts
    $text  = (($parts | ForEach-Object { $_.text }) -join "").Trim()
    if ($text) { return $text } else { return "Desole, je n'ai pas de reponse." }
  } catch {
    $detail = $_.ErrorDetails.Message
    if ($detail) {
      try { return "Probleme : " + (($detail | ConvertFrom-Json).error.message) } catch { return "Probleme : $detail" }
    }
    return "Probleme : $($_.Exception.Message)"
  }
}

# -------------------- Boucle principale --------------------
Write-Host ""
Write-Host "   J A R V I S   -   assistant PowerShell" -ForegroundColor DarkYellow
Write-Host "   Modele : $($cfg.model)    |    tape 'quitter' pour sortir" -ForegroundColor DarkGray
Write-Host ""
Speak("Bonjour, je suis Jarvis. Comment puis-je vous aider ?")

while ($true) {
  $q = Read-Host "Vous"
  if ([string]::IsNullOrWhiteSpace($q)) { continue }
  if ($q.Trim().ToLower() -in @('quitter','quit','exit','stop','au revoir')) {
    Speak("A bientot."); Start-Sleep -Milliseconds 900; break
  }
  $reply = Invoke-Local $q
  if (-not $reply) { $reply = Ask-Gemini $q }
  Write-Host "Jarvis > $reply" -ForegroundColor Yellow
  Write-Host ""
  Speak($reply)
}
