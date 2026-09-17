# ===== Aliases =====

function l { Get-ChildItem -Force }
function la { Get-ChildItem -Force -Attributes !Directory }

function grep { Select-String }

function c { clear }

function .. { Set-Location .. }
function ... { Set-Location ../.. }
function .... { Set-Location ../../.. }

# function home { Set-Location $HOME }

#function py { python }
# function pipu { pip install --upgrade pip }
function uv { py -m uv $args }

# Git shortcuts
function gs { git status }
function ga { git add . }
function gc { git commit -m $args }
function gp { git push }
function gl { git log --oneline --graph --decorate -n 20 }

# Open current directory in explorer
function e { explorer . }

# Edit profile quickly
function rc { code $PROFILE }

# Reload profile
function r { . $PROFILE }

# SCP
$ServerIp = "172.24.26.54"
