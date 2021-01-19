--- 
wordpress_id: 72
title: IPM_SUBTREE Outlook and the vanishing emails
date: 2008-07-04 10:07:52 +01:00
tags: 
- outlook
- windows
- exchnage
- ipm_subtree
tags: 
- windows
wordpress_url: https://blog.oneiroi.co.uk/windows/ipm_subtree-outlook-and-the-vanishing-emails
---
Outlook is one of those programs we all love to hate at some point in time, particularly when it does something completely random like say _lose_ that selection of emails you were trying to move to another folder, if you can find these emails i.e. one was flagged and showing up under "flagged for follow up", the "in folder" field displays IPM_SUBTREE.

Let’s start with some _conceptual_ background (In that this is how I logically see this working due to the errors that have occurred).

Your exchange mailbox is effectively a database, however in the more traditional sense of a "Containers" model.

i.e.

Grandparent &gt; Parent &gt; Child is a standard logical representation of programmatic relationships, in this case however it is more relevant to think of the structure as if it were a file system, with folders (containers).

i.e.

C:\Grand_Parent\Parent\Child

Ok so that's the "container" concept out of the way, now for the moving procedure, from what I can tell all mail is stored within the IPM_SUBTREE, this essentially is the CHILD object which contains a subset of further folders, inbox etc ... (Grandchildren)

When copying / moving email to a folder in outlook (Grandchild object), the email is first copied / moved to the IPM_SUBTREE (Child) folder, if an error occurs for any reason however that is where it stays!

The IPM_SUBTREE and higher up folders / containers are not visible in outlook, so to the end user these emails are lost.

To the sys admin however you now know they are simply "misplaced", to recover these you need a program that can see the IPM_SUBTREE, this is available from <a href="https://support.microsoft.com/?kbid=887724">https://support.microsoft.com/?kbid=887724</a> "MFCMAPI_BIN.exe"

You will need to run this from the computer that is having problems, the user will also most likely need local administrative rights on that machine, alternatively as a Domain Administrator, set yourself with full rights to the problem mail box, and create a new outlook profile.

After downloading the .exe you will be prompted to extract the program, i.e. to C:\MFCMAPI, now run it:

C:\MFCMAPI\MFCMapi.exe

Once started Click Session &gt; "Logon and Display Store Tables"

You will them be prompted for a profile to use (Default: Outlook)

The top line in the Display Name field should read: "MailBox - Username", click to select this line and right click to bring up the context menu, now click "Open Store"

You will be presented with a new window, on the left there will be a tree navigation displaying "Root - Mailbox", expand this list and click on IPM_SUBTREE, right click and select "Open Contents Table", again you will get a new window, ideally with nothing listed, if items are listed, select them and right click copy messages.

Now close the window, right click the destination folder i.e. inbox, and "Open Contents Table", in the new window right click anywhere in the list and select "Paste Messages", you may also be prompted to choose whether to move or copy the messages.

Follow the prompts and once complete the messages will be in the destination folder.

Any problems leave a comment.
