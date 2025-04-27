#=============================================================================================================================
#
# Script Name:     Windows11UpgradeCheckJSONResult.ps1
# Description:     Checks if the system meets the minimum hardware requirements for upgrading to Windows 11.
#                  Returns a compatibility status with "PASS" or "FAIL" for each hardware component and overall status.
#
# License:         This script is distributed under the MIT License.
#                  It is provided "as-is", without warranty of any kind, either express or implied.
#
# Notes:           This script is a custom implementation inspired by Microsoft’s HardwareReadiness.ps1.
#                  For further details, refer to Microsoft’s Windows 11 hardware requirements documentation:
#                  https://learn.microsoft.com/en-us/windows/whats-new/windows-11-requirements#hardware-requirements
#
#=============================================================================================================================

# Windows 11 Compatibility Check Script with JSON output
$results = @{}
$failures = @()

# Processor Check
$cpu = Get-CimInstance Win32_Processor
$cpuGHz = [math]::Round($cpu.MaxClockSpeed / 1000, 2)
$cpuCores = $cpu.NumberOfLogicalProcessors
$cpuManufacturer = $cpu.Manufacturer
$cpuCaption = $cpu.Caption
$cpuAddressWidth = $cpu.AddressWidth
$cpuClockSpeed = $cpu.MaxClockSpeed

if ($cpuGHz -ge 1 -and $cpuCores -ge 2) {
    $procStatus = "PASS"
} else {
    $procStatus = "FAIL"
    $failures += "Processor"
}
$results["Processor"] = $procStatus

# Memory Check
$ramGB = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
if ($ramGB -ge 4) {
    $memStatus = "PASS"
} else {
    $memStatus = "FAIL"
    $failures += "Memory"
}
$results["Memory"] = $memStatus

# Storage Check
$storage = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
$freeSpaceGB = [math]::Round($storage.FreeSpace / 1GB, 2)
if ($freeSpaceGB -ge 64) {
    $storageStatus = "PASS"
} else {
    $storageStatus = "FAIL"
    $failures += "Storage"
}
$results["Storage"] = $storageStatus

# Graphics Card Check
$gpu = Get-CimInstance Win32_VideoController | Select-Object -First 1
if ($gpu) {
    $gpuName = $gpu.Name
    $gpuStatus = "PASS"
} else {
    $gpuName = "Unknown"
    $gpuStatus = "FAIL"
    $failures += "Graphics"
}
$results["Graphics"] = $gpuStatus

# Secure Boot Check
$secureBoot = Confirm-SecureBootUEFI -ErrorAction SilentlyContinue
if ($secureBoot -eq $true) {
    $secureBootStatus = "PASS"
} else {
    $secureBootStatus = "FAIL"
    $failures += "Secure Boot"
}
$results["SecureBoot"] = $secureBootStatus

# TPM Check
$TPM = Get-WmiObject -Namespace "Root\CIMV2\Security\MicrosoftTpm" -Class Win32_Tpm -ErrorAction SilentlyContinue
if ($TPM -and $TPM.SpecVersion -match "2\.0") {
    $tpmStatus = "PASS"
} else {
    $tpmStatus = "FAIL"
    $failures += "TPM"
}
$results["TPM"] = $tpmStatus

# OS Version Check
$os = Get-CimInstance Win32_OperatingSystem
$osVersion = $os.Version
$osBuild = $os.BuildNumber
if (($osVersion -ge "10.0.19041") -and ($osBuild -ge 19041)) {
    $osStatus = "PASS"
} else {
    $osStatus = "FAIL"
    $failures += "OS"
}
$results["OSVersion"] = $osStatus

# Final Overall Status
if ($failures.Count -eq 0) {
    $overall = "COMPATIBLE"
    $returnCode = 0
    $returnResult = "CAPABLE"
    $returnReason = ""
} else {
    $overall = "NOT COMPATIBLE"
    $returnCode = 1
    $returnResult = "NOT CAPABLE"
    $returnReason = ($failures -join ", ") + ", "
}

# Build Logging string
$logging = @()
$logging += "Storage: FreeSpace=${freeSpaceGB}GB. $($results["Storage"]);"
$logging += " Memory: ${ramGB}GB. $($results["Memory"]);"
$logging += " TPM: " + ($(if ($TPM) { $TPM.SpecVersion } else { "NotFoundOrNot2.0" })) + ". $($results["TPM"]);"
$logging += " Processor: {AddressWidth=$cpuAddressWidth; MaxClockSpeed=$cpuClockSpeed; NumberOfLogicalCores=$cpuCores; Manufacturer=$cpuManufacturer; Caption=$cpuCaption; }. $($results["Processor"]);"
$logging += " SecureBoot: " + ($(if ($secureBoot) { "Enabled" } else { "NotEnabled" })) + ". $($results["SecureBoot"]);"
$logging += " OSVersion: Windows $osVersion $osBuild. $($results["OSVersion"]);"
$logging += " Graphics: $gpuName. $($results["Graphics"]);"

# Create Final JSON
$jsonOutput = @{
    returnCode = $returnCode
    returnReason = $returnReason
    logging = ($logging -join " ")
    returnResult = $returnResult
}

# Output JSON compressed (no extra spaces)
$jsonOutput | ConvertTo-Json -Compress
