# 🔥 GIT-OSINT-DUMPER

<div align="center">

**Professional Git Intelligence & Extraction Tool**

[![Version](https://img.shields.io/badge/version-1.0-blue)](https://github.com/hex-3030/GIT_OSINT_DUMPER)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Bash](https://img.shields.io/badge/bash-5.0+-yellow)](https://www.gnu.org/software/bash/)
[![Git](https://img.shields.io/badge/git-2.0+-orange)](https://git-scm.com/)

**Created by: HEX (@hex-3030)**

**Extracts EVERYTHING from any git repository - Flags, Emails, API Keys, Passwords, Hashes, IPs, Domains & More!**

</div>

---

## 📌 Features

### 🔍 What It Extracts:

| Category | What It Finds |
|----------|---------------|
| 🏴 **Flags** | THM, FLAG, CTF, SECUR, HACK, CHALLENGE, TRYHACKME |
| 📧 **Emails** | All emails from commits and files |
| 👤 **Names** | Real names from commit history |
| 🔑 **API Keys** | GitHub, AWS, Google, Stripe, Slack |
| 🔑 **JWT Tokens** | JSON Web Tokens |
| 🔑 **SSH Keys** | SSH public/private keys |
| 🔐 **Passwords** | Passwords, secrets, tokens, credentials |
| 🔐 **Hashes** | MD5, SHA1, SHA256, SHA512 |
| 🔐 **Base64** | Encoded data |
| 🌐 **IPs** | IP addresses |
| 📱 **Phones** | Phone numbers |
| 🌐 **URLs** | All URLs |
| 🌍 **Domains** | All domains |
| 🗑️ **Deleted** | Deleted files |
| 💬 **Comments** | Code comments |
| 📁 **Files** | All files list |
| 🌿 **Branches** | All branches |
| 🏷️ **Tags** | All tags |
| 👥 **Contributors** | All contributors |
| 📝 **Commits** | All commits with details |

---

## 🚀 Installation

### Quick Install

```bash
git clone https://github.com/hex-3030/GIT_OSINT_DUMPER.git
cd GIT_OSINT_DUMPER
chmod +x gitosint.sh
```
---
## 📖 Usage

# Scan current directory (must be a git repo)
```./gitosint.sh```

# Scan a specific directory
```./gitosint.sh -d /path/to/repo```

# Clone and scan a GitHub repository
```./gitosint.sh -u https://github.com/user/repo.git```

# Custom output name
```./gitosint.sh -o my_scan_results```
---
### 🛠️ Requirements
Bash 5.0+

Git 2.0+

curl (for cloning via URL)

grep (for pattern matching)

sed (for text processing)

All of these are usually pre-installed on Kali Linux, Parrot OS, and most Linux distributions.
---


## 🧑‍💻 Author

- **GitHub:** [hex-3030](https://github.com/hex-3030)
- **TryHackMe:** [HEXD](https://tryhackme.com/p/HEXD)




### ⚠️ Disclaimer
This tool is for educational and security research purposes only.

Only use on repositories you own or have permission to scan

Do not use for malicious purposes

Respect privacy and data protection laws

Use responsibly
---
<p align="center">
  ⭐ If you find this project useful, please consider giving it a Star! ⭐
</p>
