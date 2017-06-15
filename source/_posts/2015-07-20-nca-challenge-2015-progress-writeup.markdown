---
layout: post
title: "NCA challenge 2015 progress writeup"
date: 2015-07-20 17:50
comments: true
categories:
- security
- nca
- challenge 
---

*NOTE* I was unable to complete the challenge ahead of the 18th of July deadline due to other commitments, what follows is a write up of my progress in the challenge after ~6hrs total spent.

On watching the video noted 299879 as the evidence id on the bag, this may be relevant later.

# Unzip nca_image.zip

Yields nca_image.bin, let's use binwalk to analyse the file

```
DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
7995373       0x79FFED        Cisco IOS microcode for "l"
95256215      0x5AD7E97       Zip archive data, at least v2.0 to extract, compressed size: 3790080,  uncompressed size: 3799842, name: "e-mail.docx"
99046429      0x5E7541D       End of Zip archive
191886470     0xB6FF486       QEMU QCOW Image
```

On using `binwalk -e` everything except the identified QCOW image is extracted, so using my helper script

```
#!/bin/bash

echo -n "Can haz start offset hex?:"
read start_off
echo -n "Can haz end offset hex?:"
read end_off

start_int=`echo "ibase=16;${start_off}" | bc`
end_int=`echo "ibase=16;${end_off}" | bc`
chunk_int=`echo "${end_int} - ${start_int}" | bc`

echo "It's not safe to go alone, here take this: dd if=/path/to/space/kitteh of=/path/to/space/kitteh_part skip=${start_int} bs=1 count=${chunk_int}"
```

We manually carve the file out

```
file_carve_dd_calc 
Can haz start offset hex?:B6FF486
Can haz end offset hex?:C6ED5F0
It's not safe to go alone, here take this: dd if=/path/to/space/kitteh of=/path/to/space/kitteh_part skip=191886470 bs=1 count=16703850
```


Trying to analyse the QCOW file using

1. guestfish
2. qemu-* tools (even pulled down the latests source and compiled)

Ultimately this appears to be a false identification, opening up the file in `bless` noted many occurences of the `QFI` header associated with a qcow image, and errors such as

```
... not supported by this qemu version: QCOW version 3330981897
... not supported by this qemu version: QCOW version -963985399
```

Variant on the version of qemu being run, means I move onto analysing the rest of the extracted files.

# email.docx

Opening the file (which I did on a `tails` VM to err on the side of caution, citing paranoia over potential for some macros), notes what appears to be a raw email complete with headers.

And an embedded oleObject

So I unzip the .dox file and again use `binwalk` to inspect the file.

```
unzip e-mail.docx
Archive:  e-mail.docx
  inflating: [Content_Types].xml     
  inflating: _rels/.rels             
  inflating: word/_rels/document.xml.rels  
  inflating: word/document.xml       
  inflating: word/footnotes.xml      
  inflating: word/footer3.xml        
  inflating: word/footer2.xml        
  inflating: word/footer1.xml        
  inflating: word/header2.xml        
  inflating: word/header3.xml        
  inflating: word/header1.xml        
  inflating: word/endnotes.xml       
  inflating: word/embeddings/oleObject1.bin  
  inflating: word/theme/theme1.xml   
  inflating: word/media/image1.emf   
  inflating: word/settings.xml       
  inflating: word/fontTable.xml      
  inflating: word/webSettings.xml    
  inflating: docProps/app.xml        
  inflating: docProps/core.xml       
  inflating: word/styles.xml   

binwalk word/embeddings/oleObject1.bin

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
38019         0x9483          Zip encrypted archive data, compressed size: 2391816,  uncompressed size: 2960344, name: "fl46.wav"
2429884       0x2513BC        Zip encrypted archive data, compressed size: 1536,  uncompressed size: 1958, name: "my_key.asc"
2431471       0x2519EF        Zip encrypted archive data, compressed size: 1373482,  uncompressed size: 1373454, name: "usb_key.gpg"
3805313       0x3A1081        End of Zip archive
```

# encrypted zip

binwalk has provided us with information showing this is an encrypted archive containing thress files, so its needed to extract the zip file and break the encryption to get at the files within.

```
 zipinfo T0PS3RET.zip 
Archive:  T0PS3RET.zip
Zip file size: 3767679 bytes, number of entries: 3
warning [T0PS3RET.zip]:  131 extra bytes at beginning or within zipfile
  (attempting to process anyway)
-rw-a--     6.3 fat  2960344 Bx u099 15-Jun-23 11:26 fl46.wav
-rw-a--     6.3 fat     1958 Bx u099 07-Feb-06 15:21 my_key.asc
-rw-a--     6.3 fat  1373454 Bx u099 07-Feb-06 15:19 usb_key.gpg
3 files, 4335756 bytes uncompressed, 3766798 bytes compressed:  13.1%
```

Running strings on the file also notes the following which may be of use later as it indicates the user "JAMIEH"

Z:\CSC-Final-Revision\Final 'e-mail'\T0PS3RET.zip
C:\Users\JAMIEH~1\AppData\Local\Temp\T0PS3RET.zip

Ok let's john this bastard

```
JohnTheRipper/run/zip2john ./T0PS3RET.zip > T0PS3RET.hashes
JohnTheRipper/run/john ./T0PS3RET.hashes --show

T0PS3RET.zip:flower:::::T0PS3RET.zip
```

# wav and gpg files

So now we have three files.

1. fl46.wav - which upon listening to this is clearly DTMF tones followed by a modem handshake
2. my_key.asc - a private GPG key
3. usb_key.gpg - an encrypted GPG payload

I setup John to start brute forcing the gpg key password whilst inspecting the other files; think of it as an efficent workflow we may not need the bruteforce however there's no harm in having it run whilst we continue the investigation

```
JohnTheRipper/run/gpg2john -S my_key.asc > my_key.asc.hashes
```

Listening to the wav file in `vlc` this is clearly DTMF tones and a modem handshake, using `multimon` I can extract the numbers associated with the DTMF tones.

```
multimon-ng -t wav fl46.wav
```

On this first pass there is some odd behaviour occuring, some numbers are being repeated and some appear to be being skipped, opening the wav file in `audacity` reveals the issue.

{% img https://blog.oneiroi.co.uk/images/nca_fl46_wav.png %}

The wave file is stereo meaning there is both a left and right channel, observing the pattern above it's clear this is an 11 didgit telephone number, we "flatten" the file to mono and run it through multimon again

```
multimon-ng -t wav fl46.wav
DTMF: 0
DTMF: 7
DTMF: 4
DTMF: 8
DTMF: 2
DTMF: 3
DTMF: 5
DTMF: 1
DTMF: 2
DTMF: 4
DTMF: 9
DTMF: *

```

Whilst it was not needed it's worth noting that `sox` can be used to convert to a multimon native format

```
sox -t wav fl46-mono.wav -esigned-integer -b16 -r 22050 -t raw fl46-mono.raw
```

Calling the number (via an anonymized service of course) yeilds a very faint voice reading numbers aloud, this is why having the call recording prior to dialing is such an advantage; some post processing to raise the volume and carefull listening yields: 533020565

# usb_key.gpg

The numbers are indeed the gpg key password 

```
gpg -d usb_key.gpg > usb_key.img

You need a passphrase to unlock the secret key for
user: "Black Oleander Top Secret <bl4ck0l34nd3r70p53cr37@devnull.invalid>"
2048-bit RSA key, ID C96C8291, created 2015-06-16

gpg: encrypted with 2048-bit RSA key, ID C96C8291, created 2015-06-16
      "Black Oleander Top Secret <bl4ck0l34nd3r70p53cr37@devnull.invalid>"

usb_key.img 

file -i usb_key.img
usb_key.img: application/x-tar; charset=binary

tar -xvf ./usb_key.img
Formula.docx
Ledger.xlsx
X101D4.docm
Charles.pptm

binwalk usb_key.img 

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             POSIX tar archive, owner user name: "root", owner group name: "root"
```


#Charles.pptm

2 slide presentation
First slide "It is not the strongest of the species that survives, but the more adaptable", background portrait of Charles darwin, oleEmbbeded file "TransferCode.zip.001"
could infer multipart zip

```
As noted before ppt/embeddings/oleObject1.bin

Slightly odd however ...

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
4247          0x1097          Zip archive data, at least v2.0 to extract, compressed size: 977930,  uncompressed size: 1070767, name: "TransferCode.pdf"
```

running binalk -e produxes the .zip and the .pdf file, the .pdf file is unreadable as it is incomplete therefor we know that this zip file is the head of a multipart archive.

Now I have TransferCode.zip.001

#Formula.docx

Embbeded images showing a formula 
TransferCode.zip.002, ok yup looking like multipart zip
Google image search "The Drake Equation" also "The Equation of Life" 2014 film

Found the following strings

C:\Users\Jamie H\AppData\Local\Microsoft\Windows\INetCache\Content.Word\TransferCode.zip.002
C:\Users\JAMIEH~1\AppData\Local\Temp\TransferCode.zip.002


Now I have TransferCode.zip.002

#Ledger.xslx

Account numbers
many 25000 transfers
descriptions may be erroneous, "cabal", "lord" etc.

Binwalk extracted noted something interesting ...

./_Ledger.xlsx.extracted/secret_hash/1902d4bfb197e0b7372fc0ec592edabbce0124845a270e4508f247e1faffecce

strings ./_Ledger.xlsx.extracted/xl/embeddings/oleObject1.bin

C:\Users\Jamie H\Documents\CSCUK-Challenge-1\Stage 2\TransferCode.zip.003
C:\Users\JAMIEH~1\AppData\Local\Temp\TransferCode.zip.003

Now I have TransferCoder.zip.003

#X101D4.docm

noted VBA from strings run,
large binary textx (101 etc ...)
another hash 13790e4b2ed8345dc51b15c833aa02a33171bd839c543819d19b41bd3962943c followed by "keep looking ;-)" 
Used binwalk to extract the files

strings _X101D4.docm.extracted/word/vbaProject.bin

```
 curl https://gist.github.com/anonymous/e13e60e1975bceb04c20 > 0wned.txt
 activate 1337 hack tool
 destroy the world
 mission complete
```

the gist contains file TransferCode.zip.004 in base64encoding: https://gist.githubusercontent.com/anonymous/e13e60e1975bceb04c20/raw/145cad938bd2c4391fc55f5b482625aa86dae776/gistfile1.txt


```python
from base64 import b64decode
data = open('TransferCode.zip.004.raw)
data = data.replace("local file = TransferCode.zip.004\n'Begining of file\n",'')
data = data.replace("\n'End of File","")
raw = b64decode(data)
out = open('TransferCode.zip.004', 'wb')
out.write(data)
out.close()
```

# The end ...

Unfortunatly this is where I must end, I originally did the above work on June 30th 2015 in my evening, and was not able to pick it up again untill autoring this blog post ... past the deadline, the PDF file appears to be the final stage. (Just cat the zip files togetheer and unzip to get the PDF file)

Oh well it was an interesting puzzle at least and a welcomed exercise of skills I do not nearly get to use enough.

