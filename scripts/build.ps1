param(
  [ValidateSet("full", "chapter", "section", "clean")]
  [string]$Mode = "full",
  [string]$Chapter,
  [int]$Section
)

$ErrorActionPreference = "Stop"
$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
$BuildDir = Join-Path $Root "build"
$QuickDir = Join-Path $BuildDir "_quick"
$PdfDir = Join-Path $Root "pdf"
$ReleasePdf = Join-Path $PdfDir "quantum-mechanics-solutions.pdf"

function Get-ChapterToken([string]$Chapter) {
  if ($Chapter -match '^\d+$') {
    return "ch{0:D2}" -f [int]$Chapter
  }
  return "app$Chapter"
}

function Invoke-Latexmk([string]$Tex, [string]$JobName, [switch]$Force) {
  foreach ($extension in @("toc", "out")) {
    $scratchFile = Join-Path $BuildDir "$JobName.$extension"
    if (-not (Test-Path $scratchFile)) {
      New-Item -ItemType File -Path $scratchFile | Out-Null
    }
  }

  $args = @(
    "-xelatex",
    "-interaction=nonstopmode",
    "-halt-on-error",
    "-file-line-error",
    "-synctex=1",
    "-outdir=$BuildDir",
    "-jobname=$JobName",
    $Tex
  )
  if ($Force) {
    $args = @("-g") + $args
  }
  Push-Location $Root
  try {
    & latexmk @args
    if ($LASTEXITCODE -ne 0) {
      exit $LASTEXITCODE
    }
  }
  finally {
    Pop-Location
  }
}

function Ensure-BuildSubdirs {
  $sourceChapters = Join-Path $Root "chapters"
  $buildChapters = Join-Path $BuildDir "chapters"
  New-Item -ItemType Directory -Force -Path $buildChapters | Out-Null
  Get-ChildItem -Path $sourceChapters -Directory | ForEach-Object {
    New-Item -ItemType Directory -Force -Path (Join-Path $buildChapters $_.Name) | Out-Null
  }
}

if ($Mode -eq "clean") {
  if (Test-Path $BuildDir) {
    $resolvedRoot = [System.IO.Path]::GetFullPath($Root)
    $resolvedBuild = [System.IO.Path]::GetFullPath((Resolve-Path $BuildDir))
    if (-not $resolvedBuild.StartsWith($resolvedRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
      throw "Refusing to clean a build directory outside the project root: $resolvedBuild"
    }
    Remove-Item -LiteralPath $resolvedBuild -Recurse -Force
  }
  exit 0
}

New-Item -ItemType Directory -Force -Path $BuildDir | Out-Null
New-Item -ItemType Directory -Force -Path $QuickDir | Out-Null
Ensure-BuildSubdirs

if ($Mode -eq "full") {
  Invoke-Latexmk "main.tex" "shankar-solutions"
  New-Item -ItemType Directory -Force -Path $PdfDir | Out-Null
  $builtPdf = Join-Path $BuildDir "shankar-solutions.pdf"
  if (Test-Path $builtPdf) {
    Copy-Item -Path $builtPdf -Destination $ReleasePdf -Force
  }
  exit 0
}

if (-not $Chapter) {
  throw "chapter/section mode needs -Chapter, for example: .\scripts\build.ps1 -Mode chapter -Chapter 7"
}

$chapterToken = Get-ChapterToken $Chapter

if ($Mode -eq "chapter") {
  $target = "chapters/$chapterToken/$chapterToken"
  $wrapper = Join-Path $QuickDir "chapter-$chapterToken.tex"
  $content = @"
\def\includeonlylist{$target}
\input{main.tex}
"@
  Set-Content -Path $wrapper -Value $content -Encoding UTF8
  Invoke-Latexmk $wrapper "shankar-$chapterToken" -Force
  exit 0
}

if ($Section -le 0) {
  throw "section mode needs -Section, for example: .\scripts\build.ps1 -Mode section -Chapter 7 -Section 3"
}

$Rows = Import-Csv -Path (Join-Path $Root "structure/sections.csv") -Encoding UTF8
$row = $Rows | Where-Object { $_.chapter -eq [string]$Chapter -and [int]$_.section -eq $Section } | Select-Object -First 1
if (-not $row) {
  throw "No section found for Chapter=$Chapter, Section=$Section."
}

$chapterTitle = $row.chapter_title
$sectionFile = "chapters/$chapterToken/sec-{0:D2}.tex" -f $Section
$sectionCounterBefore = $Section - 1
$wrapper = Join-Path $QuickDir ("sec-$chapterToken-{0:D2}.tex" -f $Section)

if ($Chapter -match '^\d+$') {
  $chapterCounterBefore = [int]$Chapter - 1
  $chapterSetup = "\setcounter{chapter}{$chapterCounterBefore}`n\chapter{$chapterTitle}"
}
else {
  $chapterSetup = "\appendix`n\setcounter{chapter}{0}`n\chapter{$chapterTitle}"
}

$content = @"
\documentclass[UTF8,openany,zihao=-4]{ctexbook}
\input{preamble/packages}
\input{preamble/metadata}
\input{preamble/macros}
\input{preamble/environments}

\begin{document}
$chapterSetup
\setcounter{section}{$sectionCounterBefore}
\input{$sectionFile}
\end{document}
"@

Set-Content -Path $wrapper -Value $content -Encoding UTF8
$jobName = "sec-$chapterToken-{0:D2}" -f $Section
Invoke-Latexmk $wrapper $jobName -Force
