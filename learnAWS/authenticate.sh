#!/bin/bash
#########################################################################################################
# Filename:  authenticate.sh
#
#   certbot GoDaddy DNS TXT challenge updater
#
#   To create a cert
#   unix> dos2unix authenticate.sh
#   unix> sudo certbot certonly --manual --preferred-challenges dns --manual-auth-hook /path/to/authenticate.sh --config-dir /home/adam/certbot/ -d keycloak.traderres.com
#
#   To renew a cert  (untested)
#   unix> certbot renew --manual --manual-auth-hook /path/to/authenticate.sh  --manual-cleanup-hook /path/to/cleanup.sh
#########################################################################################################

# GoDaddy API Credentials
GODADDY_API_KEY="go-daddy-api-key-is-here"
GODADDY_API_SECRET="go-daddy-secret-value-is-here"
GODADDY_URL="https://api.godaddy.com/"

############################################################
# Replace all of a Domain's type of DNS Records
DNS_REC_TYPE=TXT
DNS_REC_NAME="_acme-challenge"
DNS_REC_DATA="$CERTBOT_VALIDATION"
DNS_REC_TTL="600"
MAINDOMAIN=$(expr match "$CERTBOT_DOMAIN" '.*\.\(.*\..*\)')
echo $CERTBOT_DOMAIN
echo $MAINDOMAIN
echo ${CERTBOT_DOMAIN%%.*}
OLDDOMAIN="${CERTBOT_DOMAIN}"
DOMAINNAME=""
echo $OLDDOMAIN
x="${OLDDOMAIN//[^.]}"
echo $x
y=$((${#x}-1))
echo $y
if [[ "${#x}" -gt 1 ]];
then
        echo "True"
        for ((c=1;c<=y;c++))
        do
                DOMAINNAME+=".$(echo $OLDDOMAIN | cut -d'.' -f$c)"
        done
        echo "_acmechallenge$DOMAINNAME"
        DNS_REC_NAME+="$DOMAINNAME"
else
        echo "False"
fi
curl -X PUT "${GODADDY_URL}/v1/domains/${MAINDOMAIN}/records/${DNS_REC_TYPE}" -H  "accept: application/json" -H  "Content-Type: application/json" -H  "Authorization: sso-key ${GODADDY_API_KEY}:${GODADDY_API_SECRET}" -d "[{ \"data\":\"${DNS_REC_DATA}\", \"name\": \"${DNS_REC_NAME}\", \"ttl\": ${DNS_REC_TTL} }]"
sleep 25
