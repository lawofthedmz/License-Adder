# Azure AD User License Management Script

This PowerShell script is used to manage Azure AD user licenses. It includes functions to add a license to a user and check if a user has a specific license.

## Prerequisites

- AzureAD PowerShell module

## Setup

1. Import the AzureAD module:

```powershell
Import-Module AzureAD
```
2. Connect to Azure AD:

Define the AD group Object ID and License SKUs at the top of the script:

```powershell
$groupObjectId = "<groupObjectId>"
$F3Sku = "<F3Sku>"
$EMSSku = "<EMSSku>"

Replace <groupObjectId>, <F3Sku>, and <EMSSku> with your actual values.
```
Then, call the functions as needed.

Note
This script assumes that you have the necessary permissions to manage Azure AD user licenses.


