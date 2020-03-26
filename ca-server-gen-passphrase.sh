#!/bin/bash

if [[ $1 = "--help" ]]; then
    echo -e "Usage: ./ca-server-gen-passphrase.sh -rsa BYTES -caname CA_NAME -cadays CA_VALIDITY -dns SERVER_DOMAIN -days SERVER_VALIDITY\nExample: ./ca-server-gen-passphrase.sh -rsa 4096 -caname FakeAuthority -cadays 3650 -dns fakedomain.com -days 700"
    exit 1
fi

while [ -n "$1" ]; do # while loop starts
    case "$1" in
    -rsa)
        RSA="$2"
        echo "Value for RSA: $RSA"
        shift
        ;;
    -caname)
        CANAME="$2"
        echo "Value for Authority's name: $CANAME"
        shift
        ;;
    -cadays)
        CADAYS="$2"
        echo "Value for CA validity: $CADAYS days"
        shift
        ;;
    -dns)
        DNS="$2"
        echo "Value for Server Domain Name: $DNS"
        shift
        ;;
    -days)
        DAYS="$2"
        echo "Value for Server Cert validity: $DAYS days"
        shift
        ;;
    --)
        shift # The double dash makes them parameters
        break
        ;;
    *) echo "Option $1 not recognized" ;;
    esac
    shift   
done

read -r -p "Are you sure? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        echo -e "\e[42mYES\e[49m"
        ;;
    *)
        echo -e "\e[41mCancel\e[49m"
        exit 1
        ;;
esac
sleep 1
echo -e "\n-----"
openssl genrsa -des3 -out $CANAME-private.key $RSA
#openssl genrsa -out $CANAME-private.key $RSA
openssl req -new -x509 -key $CANAME-private.key -out $CANAME-cert.crt -days $CADAYS -subj "/C=IT/ST=Italy/L=Milan/O=$CANAME Ltd/OU=RootCA/CN=$CANAME RootCA"
echo -e "-----\n\nWriting new private key Authority to '$CANAME-private.key'"
echo -e "Writing new certificate Authority to '$CANAME-cecrt.crt'"
echo -e "\n-----"
sleep 2
openssl genrsa -des3 -out wild-$DNS-private.key $RSA
#openssl genrsa -out wild-$DNS-private.key $RSA
openssl req -new -key wild-$DNS-private.key -out wild-$DNS-req.csr -subj "/C=IT/ST=Italy/L=Milan/O=SysAdmin/OU=IT Dept/CN=*.$DNS"
echo -e "-----\n\nWriting new private key Server to 'wild-$DNS-private.key'"
echo -e "Writing new certificate signing request to 'wild-$DNS-req.csr'"
echo -e "\n-----\n"
openssl x509 -req -in wild-$DNS-req.csr -CA $CANAME-cert.crt -CAkey $CANAME-private.key -CAcreateserial -out wild-$DNS-cert.crt -days $DAYS
sleep 2
echo -e "\n"
echo -e "1) Import CA $CANAME-cert.crt in your browser"
echo -e "2) Copy private key and certificate in your webserver:\n   cp wild-$DNS-cert.crt /etc/pki/tls/certs/\n   cp wild-$DNS-private.key /etc/pki/tls/private/"
echo -e "3) Modify following lines to ssl.conf\n[-] SSLCertificateFile /etc/pki/tls/certs/ca.crt\n[+] SSLCertificateFile /etc/pki/tls/certs/wild-$DNS-cert.crt\n[-] SSLCertificateKeyFile /etc/pki/tls/private/ca.key\n[+] SSLCertificateKeyFile /etc/pki/tls/private/wild-$DNS-private.key"
echo -e "4) call your website https://*$DNS\n\n"