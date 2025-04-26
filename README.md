# Windows 11 Compatibility Check Script
This PowerShell script is designed to check if your device meets the hardware requirements for upgrading to Windows 11. It is inspired by Microsoft's [HardwareReadiness.ps1 script](https://techcommunity.microsoft.com/blog/microsoftintuneblog/understanding-readiness-for-windows-11-with-microsoft-endpoint-manager/2770866) and integrates similar checks for various hardware components.

## Features:
- Checks essential hardware components: Processor, Memory, Storage, Graphics, Secure Boot, TPM, and OS Version.
- Provides a user-friendly text output with colorized results (PASS/FAIL).
- Outputs a compact JSON format for easy integration into Active Directory or other systems.
- Inspired by Microsoft's [Windows 11 Requirements](https://learn.microsoft.com/en-us/windows/whats-new/windows-11-requirements#hardware-requirements).

## Hardware Requirements for Windows 11 Upgrade:
To install or upgrade to Windows 11, devices must meet the following minimum hardware requirements:
- Processor: 1 gigahertz (GHz) or faster with two or more cores on a compatible 64-bit processor or system on a chip (SoC).
- Memory: 4 gigabytes (GB) or greater.
- Storage: 64 GB or greater available disk space.
- Graphics card: Compatible with DirectX 12 or later, with a WDDM 2.0 driver.
- System firmware: UEFI, Secure Boot capable.
- TPM: Trusted Platform Module (TPM) version 2.0.
- Display: High definition (720p) display, 9" or greater monitor, 8 bits per color channel.
- Internet connection: Required for updates, downloads, and some features.

## Script Components:

### 1. Processor Check
- Verifies if the CPU is 1 GHz or faster with at least 2 cores.

### 2. Memory Check
- Ensures that the system has 4 GB or more of RAM.

### 3. Storage Check
- Checks if the system has at least 64 GB of free storage.

### 4. Graphics Check
- Verifies that the system has a compatible graphics card.

### 5. Secure Boot Check
- Confirms if UEFI Secure Boot is enabled.

### 6. TPM Check
- Ensures TPM 2.0 is available and enabled.

### 7. OS Version Check
- Verifies if the current OS is Windows 10 version 2004 or later.


## Example Output:
Text Output:
```plaintext
Checking Windows 11 Upgrade Compatibility...
---------------------------------------------
Processor: PASS (3.6 GHz, 4 Cores)
Memory: PASS (23.94 GB)
Storage: FAIL (1.65 GB free)
Graphics: PASS (NVIDIA GeForce GT 1030)
Secure Boot: FAIL (UEFI/Secure Boot not enabled)
TPM: FAIL (Not Found or Not 2.0)
OS Version: PASS (Windows 10 10.0.19045 Build 19045)
---------------------------------------------
Overall Status: NOT COMPATIBLE
```
JSON Output:
```json
{
    "returnCode": 1,
    "returnReason": "Processor, Storage, Secure Boot, TPM, ",
    "logging": "Storage: FreeSpace=1.65GB. FAIL; Memory: 23.94GB. PASS; TPM: Not Found or Not 2.0. FAIL; Processor: {AddressWidth=64; MaxClockSpeed=3600; NumberOfLogicalCores=4; Manufacturer=GenuineIntel; Caption=Intel64 Family 6 Model 158 Stepping 10; }. PASS; SecureBoot: NotEnabled. FAIL; OSVersion: Windows 10 10.0.19045 Build 19045. PASS; Graphics: NVIDIA GeForce GT 1030. PASS;",
    "returnResult": "NOT CAPABLE"
}
```
## How to Run the Script:
1. Download the script to your local machine.
2. Open PowerShell as Administrator.
3. Run the script by executing the following command:

```powershell
.\Windows11CompatibilityCheck.ps1
```
4. Review the results in the PowerShell output or integrate the JSON output with your systems.

## Additional Resources:
[Windows 11 Requirements - Microsoft Documentation](https://learn.microsoft.com/en-us/windows/whats-new/windows-11-requirements#hardware-requirements)
