*Threat Hunting Kiddie* compile the techniques and Indicator of Compromise (IoC) to perform the Compromise Assessment and Threat Hunting. 

- - - -
# Advanced Persistent Threat (APT)
## Stages
1. Intelligence Gathering 
   - [Credentials Stolen from Third party vendor](https://krebsonsecurity.com/2014/02/target-hackers-broke-in-via-hvac-company/)
2. Point of Entry 
3. Comand-and-Control (C2) Communication 
4. Lateral Movement 
5. Asset/Data Discovery 
6. Data Exfiltration
   - Backdoors
   - File transfer protocol (FTP)
   - Web applications
   - Windows Management Instrumentation (WMI)
   - Forwarding Rules
   - Peripheral devices (E.g. Microphones and webcams)

- - - -
# Indicators of Compromise (IoC)
* File name
* File hash
* File path
* Domain name / URL
* IP address
* Port
* Strings
* Registry: KeyPath, ValueName, Value
* Process handle name
* Email Subject
* Email Sender

- - - -

# Endpoint - Linux

## Strings
### Linux
```bash
strings <executable_file>
```

## Account Analysis
### Account Usage

```bash
cat /etc/passwd

cut -d: -f1,3 /etc/passwd | grep ":0"  ## Admin priv accounts
cat /etc/sudoers ## Admin priv accounts

last -f /var/log/wtmp ## User Login History
strings /var/log/auth.log
```

## File System Analysis
```bash
find / -name ".*" -ls  ##List all hidden file
cd /var/www/html && find . -mtime -1  ## Recently modified file
```

### File System Integrity
```bash
for f in $(ls); do echo $(md5sum $f); done > baseline.txt
diff baseline.txt compare.txt
```

### Webshell
**PHP**
```bash
find . -type f -name "*.php" | xargs egrep -i "(fsockopen|pfsockopen|exec|shell|eval|rot13|base64|passthru|system)"
```

## Process Analysis

```bash
history  #Command History
strings /var/log/auth.log | grep sudo  #Sudo commands history
```

##  Log Analysis

**Apache**
```bash
cat access.log | grep "<apache_keyword>"
tail -n 1 access.log 
less access.log

- - - -

# Endpoint - Windows 

## File System Analysis

```bash
dir /ah ## List hidden file
forfiles /P C:\xampp\htdocs /S /D +01/06/2020 ## File modified after 6-Jan-2020
```

## Log 
```
/var/log
```

## Process Analysis
### Scheduled Tasks
Linux
```
cat /etc/crontab
```

### File System Integrity
**Windows**
```bash
certutil -hashfile <file_path> SHA256
```

**File Checksum Integrity Verifier (FCIV)**
```bash
fciv.exe -r "<PATH>" -xml results.xml
fciv.exe -r "<PATH>" -v -xml results.xml
```

### Webshell
**PHP**

```bash
findstr /S /I "fsockopen pfsockopen exec shell eval rot13 base64 passthru system" C:\xampp\htdocs\*.php
```

## Windows Registry
Key | Location |  
------------ | ------------- |
Most Recently Used (MRU) | HKEY_CURRENT_USER\software\microsoft\windows\currentversion\Explorer\RunMRU |
USB Devices | HKEY_LOCAL_MACHINE\SYSTEM\controlset001\Enum\USBSTOR |
Internet Explorer | HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\TypedURLs | 
Mounted Devices | HKEY_LOCAL_MACHINE\SYSTEM\MountedDevices
Software Installed | HKEY_CURRENT_USER\Software\
Program Execution | HKEY_CURRENT_USER\SOFTWARE\Microsoft\Currentversion\Search\RecentApps


##  Log Analysis

### Windows Event Log

Commands | Event ID |  Malicious Action
------------ | ------------- | -------------
`msf5 exploit(windows/smb/ms17_010_psexec) > expoit` | 4624 | A user logged on with NULL SID and 0 Keylength from network (Type 3)
` ` | 4625 |  Bruteforce or unauthenticated login attempts
` ` | 4672 | User logon with high priviliges
`net user <UserName> <Password> /add` | 4720 | A user account was created
` ` | 4724 | An attempt was made to reset an account's password
`net localgroup Administrators <Name> /add` | 4728 | A user was assigned with Administrator rights 
` ` | 4768 | Valid user (Check Account and Network Information) request Ticket-granting Ticket (TGT)
` ` | 4769 | Malicious user (Check Account and Network Information) use TGT to access computer service 
` ` | 4770 | Malicious user (Check Account and Network Information) renew TGT 


- - - -
# Network
## Wireshark

Wireshark > Statistics > Conversations > TCP

Wireshark > Statistics > Protocol Hierarchy

### Tunneling
> tcp contains <apache_keyword>

## Tunneling
SSH
> tcp contains SSH-2

ICMP
> data.len > 1 and icmp

DNS
> dns.qry.name.len > 15 and !mdns


- - - -
# Mail Server
## Outlook 365


- - - -
# Reporting

* Executive Summary
* Analysis and Predictions
* Effects and Observability
* Timeline
* Source

- - - -
# Further Study
* [Fortinet Threat Research](https://www.fortinet.com/blog/threat-research.html)

