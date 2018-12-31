
# How to setup your own CA for dev environment

Questo script genera la tua personale CA e un certificato wildcard firmato per il tuo server.
This way you can avoid receiving an error for the self-signed certificate.

# Usage

```
$ ./ca-server-gen.sh -rsa BYTES -caname CA_NAME -cadays CA_VALIDITY -dns SERVER_DOMAIN -days SERVER_VALIDITY
```
-rsa		n of BYTES for RSA
-caname		name of your own CA
-cadays		validity of CA
-dns		server dns (Es. somedomain.com)
-days		validity of server certificate

## How it works

```
$./ca-server-gen.sh -rsa 4096 -caname FakeAuthority -cadays 3650 -dns fakedomain.com -days 700
Value for RSA: 4096
Value for Authority's name: FakeAuthority
Value for CA validity: 3650 days
Value for Server Domain Name: fakedomain.com
Value for Server Cert validity: 700 days
Are you sure? [y/N] y
YES
```
Confirm values.

```

-----
Generating RSA private key, 4096 bit long modulus
....................................................................................................++
.++
e is 65537 (0x010001)
-----

Writing new private key Authority to 'FakeAuthority-private.key'
Writing new certificate Authority to 'FakeAuthority-cecrt.crt'

-----
Generating RSA private key, 4096 bit long modulus
.........................................................................................................++
.......................................................++
e is 65537 (0x010001)
-----

Writing new private key Server to 'wild-fakedomain.com-private.key'
Writing new certificate signing request to 'wild-fakedomain.com-req.csr'

```
Creating private key and certificate of Authority
Creating private key and signing request of Server
```

Signature ok
subject=C = IT, ST = Italy, L = Milan, O = SysAdmin, OU = IT Dept, CN = *.fakedomain.com
Getting CA Private Key


1) Import CA FakeAuthority-cert.crt in your browser
2) Copy private key and certificate in your webserver:
   cp wild-fakedomain.com-cert.crt /etc/pki/tls/certs/
   cp wild-fakedomain.com-private.key /etc/pki/tls/private/
3) Modify following lines to ssl.conf
[-] SSLCertificateFile /etc/pki/tls/certs/ca.crt
[+] SSLCertificateFile /etc/pki/tls/certs/wild-fakedomain.com-cert.crt
[-] SSLCertificateKeyFile /etc/pki/tls/private/ca.key
[+] SSLCertificateKeyFile /etc/pki/tls/private/wild-fakedomain.com-private.key
4) call your website https://*fakedomain.com

```
Signing Certificate for Server.


## Import CA cert in your system or browser

## Import priate key and certificate in your apache server
