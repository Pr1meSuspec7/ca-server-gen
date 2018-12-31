
# How to setup your own CA with OpenSSL

For educational reasons I've decided to create my own CA.

# First things first

Lets get some context first.

## Public Key Cryptography

AKA asymmetric cryptography solves the problem of two entities communicating
securely without ever exchanging a common key, by using two related keys,
one private, one public.

Ciphered text with the public key can only be deciphered by the corresponding
private key, and verifiable signatures with the public key can only be created
with the private key.

But if the two entities do not know each other yet they a way to know for sure
that a public key corresponds to the private key of the other identity.

In other words, when Alice speaks to Bob, Bob tells Alice "this is my public
key K, use it to communicate with me" Alice needs to know it is really Bob's
public key and not Eve's.

The usual solution to this problem is to use a PKI.
