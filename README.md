# Operation Lion Shield II
## Windows Authentication Monitoring & Threat Detection

An independent cybersecurity lab focused on Windows
Security Event ID 4625 and PowerShell detection logic.

### Objectives
- Investigate failed Windows authentication attempts
- Extract and interpret security event details
- Identify repeated failures by targeted account
- Apply a configurable detection threshold
- Document and validate findings

### Technologies
- Windows 11
- Windows Security Event Logs
- PowerShell
- CSV evidence reporting

### Detection Logic
The script groups failed authentication events by
account and reviews failures within a rolling
24-hour window.

Default threshold: 5 failed attempts.

### Verified Results
Live test:
- LabTestUser: 1 failure - NO ALERT

Synthetic tests:
- LabTestUser: 5 failures - REVIEW
- OtherLabUser: 4 recent failures - NO ALERT
- One older event excluded

### Running the Script
Simulation mode:

    .\LionShield-Detection.ps1 -Mode Simulated

Live Security log analysis:

    .\LionShield-Detection.ps1 -Mode Live

Live mode may require administrator privileges.
Use only on systems you own or are authorized to
investigate.

### Limitations
- On-demand execution, not continuous monitoring
- Educational detection threshold
- No source IP correlation
- Alerts require analyst investigation
- Repeated-failure tests use synthetic data

### Documentation
See Investigation-Report.md for the investigation
methodology, findings, and conclusions.

### Project Disclaimer
Independent educational cybersecurity project.
Not affiliated with HII Mission Technologies.
