---
date: "2008-07-04T10:16:32Z"
tags:
- windows
title: Exchange 2007 Legacy Mailboxes
wordpress_id: 73
wordpress_url: https://blog.oneiroi.co.uk/windows/exchange-2007-legacy-mailboxes
---
This one comes via <a href="https://www.absolutech.co.uk/">Kerm</a>.

We have an Exchange 2003 and Exchange 2007 server working side by side, with the 2003 server on the PDC (Primary Domain Controller).

Due to this when creating a new AD account from the PDC, even if you set the mailbox as being on the  2007 server, the mailbox will still show as "Legacy Mailbox", to correct this you will need to launch the Exchange management shell and run the following command line: 

set-mailbox -identity "mbox_alias" -ApplyMandatoryProperties

et voila job done.
