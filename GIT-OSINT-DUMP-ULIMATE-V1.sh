#!/bin/bash

# ================================================================
# 🔥 GIT-OSINT-MASTER v3.0 - ULTIMATE EDITION 🔥
# ================================================================
# Professional Git Intelligence & Extraction Tool
# Created by: HEX (@hex-3030)
# GitHub: https://github.com/hex-3030/git-osint-master
# ================================================================
# Extracts EVERYTHING from any git repository:
#   - Flags (THM, FLAG, CTF, SECUR, HACK, CHALLENGE, TRYHACKME)
#   - Emails, Names, API Keys, Passwords, Tokens
#   - JWT Tokens, SSH Keys, Base64, Hashes (MD5, SHA1, SHA256, SHA512)
#   - IP Addresses, Phone Numbers, URLs, Domains
#   - Deleted files, Comments, Commits, Branches, Tags
#   - And ANYTHING else that looks important!
# ================================================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'

clear
echo -e "${PURPLE}${BOLD}"
echo "╔═══════════════════════════════════════════════════════════════════════╗"
echo "║      🔥 GIT-OSINT-MASTER v3.0 - ULTIMATE EDITION 🔥                ║"
echo "║         The Ultimate Git Intelligence & Extraction Tool             ║"
echo "║              Extracts EVERYTHING - Real World Ready                ║"
echo "║                     Created by: HEX (@hex-3030)                    ║"
echo "║                  GitHub: github.com/hex-3030                       ║"
echo "╚═══════════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# ================================================================
# USAGE / HELP
# ================================================================
show_help() {
    echo -e "${GREEN}Usage:${NC}"
    echo -e "  ./gitosint.sh [OPTIONS]"
    echo ""
    echo -e "${GREEN}Options:${NC}"
    echo -e "  -h, --help      Show this help"
    echo -e "  -u, --url URL   Clone and scan a GitHub repository URL"
    echo -e "  -d, --dir DIR   Scan a local directory"
    echo -e "  -o, --output    Custom output directory name"
    echo ""
    echo -e "${GREEN}Examples:${NC}"
    echo -e "  ./gitosint.sh -u https://github.com/user/repo.git"
    echo -e "  ./gitosint.sh -d ./my-repo"
    echo -e "  ./gitosint.sh           # Scan current directory"
    echo -e "  ./gitosint.sh -o my_scan  # Custom output name"
    echo ""
    echo -e "${GREEN}Output:${NC}"
    echo -e "  All results saved in: OSINT_<timestamp>/"
    echo -e "  Complete report: REPORT.md"
    echo -e "  Individual files: FLAGS.txt, EMAILS.txt, APIKEYS.txt, etc."
    echo ""
    echo -e "${CYAN}GitHub: https://github.com/hex-3030/git-osint-master${NC}"
    exit 0
}

# Parse arguments
OUTPUT_NAME=""
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help) show_help ;;
        -u|--url) REPO_URL="$2"; shift 2 ;;
        -d|--dir) TARGET_DIR="$2"; shift 2 ;;
        -o|--output) OUTPUT_NAME="$2"; shift 2 ;;
        *) echo -e "${RED}Unknown option: $1${NC}"; show_help ;;
    esac
done

# ================================================================
# PREPARE TARGET
# ================================================================
WORK_DIR="$(pwd)"
TEMP_DIR=""

if [ -n "$REPO_URL" ]; then
    echo -e "${YELLOW}[+] Cloning repository...${NC}"
    TEMP_DIR=$(mktemp -d)
    git clone --quiet "$REPO_URL" "$TEMP_DIR" 2>/dev/null
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Failed to clone repository${NC}"
        exit 1
    fi
    cd "$TEMP_DIR" || exit 1
    echo -e "${GREEN}✓ Cloned successfully${NC}"
elif [ -n "$TARGET_DIR" ]; then
    if [ ! -d "$TARGET_DIR" ]; then
        echo -e "${RED}❌ Directory not found: $TARGET_DIR${NC}"
        exit 1
    fi
    cd "$TARGET_DIR" || exit 1
    echo -e "${GREEN}[+] Scanning: $TARGET_DIR${NC}"
else
    if [ -d ".git" ]; then
        echo -e "${GREEN}[+] Scanning current git repository${NC}"
    elif [ -d "repos" ]; then
        echo -e "${GREEN}[+] Scanning repos/ directory${NC}"
        cd repos || exit 1
    else
        echo -e "${RED}❌ No git repository found!${NC}"
        echo -e "${YELLOW}Run in a git repo or use -u or -d${NC}"
        exit 1
    fi
fi

# ================================================================
# CREATE OUTPUT
# ================================================================
if [ -n "$OUTPUT_NAME" ]; then
    OUTPUT_DIR="$WORK_DIR/$OUTPUT_NAME"
else
    OUTPUT_DIR="$WORK_DIR/OSINT_$(date +%Y%m%d_%H%M%S)"
fi
mkdir -p "$OUTPUT_DIR"
echo -e "${GREEN}[+] Output: $OUTPUT_DIR${NC}"
echo ""

# ================================================================
# FIND REPOSITORIES
# ================================================================
GIT_REPOS=()
if [ -d ".git" ]; then
    GIT_REPOS+=(".")
fi
for repo in */; do
    if [ -d "$repo/.git" ]; then
        GIT_REPOS+=("${repo%/}")
    fi
done

if [ ${#GIT_REPOS[@]} -eq 0 ]; then
    echo -e "${RED}❌ No git repositories found${NC}"
    exit 1
fi

echo -e "${GREEN}[+] Found ${#GIT_REPOS[@]} repository(s)${NC}"
echo ""

# ================================================================
# ULTIMATE SCAN FUNCTION
# ================================================================
scan_repo() {
    local REPO_PATH="$1"
    local REPO_NAME=$(basename "$REPO_PATH")
    
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}${BOLD}📁 Scanning: $REPO_NAME${NC}"
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    cd "$REPO_PATH" || return
    
    # ================================================================
    # 1. FLAGS
    # ================================================================
    echo -e "${YELLOW}  [1/15] Extracting FLAGS...${NC}"
    FLAG_PATTERNS="(THM|FLAG|CTF|SECUR|HACK|CHALLENGE|TRYHACKME|thm|flag|ctf|secur|hack|challenge|tryhackme)"
    git grep -E -o "$FLAG_PATTERNS\{[a-zA-Z0-9_]+\}" 2>/dev/null >> "$OUTPUT_DIR/FLAGS.txt"
    git log -p --all 2>/dev/null | grep -E -o "$FLAG_PATTERNS\{[a-zA-Z0-9_]+\}" >> "$OUTPUT_DIR/FLAGS.txt"
    grep -r -E -o "$FLAG_PATTERNS\{[a-zA-Z0-9_]+\}" . 2>/dev/null | cut -d: -f2- >> "$OUTPUT_DIR/FLAGS.txt"
    
    # ================================================================
    # 2. EMAILS
    # ================================================================
    echo -e "${YELLOW}  [2/15] Extracting EMAILS...${NC}"
    git log --all --pretty=format:"%ae" 2>/dev/null >> "$OUTPUT_DIR/EMAILS.txt"
    grep -r -E -o "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" . 2>/dev/null | cut -d: -f2- >> "$OUTPUT_DIR/EMAILS.txt"
    
    # ================================================================
    # 3. NAMES
    # ================================================================
    echo -e "${YELLOW}  [3/15] Extracting REAL NAMES...${NC}"
    git log --all --pretty=format:"%an" 2>/dev/null >> "$OUTPUT_DIR/NAMES_raw.txt"
    
    # ================================================================
    # 4. API KEYS
    # ================================================================
    echo -e "${YELLOW}  [4/15] Extracting API KEYS...${NC}"
    API_PATTERNS="sk-[a-zA-Z0-9]{32,}|pk_[a-zA-Z0-9]{32,}|AKIA[0-9A-Z]{16}|gh[pousr]_[A-Za-z0-9]{36}|AIza[0-9A-Za-z\-_]{35}|xox[baprs]-[0-9A-Za-z]{10,48}|sk_live_[0-9a-zA-Z]{24}|ya29\.[0-9A-Za-z\-_]+"
    grep -r -E -o "$API_PATTERNS" . 2>/dev/null | cut -d: -f2- >> "$OUTPUT_DIR/APIKEYS.txt"
    git grep -E -o "$API_PATTERNS" 2>/dev/null >> "$OUTPUT_DIR/APIKEYS.txt"
    
    # ================================================================
    # 5. JWT TOKENS
    # ================================================================
    echo -e "${YELLOW}  [5/15] Extracting JWT TOKENS...${NC}"
    grep -r -E -o "eyJ[A-Za-z0-9\-_=]+\.[A-Za-z0-9\-_=]+\.[A-Za-z0-9\-_=]+" . 2>/dev/null | cut -d: -f2- >> "$OUTPUT_DIR/JWT.txt"
    git grep -E -o "eyJ[A-Za-z0-9\-_=]+\.[A-Za-z0-9\-_=]+\.[A-Za-z0-9\-_=]+" 2>/dev/null >> "$OUTPUT_DIR/JWT.txt"
    
    # ================================================================
    # 6. SSH KEYS
    # ================================================================
    echo -e "${YELLOW}  [6/15] Extracting SSH KEYS...${NC}"
    grep -r -E -o "ssh-rsa AAAAB3NzaC1yc2E[A-Za-z0-9+/=]+" . 2>/dev/null | cut -d: -f2- >> "$OUTPUT_DIR/SSH_KEYS.txt"
    grep -r -E -o "BEGIN (RSA|DSA|EC|OPENSSH) PRIVATE KEY" . 2>/dev/null | cut -d: -f2- >> "$OUTPUT_DIR/SSH_KEYS.txt"
    git grep -E -o "ssh-rsa AAAAB3NzaC1yc2E[A-Za-z0-9+/=]+" 2>/dev/null >> "$OUTPUT_DIR/SSH_KEYS.txt"
    
    # ================================================================
    # 7. PASSWORDS & SECRETS
    # ================================================================
    echo -e "${YELLOW}  [7/15] Extracting PASSWORDS & SECRETS...${NC}"
    SECRET_PATTERNS="(password|passwd|pwd|secret|api_key|apikey|auth_token|access_token|credential|private_key|ssh_key|otp|2fa|verification_code)"
    grep -r -i -E "$SECRET_PATTERNS[[:space:]]*[=:][[:space:]]*[^'\"]+" . 2>/dev/null | cut -d: -f2- >> "$OUTPUT_DIR/PASSWORDS.txt"
    git grep -i -E "$SECRET_PATTERNS[[:space:]]*[=:][[:space:]]*[^'\"]+" 2>/dev/null >> "$OUTPUT_DIR/PASSWORDS.txt"
    
    # ================================================================
    # 8. HASHES
    # ================================================================
    echo -e "${YELLOW}  [8/15] Extracting HASHES...${NC}"
    grep -r -E -o "[0-9a-f]{32}|[0-9a-f]{40}|[0-9a-f]{64}" . 2>/dev/null | cut -d: -f2- >> "$OUTPUT_DIR/HASHES.txt"
    git grep -E -o "[0-9a-f]{32}|[0-9a-f]{40}|[0-9a-f]{64}" 2>/dev/null >> "$OUTPUT_DIR/HASHES.txt"
    
    # ================================================================
    # 9. BASE64
    # ================================================================
    echo -e "${YELLOW}  [9/15] Extracting BASE64...${NC}"
    grep -r -E -o "[A-Za-z0-9+/]{20,}={0,2}" . 2>/dev/null | cut -d: -f2- >> "$OUTPUT_DIR/BASE64.txt"
    git grep -E -o "[A-Za-z0-9+/]{20,}={0,2}" 2>/dev/null >> "$OUTPUT_DIR/BASE64.txt"
    
    # ================================================================
    # 10. IP ADDRESSES
    # ================================================================
    echo -e "${YELLOW}  [10/15] Extracting IP ADDRESSES...${NC}"
    grep -r -E -o "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" . 2>/dev/null | cut -d: -f2- >> "$OUTPUT_DIR/IPS.txt"
    git grep -E -o "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" 2>/dev/null >> "$OUTPUT_DIR/IPS.txt"
    
    # ================================================================
    # 11. PHONE NUMBERS
    # ================================================================
    echo -e "${YELLOW}  [11/15] Extracting PHONE NUMBERS...${NC}"
    grep -r -E -o "\+[0-9]{10,15}|09[0-9]{9}|[0-9]{3}-[0-9]{3}-[0-9]{4}" . 2>/dev/null | cut -d: -f2- >> "$OUTPUT_DIR/PHONES.txt"
    git grep -E -o "\+[0-9]{10,15}|09[0-9]{9}|[0-9]{3}-[0-9]{3}-[0-9]{4}" 2>/dev/null >> "$OUTPUT_DIR/PHONES.txt"
    
    # ================================================================
    # 12. URLS & DOMAINS
    # ================================================================
    echo -e "${YELLOW}  [12/15] Extracting URLS & DOMAINS...${NC}"
    grep -r -E -o "https?://[a-zA-Z0-9./?=&#_-]+" . 2>/dev/null | cut -d: -f2- >> "$OUTPUT_DIR/URLS.txt"
    grep -r -E -o "[a-zA-Z0-9][-a-zA-Z0-9]{0,62}\.[a-zA-Z]{2,}" . 2>/dev/null | cut -d: -f2- >> "$OUTPUT_DIR/DOMAINS.txt"
    git grep -E -o "https?://[a-zA-Z0-9./?=&#_-]+" 2>/dev/null >> "$OUTPUT_DIR/URLS.txt"
    git grep -E -o "[a-zA-Z0-9][-a-zA-Z0-9]{0,62}\.[a-zA-Z]{2,}" 2>/dev/null >> "$OUTPUT_DIR/DOMAINS.txt"
    
    # ================================================================
    # 13. DELETED FILES
    # ================================================================
    echo -e "${YELLOW}  [13/15] Finding DELETED FILES...${NC}"
    git log --diff-filter=D --summary --all 2>/dev/null | grep -E "delete mode|rename" >> "$OUTPUT_DIR/DELETED.txt"
    
    # ================================================================
    # 14. COMMENTS
    # ================================================================
    echo -e "${YELLOW}  [14/15] Extracting COMMENTS...${NC}"
    grep -r -E "^[[:space:]]*(//|#|/\*|<!--|\*)" . 2>/dev/null | cut -d: -f2- >> "$OUTPUT_DIR/COMMENTS.txt"
    
    # ================================================================
    # 15. EXTRA: FILES, BRANCHES, TAGS, COMMITS, CONTRIBUTORS
    # ================================================================
    echo -e "${YELLOW}  [15/15] Extracting METADATA...${NC}"
    git ls-files 2>/dev/null >> "$OUTPUT_DIR/FILES.txt"
    git branch -a 2>/dev/null >> "$OUTPUT_DIR/BRANCHES.txt"
    git tag -l 2>/dev/null >> "$OUTPUT_DIR/TAGS.txt"
    git log --all --pretty=format:"%an|%ae|%ad|%s" --date=short 2>/dev/null >> "$OUTPUT_DIR/COMMITS.txt"
    git log --all --pretty=format:"%an" 2>/dev/null | sort -u >> "$OUTPUT_DIR/CONTRIBUTORS.txt"
    git remote -v 2>/dev/null >> "$OUTPUT_DIR/REMOTES.txt"
    git log --all --oneline 2>/dev/null | wc -l >> "$OUTPUT_DIR/STATS.txt"
    
    cd - > /dev/null || return
    echo ""
}

# ================================================================
# SCAN ALL REPOSITORIES
# ================================================================
for repo in "${GIT_REPOS[@]}"; do
    scan_repo "$repo"
done

# ================================================================
# CLEAN AND ORGANIZE
# ================================================================
echo -e "${CYAN}${BOLD}[+] Organizing results...${NC}"

for file in FLAGS.txt EMAILS.txt APIKEYS.txt JWT.txt SSH_KEYS.txt PASSWORDS.txt HASHES.txt BASE64.txt IPS.txt PHONES.txt URLS.txt DOMAINS.txt DELETED.txt COMMENTS.txt FILES.txt BRANCHES.txt TAGS.txt COMMITS.txt CONTRIBUTORS.txt REMOTES.txt; do
    if [ -f "$OUTPUT_DIR/$file" ]; then
        sort -u "$OUTPUT_DIR/$file" -o "$OUTPUT_DIR/$file" 2>/dev/null
        sed -i '/^$/d' "$OUTPUT_DIR/$file" 2>/dev/null
    fi
done

if [ -f "$OUTPUT_DIR/NAMES_raw.txt" ]; then
    grep -E "^[A-Z][a-z]+ [A-Z][a-z]+$" "$OUTPUT_DIR/NAMES_raw.txt" 2>/dev/null | sort -u > "$OUTPUT_DIR/NAMES.txt"
    rm -f "$OUTPUT_DIR/NAMES_raw.txt"
fi

if [ -f "$OUTPUT_DIR/FLAGS.txt" ]; then
    sed -i '/FLAG_COUNT/d' "$OUTPUT_DIR/FLAGS.txt" 2>/dev/null
    sed -i '/PLACEHOLDER/d' "$OUTPUT_DIR/FLAGS.txt" 2>/dev/null
    sed -i '/^[0-9]/d' "$OUTPUT_DIR/FLAGS.txt" 2>/dev/null
fi

# ================================================================
# COUNTS
# ================================================================
FLAG_COUNT=$(wc -l < "$OUTPUT_DIR/FLAGS.txt" 2>/dev/null | tr -d ' ')
EMAIL_COUNT=$(wc -l < "$OUTPUT_DIR/EMAILS.txt" 2>/dev/null | tr -d ' ')
NAME_COUNT=$(wc -l < "$OUTPUT_DIR/NAMES.txt" 2>/dev/null | tr -d ' ')
API_COUNT=$(wc -l < "$OUTPUT_DIR/APIKEYS.txt" 2>/dev/null | tr -d ' ')
JWT_COUNT=$(wc -l < "$OUTPUT_DIR/JWT.txt" 2>/dev/null | tr -d ' ')
SSH_COUNT=$(wc -l < "$OUTPUT_DIR/SSH_KEYS.txt" 2>/dev/null | tr -d ' ')
PASS_COUNT=$(wc -l < "$OUTPUT_DIR/PASSWORDS.txt" 2>/dev/null | tr -d ' ')
HASH_COUNT=$(wc -l < "$OUTPUT_DIR/HASHES.txt" 2>/dev/null | tr -d ' ')
BASE64_COUNT=$(wc -l < "$OUTPUT_DIR/BASE64.txt" 2>/dev/null | tr -d ' ')
IP_COUNT=$(wc -l < "$OUTPUT_DIR/IPS.txt" 2>/dev/null | tr -d ' ')
PHONE_COUNT=$(wc -l < "$OUTPUT_DIR/PHONES.txt" 2>/dev/null | tr -d ' ')
URL_COUNT=$(wc -l < "$OUTPUT_DIR/URLS.txt" 2>/dev/null | tr -d ' ')
DOMAIN_COUNT=$(wc -l < "$OUTPUT_DIR/DOMAINS.txt" 2>/dev/null | tr -d ' ')
DEL_COUNT=$(wc -l < "$OUTPUT_DIR/DELETED.txt" 2>/dev/null | tr -d ' ')
COMMENT_COUNT=$(wc -l < "$OUTPUT_DIR/COMMENTS.txt" 2>/dev/null | tr -d ' ')
CONTRIB_COUNT=$(wc -l < "$OUTPUT_DIR/CONTRIBUTORS.txt" 2>/dev/null | tr -d ' ')
COMMIT_COUNT=$(head -1 "$OUTPUT_DIR/STATS.txt" 2>/dev/null | tr -d ' ')

# ================================================================
# DISPLAY RESULTS
# ================================================================
echo ""
echo -e "${GREEN}${BOLD}════════════════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}${UNDERLINE}📊 SCAN RESULTS${NC}"
echo -e "${GREEN}${BOLD}════════════════════════════════════════════════════════════════${NC}"

# FLAGS
echo -e "\n${BOLD}🏴 FLAGS FOUND:${NC}"
echo -e "${CYAN}────────────────────────────────────────────────────────${NC}"
if [ -s "$OUTPUT_DIR/FLAGS.txt" ]; then
    cat "$OUTPUT_DIR/FLAGS.txt" | while read flag; do
        if [[ "$flag" == THM* ]] || [[ "$flag" == thm* ]]; then
            echo -e "  ${RED}🔥 THM:${NC} ${BOLD}$flag${NC}"
        elif [[ "$flag" == FLAG* ]] || [[ "$flag" == flag* ]]; then
            echo -e "  ${RED}🏴 FLAG:${NC} ${BOLD}$flag${NC}"
        elif [[ "$flag" == CTF* ]] || [[ "$flag" == ctf* ]]; then
            echo -e "  ${RED}🎯 CTF:${NC} ${BOLD}$flag${NC}"
        else
            echo -e "  ${YELLOW}►${NC} ${BOLD}$flag${NC}"
        fi
    done
    echo ""
    echo -e "${GREEN}Total: $FLAG_COUNT flags${NC}"
else
    echo -e "  ${YELLOW}❌ No flags found${NC}"
fi

# EMAILS
echo -e "\n${BOLD}📧 EMAILS FOUND:${NC}"
echo -e "${CYAN}────────────────────────────────────────────────────────${NC}"
if [ -s "$OUTPUT_DIR/EMAILS.txt" ]; then
    cat "$OUTPUT_DIR/EMAILS.txt" | while read email; do
        echo -e "  ${GREEN}►${NC} $email"
    done
    echo ""
    echo -e "${GREEN}Total: $EMAIL_COUNT emails${NC}"
else
    echo -e "  ${YELLOW}❌ No emails found${NC}"
fi

# SUMMARY
echo -e "\n${GREEN}${BOLD}════════════════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}📊 COMPLETE SUMMARY${NC}"
echo -e "${GREEN}${BOLD}════════════════════════════════════════════════════════════════${NC}"
echo -e "  ${BLUE}🏴 Flags:${NC}        $FLAG_COUNT"
echo -e "  ${BLUE}📧 Emails:${NC}        $EMAIL_COUNT"
echo -e "  ${BLUE}👤 Names:${NC}         $NAME_COUNT"
echo -e "  ${BLUE}🔑 API Keys:${NC}      $API_COUNT"
echo -e "  ${BLUE}🔑 JWT Tokens:${NC}    $JWT_COUNT"
echo -e "  ${BLUE}🔑 SSH Keys:${NC}      $SSH_COUNT"
echo -e "  ${BLUE}🔐 Passwords:${NC}     $PASS_COUNT"
echo -e "  ${BLUE}🔐 Hashes:${NC}        $HASH_COUNT"
echo -e "  ${BLUE}🔐 Base64:${NC}        $BASE64_COUNT"
echo -e "  ${BLUE}🌐 IPs:${NC}           $IP_COUNT"
echo -e "  ${BLUE}📱 Phones:${NC}        $PHONE_COUNT"
echo -e "  ${BLUE}🌐 URLs:${NC}          $URL_COUNT"
echo -e "  ${BLUE}🌍 Domains:${NC}       $DOMAIN_COUNT"
echo -e "  ${BLUE}🗑️ Deleted:${NC}       $DEL_COUNT"
echo -e "  ${BLUE}💬 Comments:${NC}      $COMMENT_COUNT"
echo -e "  ${BLUE}👥 Contributors:${NC}  $CONTRIB_COUNT"
echo -e "  ${BLUE}📝 Commits:${NC}       ${COMMIT_COUNT:-N/A}"

# ================================================================
# SAVE REPORT
# ================================================================
cat > "$OUTPUT_DIR/REPORT.md" << EOF
# 🔥 GIT-OSINT-MASTER v3.0 - COMPLETE REPORT

## 📊 Summary
- **Date:** $(date)
- **Tool:** GIT-OSINT-MASTER v3.0
- **Creator:** HEX (@hex-3030)
- **GitHub:** https://github.com/hex-3030/git-osint-master
- **Repositories Scanned:** ${#GIT_REPOS[@]}
- **Total Commits:** ${COMMIT_COUNT:-N/A}
- **Contributors:** $CONTRIB_COUNT

### Findings
| Category | Count |
|----------|-------|
| 🏴 Flags | $FLAG_COUNT |
| 📧 Emails | $EMAIL_COUNT |
| 👤 Real Names | $NAME_COUNT |
| 🔑 API Keys | $API_COUNT |
| 🔑 JWT Tokens | $JWT_COUNT |
| 🔑 SSH Keys | $SSH_COUNT |
| 🔐 Passwords/Secrets | $PASS_COUNT |
| 🔐 Hashes | $HASH_COUNT |
| 🔐 Base64 Data | $BASE64_COUNT |
| 🌐 IP Addresses | $IP_COUNT |
| 📱 Phone Numbers | $PHONE_COUNT |
| 🌐 URLs | $URL_COUNT |
| 🌍 Domains | $DOMAIN_COUNT |
| 🗑️ Deleted Files | $DEL_COUNT |
| 💬 Comments | $COMMENT_COUNT |

---

## 🏴 FLAGS
$(cat "$OUTPUT_DIR/FLAGS.txt" 2>/dev/null | sed 's/^/- /' || echo "- None")

---

## 📧 EMAILS
$(cat "$OUTPUT_DIR/EMAILS.txt" 2>/dev/null | sed 's/^/- /' || echo "- None")

---

## 👤 REAL NAMES
$(cat "$OUTPUT_DIR/NAMES.txt" 2>/dev/null | sed 's/^/- /' || echo "- None")

---

## 🔑 API KEYS
$(cat "$OUTPUT_DIR/APIKEYS.txt" 2>/dev/null | sed 's/^/- /' || echo "- None")

---

## 🔑 JWT TOKENS
$(cat "$OUTPUT_DIR/JWT.txt" 2>/dev/null | sed 's/^/- /' || echo "- None")

---

## 🔑 SSH KEYS
$(cat "$OUTPUT_DIR/SSH_KEYS.txt" 2>/dev/null | sed 's/^/- /' || echo "- None")

---

## 🔐 PASSWORDS & SECRETS
$(cat "$OUTPUT_DIR/PASSWORDS.txt" 2>/dev/null | sed 's/^/- /' || echo "- None")

---

## 🔐 HASHES
$(cat "$OUTPUT_DIR/HASHES.txt" 2>/dev/null | sed 's/^/- /' || echo "- None")

---

## 🔐 BASE64 DATA
$(cat "$OUTPUT_DIR/BASE64.txt" 2>/dev/null | sed 's/^/- /' || echo "- None")

---

## 🌐 IP ADDRESSES
$(cat "$OUTPUT_DIR/IPS.txt" 2>/dev/null | sed 's/^/- /' || echo "- None")

---

## 📱 PHONE NUMBERS
$(cat "$OUTPUT_DIR/PHONES.txt" 2>/dev/null | sed 's/^/- /' || echo "- None")

---

## 🌐 URLS
$(cat "$OUTPUT_DIR/URLS.txt" 2>/dev/null | sed 's/^/- /' || echo "- None")

---

## 🌍 DOMAINS
$(cat "$OUTPUT_DIR/DOMAINS.txt" 2>/dev/null | sed 's/^/- /' || echo "- None")

---

## 🗑️ DELETED FILES
$(cat "$OUTPUT_DIR/DELETED.txt" 2>/dev/null | sed 's/^/- /' || echo "- None")

---

## 💬 COMMENTS
$(head -20 "$OUTPUT_DIR/COMMENTS.txt" 2>/dev/null | sed 's/^/- /' || echo "- None")

---

## 👥 CONTRIBUTORS
$(cat "$OUTPUT_DIR/CONTRIBUTORS.txt" 2>/dev/null | sed 's/^/- /' || echo "- None")

---

## 📁 ALL FILES
$(cat "$OUTPUT_DIR/FILES.txt" 2>/dev/null | sed 's/^/- /' || echo "- None")

---

## 🌿 BRANCHES
$(cat "$OUTPUT_DIR/BRANCHES.txt" 2>/dev/null | sed 's/^/- /' || echo "- None")

---

## 🏷️ TAGS
$(cat "$OUTPUT_DIR/TAGS.txt" 2>/dev/null | sed 's/^/- /' || echo "- None")

---

## 🔗 REMOTES
$(cat "$OUTPUT_DIR/REMOTES.txt" 2>/dev/null | sed 's/^/- /' || echo "- None")

---

*Generated by GIT-OSINT-MASTER v3.0*
*Created by: HEX (@hex-3030)*
*GitHub: https://github.com/hex-3030/git-osint-master*
*Scan completed at: $(date)*
EOF

# ================================================================
# FINAL
# ================================================================
echo ""
echo -e "${GREEN}${BOLD}════════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}${BOLD}📁 Results saved in: $OUTPUT_DIR/${NC}"
echo -e "${GREEN}${BOLD}════════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}📄 Report:${NC} $OUTPUT_DIR/REPORT.md"
echo -e "${BLUE}🏴 Flags:${NC} $OUTPUT_DIR/FLAGS.txt"
echo -e "${BLUE}📧 Emails:${NC} $OUTPUT_DIR/EMAILS.txt"
echo -e "${BLUE}👤 Names:${NC} $OUTPUT_DIR/NAMES.txt"
echo -e "${BLUE}🔑 API Keys:${NC} $OUTPUT_DIR/APIKEYS.txt"
echo -e "${BLUE}🔑 JWT:${NC} $OUTPUT_DIR/JWT.txt"
echo -e "${BLUE}🔑 SSH:${NC} $OUTPUT_DIR/SSH_KEYS.txt"
echo -e "${BLUE}🔐 Passwords:${NC} $OUTPUT_DIR/PASSWORDS.txt"
echo -e "${BLUE}🔐 Hashes:${NC} $OUTPUT_DIR/HASHES.txt"
echo -e "${BLUE}🔐 Base64:${NC} $OUTPUT_DIR/BASE64.txt"
echo -e "${BLUE}🌐 IPs:${NC} $OUTPUT_DIR/IPS.txt"
echo -e "${BLUE}📱 Phones:${NC} $OUTPUT_DIR/PHONES.txt"
echo -e "${BLUE}🌐 URLs:${NC} $OUTPUT_DIR/URLS.txt"
echo -e "${BLUE}🌍 Domains:${NC} $OUTPUT_DIR/DOMAINS.txt"
echo -e "${BLUE}🗑️ Deleted:${NC} $OUTPUT_DIR/DELETED.txt"
echo -e "${BLUE}💬 Comments:${NC} $OUTPUT_DIR/COMMENTS.txt"
echo -e "${GREEN}${BOLD}════════════════════════════════════════════════════════════════${NC}"

if [ -s "$OUTPUT_DIR/FLAGS.txt" ]; then
    echo ""
    echo -e "${PURPLE}${BOLD}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}${BOLD}🎯 FINAL FLAG:${NC}"
    echo -e "${PURPLE}${BOLD}════════════════════════════════════════════════════════════════${NC}"
    cat "$OUTPUT_DIR/FLAGS.txt" | while read f; do
        echo -e "${RED}${BOLD}    $f${NC}"
    done
    echo -e "${PURPLE}${BOLD}════════════════════════════════════════════════════════════════${NC}"
fi

echo ""
echo -e "${GREEN}✅ DONE!${NC}"
echo -e "${CYAN}📌 GitHub: https://github.com/hex-3030/git-osint-master${NC}"

if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then
    cd "$WORK_DIR" || exit
    rm -rf "$TEMP_DIR"
fi
