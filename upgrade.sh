#!/usr/bin/env bash
# ==============================================================
#  ATUALIZANDO O KALI LINUX
#  Uso: ./atualizar_kali.sh
# ==============================================================
 
set -euo pipefail  # Aborta em erro, variável não definida ou pipe quebrado
 
# ── Cores ──────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'
 
# ── Funções auxiliares ─────────────────────────────────────────
info()    { echo -e "${CYAN}[INFO]${RESET}  $*"; }
success() { echo -e "${GREEN}[OK]${RESET}    $*"; }
warn()    { echo -e "${YELLOW}[AVISO]${RESET} $*"; }
error()   { echo -e "${RED}[ERRO]${RESET}  $*" >&2; exit 1; }
 
step() {
    local num=$1 total=$2 msg=$3
    echo ""
    echo -e "${BOLD}${CYAN}━━━ [${num}/${total}] ${msg} ━━━${RESET}"
}
 
# ── Verificações iniciais ──────────────────────────────────────
[[ $EUID -ne 0 ]] && error "Execute como root ou com sudo: sudo $0"
 
command -v apt &>/dev/null || error "apt não encontrado. Este script é para sistemas Debian/Kali."
 
# ── Banner ─────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}${RED}"
echo "  ██╗  ██╗ █████╗ ██╗     ██╗"
echo "  ██║ ██╔╝██╔══██╗██║     ██║"
echo "  █████╔╝ ███████║██║     ██║"
echo "  ██╔═██╗ ██╔══██║██║     ██║"
echo "  ██║  ██╗██║  ██║███████╗██║"
echo "  ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  Updater"
echo -e "${RESET}"
echo -e "${BOLD}  Sistema: $(uname -sr)${RESET}"
echo -e "${BOLD}  Data:    $(date '+%d/%m/%Y %H:%M:%S')${RESET}"
echo ""
 
TOTAL=3
INICIO=$(date +%s)
 
# ── [1/3] Update ───────────────────────────────────────────────
step 1 $TOTAL "Atualizando lista de pacotes (apt update)"
if apt update -y; then
    success "Lista de pacotes atualizada."
else
    error "Falha no apt update."
fi
 
# ── [2/3] Upgrade ──────────────────────────────────────────────
step 2 $TOTAL "Instalando atualizações (apt upgrade)"
if apt upgrade -y; then
    success "Pacotes atualizados."
else
    error "Falha no apt upgrade."
fi
 
# ── [3/3] Autoremove ───────────────────────────────────────────
step 3 $TOTAL "Removendo pacotes desnecessários (apt autoremove)"
if apt autoremove -y; then
    success "Pacotes desnecessários removidos."
else
    warn "apt autoremove retornou um aviso (não crítico)."
fi
 
# ── Resumo ─────────────────────────────────────────────────────
FIM=$(date +%s)
DURACAO=$((FIM - INICIO))
 
echo ""
echo -e "${GREEN}${BOLD}╔══════════════════════════════════════╗"
echo -e "║   ✔  Atualização concluída!          ║"
printf  "║   ⏱  Tempo total: %-18s║\n" "${DURACAO}s"
echo -e "║   💀  Keep Hacking!                  ║"
echo -e "╚══════════════════════════════════════╝${RESET}"
echo ""