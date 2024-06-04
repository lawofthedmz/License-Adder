# Import AzureAD module
Import-Module AzureAD

# Login to Azure AD
Connect-AzureAD

# Define the AD group Object ID and License SKUs
$groupObjectId = "0331906b-ba32-4ea4-b597-dabaf08abcb6"
$F3Sku = "66b55226-6b4f-492c-910c-a3b7a3c9d993"
$EMSSku = "efccb6f7-5641-4e0e-bd10-b4976e1bf68e"

# Function to check if user has a specific license
function Get-LicenseStatus {
    param (
        [Parameter(Mandatory=$true)][string]$UserId,
        [Parameter(Mandatory=$true)][string]$SkuId
    )
    $user = Get-AzureADUser -ObjectId $UserId
    return $user.AssignedLicenses.SkuId -contains $SkuId
}
# Function to add a license to a user
function Add-License {
    param (
        [Parameter(Mandatory=$true)][string]$UserObjectId,
        [Parameter(Mandatory=$true)][string]$SkuId
    )
    $user = Get-AzureADUser -ObjectId $UserObjectId
    $sku = Get-AzureADSubscribedSku | Where-Object { $_.SkuId -eq $SkuId }
    if ($sku) {
        $assignedLicenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
        $assignedLicenses.AddLicenses = $user.AssignedLicenses + (New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense -Property @{ SkuId = $sku.SkuId })
        Set-AzureADUserLicense -ObjectId $user.ObjectId -AssignedLicenses $assignedLicenses
        Write-Output "License $SkuId added to user $UserObjectId"
    } else {
        Write-Output "License SKU $SkuId not found."
    }
}

# Get users in the group
$groupMembers = Get-AzureADGroupMember -ObjectId $groupObjectId -All $true

# Print the number of users in the group
Write-Output "Number of users in the group: $($groupMembers.Count)"

foreach ($user in $groupMembers) {
    $userEmail = $user.UserPrincipalName
    $hasLicense = Get-LicenseStatus -UserId $user.ObjectId -SkuId $F3Sku
    Write-Output "User $userEmail has F3 license: $hasLicense"
    if (-not $hasLicense) {
        Add-License -UserObjectId $user.ObjectId -SkuId $EMSSku
    }
}
# Disconnect Azure AD session
Disconnect-AzureAD