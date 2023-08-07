# Get the current user's distinguished name (DN)
$currentUserDN = (Get-ADUser -Identity $env:USERNAME).DistinguishedName

# Get all AD objects where the current user has explicit permissions
$permissionsObjects = Get-ADPermission -Identity $currentUserDN -User $currentUserDN -ResultPageSize 1000 -AuthType Kerberos -ErrorAction SilentlyContinue |
    Select-Object Identity, ObjectType, InheritedObjectType |
    Sort-Object Identity

# Output the results
if ($permissionsObjects) {
    $permissionsObjects | Format-Table -AutoSize
} else {
    Write-Host "No objects found where the current user has explicit permissions."
}
