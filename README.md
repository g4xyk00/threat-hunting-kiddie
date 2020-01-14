*Threat Hunting Kiddie* compile the techniques and Indicator of Compromise (IoC) to perform the Compromise Assessment and Threat Hunting. 

# Indicators of Compromise

* File hash
* File path
* Domain name / URL
* IP address



# EndPoint
##  Log Analysis
Apache
```bash
cat access.log | grep "<apache_keyword>"
tail -n 1 access.log 
less access.log
```
## Webshell
PHP
```bash
find . -type f -name "*.php" | xargs egrep -i "(fsockopen|pfsockopen|exec|shell|eval|rot13|base64|passthru|system)"
```
## File System Integrity
Apache
```bash
for f in $(ls); do echo $(md5sum $f); done > baseline.txt
diff baseline.txt compare.txt
```
## Web Directory Integrity
Apache
```bash
cd /var/www/html && find . -mtime -1
```
## Windows Event Log

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
> data.len > 63 and icmp

DNS
> dns.qry.name.len > 15 and !mdns

# Mail Server
## Outlook 365


# Reporting

* Executive Summary
* Analysis and Predictions
* Effects and Observability
* Timeline
* Source
