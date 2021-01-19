--- 
wordpress_id: 4
title: Backup Exec 9.1 a00084ca - The data being read from the media is inconsistent
date: 2008-01-13 15:04:26 +00:00
tags: 
- symantec
- backup exec
- a00084ca
tags: 
- windows
wordpress_url: https://blog.oneiroi.co.uk/windows/backup-exec-91-a00084ca-the-data-being-read-from-the-media-is-inconsistent
---
This error as of late has been driving me nuts!

Whilst I have still to resolve the issue, I can offer advice to those using ntbackup to diagnose this problem on windows 2003 server or SBS (Small Business Server).

First you will need to stop <strong>_ALL_</strong> BackupEXEC services, now try to run a backup to the tape device using ntbackup.

More than likely you will get the following error.

<em>When attempting to run a backup with the Backup Utility for Windows, an error: "The device reported an error on a request to MS_UpdateNtmsOmidInfo. Error reported: 11. There may be a hardware or media problem. Please check the system log for relevant failures" (Figure 1) is displayed.</em>

This is because BackupEXEC 9.1 has not copied a dll to the right location.

Typically this is: %systemroot%\System32\mll_BE.dll

Be sure to check your registry to make sure: \\HKEY_LOCAL_MACHINE\SYSTEM\Currentcontrolset\control\NTMS\OMID\tape\be

Simply copy the dll from <strong>Program Files\VERITAS\Backup Exec\NT\mll_be.dll</strong> (or your relevant installation directory), to %systemroot%\System32\mll_BE.dll.

Reboot and ntbackup should run without error, (If of course you remembered to stop the BackupEXEC services again).

UPDATE:

This was eventually resolved by replacing the faulty scsi controller.
