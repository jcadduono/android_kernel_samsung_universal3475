#!/bin/sh
VALID_TARGET="samsung"
VALID_DEVICE="gteslte o5lte on5ltetmo j1xlte"

INVALID() {
	echo "
You must specify a valid TARGET and DEVICE to build or configure for!

Valid TARGET=:
    samsung   - Reference Samsung Stock
Valid DEVICE=:
    gteslte   - Samsung Galaxy Tab E 8.0
    o5lte     - Samsung Galaxy On5 / On5 Pro (India / International)
    on5ltetmo - Samsung Galaxy On5 (T-Mobile / MetroPCS)
    j1xlte    - Samsung Galaxy J1 (2016)
	"
	exit 1
}

echo "$VALID_TARGET" | grep -Fqw "$1" || INVALID
echo "$VALID_DEVICE" | grep -Fqw "$2" || INVALID

exit 0
