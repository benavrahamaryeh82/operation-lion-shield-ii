param(
    [ValidateSet("Simulated","Live")]
    [string]$Mode = "Simulated",
    [int]$Threshold = 5,
    [int]$WindowHours = 24
)

if ($Threshold -lt 1 -or $WindowHours -lt 1) {
    throw "Threshold and WindowHours must be positive."
}

$now = Get-Date
$cutoff = $now.AddHours(-$WindowHours)
$records = @()

if ($Mode -eq "Simulated") {
    foreach ($i in 1..5) {
        $records += [PSCustomObject]@{
            Account = "LabTestUser"
            Time = $now.AddMinutes(-$i)
        }
    }

    foreach ($i in 1..4) {
        $records += [PSCustomObject]@{
            Account = "OtherLabUser"
            Time = $now.AddMinutes(-$i)
        }
    }

    $records += [PSCustomObject]@{
        Account = "OtherLabUser"
        Time = $now.AddDays(-2)
    }
}
else {
    try {
        $events = @(Get-WinEvent -FilterHashtable @{
            LogName = "Security"
            Id = 4625
            StartTime = $cutoff
        } -ErrorAction Stop)
    }
    catch {
        if ($_.FullyQualifiedErrorId -like "*NoMatchingEventsFound*") {
            $events = @()
        }
        else {
            throw
        }
    }

    foreach ($event in $events) {
        $xml = [xml]$event.ToXml()
        $account = ($xml.Event.EventData.Data |
            Where-Object { $_.Name -eq "TargetUserName" } |
            Select-Object -First 1).'#text'

        if ([string]::IsNullOrWhiteSpace($account)) {
            $account = "Unknown"
        }

        $records += [PSCustomObject]@{
            Account = $account
            Time = $event.TimeCreated
        }
    }
}

$results = @(
    $records |
    Where-Object { $_.Time -ge $cutoff -and $_.Time -le $now } |
    Group-Object Account |
    ForEach-Object {
        [PSCustomObject]@{
            Account = $_.Name
            Failures = $_.Count
            Threshold = $Threshold
            Result = if ($_.Count -ge $Threshold) {
                "REVIEW"
            } else {
                "NO ALERT"
            }
            DataType = $Mode
        }
    }
)

if ($results.Count -gt 0) {
    $results | Sort-Object Account | Format-Table -AutoSize

    $filename = "detection-{0}-{1}.csv" -f $Mode.ToLower(), (Get-Date -Format "yyyyMMdd-HHmmss")
    $outputPath = Join-Path $PSScriptRoot $filename

    $results | Export-Csv -Path $outputPath -NoTypeInformation

    Write-Host "Evidence saved: $outputPath"
}
else {
    Write-Host "No matching failed-logon events found."
}
