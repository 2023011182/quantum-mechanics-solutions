param(
  [Parameter(Mandatory = $true)]
  [string]$Chapter,
  [Parameter(Mandatory = $true)]
  [int]$Section
)

$ErrorActionPreference = "Stop"
$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
$BuildDir = Join-Path $Root "build"

& (Join-Path $PSScriptRoot "build.ps1") -Mode section -Chapter $Chapter -Section $Section
if ($LASTEXITCODE -ne 0) {
  exit $LASTEXITCODE
}

function Get-ChapterToken([string]$Chapter) {
  if ($Chapter -match '^\d+$') {
    return "ch{0:D2}" -f [int]$Chapter
  }
  return "app$Chapter"
}

$chapterToken = Get-ChapterToken $Chapter
$wrapper = Join-Path $BuildDir ("_quick/sec-$chapterToken-{0:D2}.tex" -f $Section)
$jobName = "sec-$chapterToken-{0:D2}" -f $Section

Push-Location $Root
try {
  & latexmk -pvc -xelatex -interaction=nonstopmode -halt-on-error -file-line-error -synctex=1 "-outdir=$BuildDir" "-jobname=$jobName" $wrapper
}
finally {
  Pop-Location
}
