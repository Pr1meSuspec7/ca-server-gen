#!/bin/bash

FILE=$1
CHECK_FILE=$(file $FILE)

# in base al tipo di file (CHECK_FILE) openssl mostra il contenuto lanciando il comando adatto
if [[ $CHECK_FILE == *"PEM RSA"* ]]; then
	openssl rsa -in $FILE -noout -text && cat $FILE
elif [[ $CHECK_FILE == *"PEM certificate" ]]; then
	openssl x509 -in $FILE -noout -text
elif [[ $CHECK_FILE == *"request"* ]]; then
	openssl req -in $FILE -noout -text
elif [[ $CHECK_FILE == *"ASCII"* ]]; then
	cat $FILE | grep "BEGIN PUBLIC KEY"
	if [[ $? == 0 ]]; then
		openssl rsa -in $FILE -pubin -noout -text && cat $FILE
	fi
else
	echo "ERROR: The file must be PEM RSA Private key, PEM Certificate or ASCII Public key."
fi
