# Advanced Subdomain Security Scanner (Metasploit Module)

## 📌 Description
This Metasploit auxiliary module scans all subdomains of a given domain for:
- 🔍 Open ports using **Nmap**
- 🛡️ Vulnerabilities using **Nuclei**
- ☁️ Azure tenant information

The results are saved to a file of your choice! 🚀

---

## 🎯 Features
✅ **Automatic Subdomain Discovery** (via `subfinder`)

✅ **Full Port Scanning** (via `nmap`)

✅ **Comprehensive Vulnerability Scanning** (via `nuclei`)

✅ **Azure Tenant ID Detection**

✅ **Custom Output File for Results**

---

## 🛠️ Installation & Requirements
Make sure you have the following tools installed:
```bash
sudo apt install nmap
GO111MODULE=on go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
GO111MODULE=on go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
```

Then, move the script into your **Metasploit modules directory**:
```bash
cp subdomain_scanner.rb ~/.msf4/modules/auxiliary/
```

---

## 🚀 Usage
Run the Metasploit console:
```bash
msfconsole
```
Then, load the module:
```bash
use auxiliary/subdomain_scanner
```
Set the target domain:
```bash
set DOMAIN example.com
```
(Optional) Set a custom output file:
```bash
set OUTPUT_FILE example_scan.txt
```
Run the scan:
```bash
run
```

---

## 📂 Example Output (Colored Bash Preview)
```bash
[*] Finding subdomains...
[+] Subdomain found: api.example.com
[+] Subdomain found: mail.example.com

[*] Scanning open ports on api.example.com...
[+] Open Port: 443 (HTTPS)

[*] Running Nuclei scan on mail.example.com...
[+] Vulnerability found: Missing SPF Record

[*] Checking Azure Tenant ID for example.com...
[+] Azure Tenant ID: 3fd44b08-37d0-423b-9bbf-a01df935edc1

[✔] Scan complete! Results saved to example_scan.txt
```

---

## 📜 Author
**HAMZA EL-HAMDAOUI**.


