$md = Get-Content -Path "$PSScriptRoot\apocalipse.md" -Encoding UTF8 -Raw
$html = @'
<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>O Cordeiro Venceu — Apocalipse</title>
<style>
@import url('https://fonts.googleapis.com/css2?family=Merriweather:wght@300;400;700;900&family=Open+Sans:wght@400;600;700&display=swap');
* { margin: 0; padding: 0; box-sizing: border-box; }
body { font-family: 'Merriweather', Georgia, serif; background: #1a1a1a; color: #2c2c2c; line-height: 1.8; }
.container { max-width: 800px; margin: 0 auto; background: #faf8f5; box-shadow: 0 0 40px rgba(0,0,0,0.5); }
.cover { position: relative; min-height: 100vh; display: flex; align-items: center; justify-content: center; text-align: center; overflow: hidden; color: #fff; }
.cover-bg { position: absolute; top: 0; left: 0; width: 100%; height: 100%; object-fit: cover; z-index: 0; }
.cover-overlay { position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: linear-gradient(180deg, rgba(0,0,0,0.6) 0%, rgba(0,0,0,0.4) 50%, rgba(0,0,0,0.7) 100%); z-index: 1; }
.cover-content { position: relative; z-index: 2; padding: 40px 30px; max-width: 700px; }
.cover h1 { font-size: 3.2em; font-weight: 900; margin-bottom: 15px; text-shadow: 2px 4px 20px rgba(0,0,0,0.5); line-height: 1.2; }
.cover .subtitle { font-size: 1.3em; font-weight: 300; font-family: 'Open Sans', sans-serif; text-shadow: 1px 2px 10px rgba(0,0,0,0.4); margin-bottom: 10px; }
.cover .meta { margin-top: 30px; font-size: 0.9em; opacity: 0.8; font-family: 'Open Sans', sans-serif; letter-spacing: 2px; text-transform: uppercase; }
.cover-divider { width: 80px; height: 3px; background: #fff; margin: 20px auto; }
.content { padding: 40px 50px 60px; }
h2 { font-size: 1.8em; font-weight: 900; color: #1a3c34; margin: 40px 0 20px; padding-bottom: 10px; border-bottom: 3px solid #2d6a4f; }
h3 { font-size: 1.3em; font-weight: 700; color: #2d6a4f; margin: 25px 0 15px; }
p { margin-bottom: 15px; text-align: justify; }
.img-container { margin: 25px 0; text-align: center; }
.img-container img { max-width: 100%; height: auto; border-radius: 8px; box-shadow: 0 4px 20px rgba(0,0,0,0.15); }
.img-container .caption { margin-top: 8px; font-size: 0.85em; color: #666; font-family: 'Open Sans', sans-serif; font-style: italic; }
blockquote { margin: 20px 0; padding: 15px 20px; background: #e8f5e9; border-left: 4px solid #2d6a4f; border-radius: 0 6px 6px 0; font-style: italic; color: #1a3c34; }
ul, ol { margin: 10px 0 15px 25px; }
li { margin-bottom: 6px; }
.footer { text-align: center; padding: 30px; color: #888; font-size: 0.85em; font-family: 'Open Sans', sans-serif; border-top: 1px solid #e0e0e0; }
</style>
</head>
<body>
<div class="container">
  <div class="cover">
    <img class="cover-bg" src="imagens/capa.jpg" alt="O Cordeiro Venceu - Apocalipse">
    <div class="cover-overlay"></div>
    <div class="cover-content">
      <h1>O Cordeiro Venceu</h1>
      <div class="cover-divider"></div>
      <p class="subtitle">Apocalipse — Estudo Bíblico</p>
      <p class="meta">Novo Testamento</p>
    </div>
  </div>
  <div class="content">
'@

# Convert MD body to HTML
$lines = $md -split "`n"
$inOl = $false
$inUl = $false
$addedIndex = $false

foreach ($line in $lines) {
    # Skip title (already in cover) and index section
    if ($line -match "^# ") { continue }
    if ($line -match "^## Índice") { $addedIndex = $true; continue }
    if ($addedIndex -and $line -match "^\d+\.") { continue }
    if ($addedIndex -and $line -match "^$") { $addedIndex = $false; continue }
    
    # Convert images
    if ($line -match '^!\[(.+)\]\((.+)\)') {
        $alt = $matches[1]; $src = $matches[2]
        $html += "    <div class=`"img-container`"><img src=`"$src`" alt=`"$alt`"><div class=`"caption`">$alt</div></div>`n"
        continue
    }
    
    # Convert headings
    if ($line -match "^## (.+)") {
        $html += "    <h2>$($matches[1])</h2>`n"
        continue
    }
    if ($line -match "^### (.+)") {
        $html += "    <h3>$($matches[1])</h3>`n"
        continue
    }
    
    # Convert separators
    if ($line -match "^---") {
        $html += "    <hr class=`"divider`">`n"
        continue
    }
    
    # Empty line
    if ($line -match "^$") { continue }
    
    # Paragraph
    if ($line -match "^\S") {
        # Handle bold
        $p = $line -replace '\*\*(.+?)\*\*', '<strong>$1</strong>'
        $p = $p -replace '\*(.+?)\*', '<em>$1</em>'
        $html += "    <p>$p</p>`n"
    }
}

$html += @'
  </div>
  <div class="footer">O Cordeiro Venceu — Apocalipse &bull; Estudo Bíblico</div>
</div>
</body>
</html>
'@

[System.IO.File]::WriteAllText("$PSScriptRoot\apocalipse.html", $html, [System.Text.Encoding]::UTF8)
Write-Output "Apocalipse HTML regenerado com sucesso!"
