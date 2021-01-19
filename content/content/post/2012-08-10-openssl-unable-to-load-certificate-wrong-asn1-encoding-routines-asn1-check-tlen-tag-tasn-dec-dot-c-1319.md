---
date: "2012-08-10T00:00:00Z"
tags:
- openssl
- x.509
- pcks7
title: Openssl unable to load certificate wrong asn1 encoding routines:ASN1_CHECK_TLEN::tag:tasn_dec.c:1319
---

If you come across this error

```
unable to load certificate
140735207381436:error:0D0680A8:asn1 encoding routines:ASN1_CHECK_TLEN:wrong tag:tasn_dec.c:1319:
140735207381436:error:0D07803A:asn1 encoding routines:ASN1_ITEM_EX_D2I:nested asn1 error:tasn_dec.c:381:Type=X509_CINF
140735207381436:error:0D08303A:asn1 encoding routines:ASN1_TEMPLATE_NOEXP_D2I:nested asn1 error:tasn_dec.c:751:Field=cert_info, Type=X509
140735207381436:error:0906700D:PEM routines:PEM_ASN1_read_bio:ASN1 lib:pem_oth.c:83:
```

When trying to validate a certificate using openssl, this is because it is in the wrong format, whilst the certificate file visually appears to be in x.509 format, you will find it contains a far longer base64 string than x.509 certificates of the same bit length.

The format in this case is p7b (PCKS #7); to use the certificate witih apache you're going to have to convert this.

`
openssl pkcs7 -print_certs -in certificate.p7b -out certificate.cer
`

Within the resulting .cer file you will file you x.509 certificate bundled with relevant CA certificates, break these out into your relevant .crt and ca.crt files and load as normal into apache.

