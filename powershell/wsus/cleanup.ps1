# Decline expired, superceeded, remove old computers, cleanup obsolete compress database

Invoke-WsusServerCleanup -DeclineExpiredUpdates -DeclineSupersededUpdates -CleanupObsoleteComputers -CleanupObsoleteUpdates -CleanupUnneededContentFiles -CompressUpdates -WhatIf
