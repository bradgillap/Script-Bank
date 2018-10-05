# Decline expired, superceeded, remove old computers, cleanup obsolete compress database

Get-WsusServer "contoso" | Invoke-WsusServerCleanup -DeclineExpiredUpdates -DeclineSupersededUpdates -CleanupObsoleteComputers -CleanupObsoleteUpdates -CleanupUnneededContentFiles -CompressUpdates -WhatIf
