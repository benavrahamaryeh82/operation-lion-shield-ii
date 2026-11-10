# OPERATION LION SHIELD II

## Windows Authentication Detection Lab

Date: November 10, 2026
Environment: Windows 11
Technology: PowerShell and Windows Security Logs
Project: Independent Cybersecurity Training

### OBJECTIVE

Investigate failed Windows authentication events
and develop a reusable detection script.

### REAL EVENT INVESTIGATION

Event ID: 4625
Target Account: LabTestUser
Logon Type: 2 (Interactive)
Status: 0xC000006D
Substatus: 0xC0000064
Source: Local loopback (::1)

Event Time: November 10, 2026, 12:29:29 PM

Interpretation: Substatus 0xC0000064 indicates the specified username was not found.

&#x20; 



Finding:
A controlled authentication attempt against a
nonexistent test account was rejected and logged.

### DETECTION METHODOLOGY

* Collect Event ID 4625 records.
* Extract targeted usernames.
* Filter records to a 24-hour window.
* Group failed attempts by account.
* Flag accounts with five or more failures.
* Export results to CSV.

### TEST RESULTS

Live Test:
LabTestUser - 1 failure - NO ALERT

Simulated Tests:
LabTestUser - 5 failures - REVIEW
OtherLabUser - 4 failures - NO ALERT

### LIMITATIONS

* Detection runs on demand, not continuously.
* Thresholds are educational, not production-tuned.
* No IP-based or host-based correlation.
* Alerts identify activity for review, not attacks.
* Repeated-failure tests used synthetic data.

### CONCLUSION

Successfully demonstrated foundational Windows
security event investigation, PowerShell scripting,
threshold-based detection, and evidence reporting.

This is an independent educational project.
No affiliation with HII Mission Technologies
is implied.

