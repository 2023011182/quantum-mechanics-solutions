param(
  [switch]$Force
)

$ErrorActionPreference = "Stop"
$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
$CsvPath = Join-Path $Root "structure/sections.csv"
$Rows = Import-Csv -Path $CsvPath -Encoding UTF8

function Get-ChapterToken([string]$Chapter) {
  if ($Chapter -match '^\d+$') {
    return "ch{0:D2}" -f [int]$Chapter
  }
  return "app$Chapter"
}

function Get-SectionFile([string]$Chapter, [int]$Section) {
  $token = Get-ChapterToken $Chapter
  return "chapters/$token/sec-{0:D2}.tex" -f $Section
}

$chapterGroups = $Rows | Group-Object chapter
foreach ($group in $chapterGroups) {
  $chapter = [string]$group.Name
  $token = Get-ChapterToken $chapter
  $chapterDir = Join-Path $Root "chapters/$token"
  New-Item -ItemType Directory -Force -Path $chapterDir | Out-Null

  $chapterTitle = $group.Group[0].chapter_title
  $chapterFile = Join-Path $chapterDir "$token.tex"
  $chapterLines = @(
    "% !TeX root = ../../main.tex",
    "\chapter{$chapterTitle}",
    ""
  )
  foreach ($row in ($group.Group | Sort-Object {[int]$_.section})) {
    $sectionFile = Get-SectionFile $chapter ([int]$row.section)
    $chapterLines += "\input{$sectionFile}"
  }

  if ($Force -or -not (Test-Path $chapterFile)) {
    Set-Content -Path $chapterFile -Value ($chapterLines -join [Environment]::NewLine) -Encoding UTF8
  }

  foreach ($row in $group.Group) {
    $section = [int]$row.section
    $sectionTitle = $row.section_title
    $sectionPath = Join-Path $Root (Get-SectionFile $chapter $section)
    if ($Force -or -not (Test-Path $sectionPath)) {
      $content = @(
        "% !TeX root = ../../main.tex",
        "\section{$sectionTitle}",
        "",
        "% Write this section's exercise solutions here.",
        "% Exercise numbers are reset by section, for example 7.3.1.",
        "% Template:",
        "% \begin{solution}[short title or source exercise number]",
        "% \problem{Paste or summarize the problem here.}",
        "% \answer",
        "% Write the solution here.",
        "% \end{solution}",
        ""
      )
      Set-Content -Path $sectionPath -Value ($content -join [Environment]::NewLine) -Encoding UTF8
    }
  }
}

$backmatterDir = Join-Path $Root "backmatter"
New-Item -ItemType Directory -Force -Path $backmatterDir | Out-Null
