# Decline superceeded updates after 30 days.
Invoke-WsusServerCleanup -DeclineSupersededUpdates

# Decline superceeded updates right now
Get-WSUSUpdate -Classification All -Status Any -Approval AnyExceptDeclined `
    | Where-Object { $_.Update.GetRelatedUpdates(([Microsoft.UpdateServices.Administration.UpdateRelationship]::UpdatesThatSupersedeThisUpdate)).Count -gt 0 } `
    | Deny-WsusUpdate
    
# Cleanup database
Invoke-WsusServerCleanup -CleanupObsoleteUpdates -CleanupUnneededContentFiles
