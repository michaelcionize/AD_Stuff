# Check if the Active Directory module is loaded
if (-not (Get-Module -Name ActiveDirectory -ErrorAction SilentlyContinue)) {
    Write-Host "Active Directory module not found. Please install the module first."
    exit 1
}

# Get the current user's distinguished name (DN)
$currentUserDN = (Get-ADUser -Identity $env:USERNAME).DistinguishedName

# Get all AD objects where the current user has explicit permissions
$adObjects = Get-ADObject -Filter * -Properties nTSecurityDescriptor |
             Where-Object {($_.nTSecurityDescriptor.Access | Where-Object {$_.IdentityReference -eq $currentUserDN}) -ne $null} |
             Select-Object DistinguishedName, ObjectClass

# Output the results
if ($adObjects) {
    $adObjects | Format-Table -AutoSize
} else {
    Write-Host "No objects found where the current user has explicit permissions."
}
