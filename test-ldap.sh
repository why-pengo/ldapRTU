#!/bin/bash

# GLAuth Test Script
# This script tests connectivity to the GLAuth LDAP server

set -e

LDAP_HOST="${LDAP_HOST:-localhost}"
LDAP_PORT="${LDAP_PORT:-3893}"
LDAPS_PORT="${LDAPS_PORT:-3894}"
BASE_DN="${BASE_DN:-dc=glauth,dc=com}"
BIND_DN="${BIND_DN:-cn=serviceuser,ou=svcaccts,dc=glauth,dc=com}"
BIND_PW="${BIND_PW:-mysecret}"

echo "GLAuth LDAP Connection Test"
echo "============================"
echo ""

# Check if ldapsearch is available
if ! command -v ldapsearch &> /dev/null; then
    echo "Error: ldapsearch command not found."
    echo "Please install OpenLDAP client tools:"
    echo "  - macOS: brew install openldap"
    echo "  - Ubuntu/Debian: apt-get install ldap-utils"
    echo "  - RHEL/CentOS: yum install openldap-clients"
    exit 1
fi

# Test LDAP (non-TLS)
echo "Testing LDAP connection (port ${LDAP_PORT})..."
if ldapsearch -x -H "ldap://${LDAP_HOST}:${LDAP_PORT}" \
    -b "${BASE_DN}" \
    -D "${BIND_DN}" \
    -w "${BIND_PW}" \
    -LLL "(objectClass=*)" dn 2>&1 | grep -q "dn:"; then
    echo "✓ LDAP connection successful"
    echo ""
    echo "Sample query:"
    ldapsearch -x -H "ldap://${LDAP_HOST}:${LDAP_PORT}" \
        -b "${BASE_DN}" \
        -D "${BIND_DN}" \
        -w "${BIND_PW}" \
        -LLL "(cn=johndoe)" | head -20
else
    echo "✗ LDAP connection failed"
    echo "Make sure the container is running: make up"
fi

echo ""
echo "============================"
echo ""

# Test LDAPS (TLS)
echo "Testing LDAPS connection (port ${LDAPS_PORT})..."
if LDAPTLS_REQCERT=never ldapsearch -x -H "ldaps://${LDAP_HOST}:${LDAPS_PORT}" \
    -b "${BASE_DN}" \
    -D "${BIND_DN}" \
    -w "${BIND_PW}" \
    -LLL "(objectClass=*)" dn 2>&1 | grep -q "dn:"; then
    echo "✓ LDAPS connection successful"
else
    echo "✗ LDAPS connection failed"
    echo "Make sure the container is running: make up"
fi

echo ""
echo "============================"
echo ""
echo "Test users:"
echo "  - cn=johndoe,ou=superheros,${BASE_DN} (password: dogood)"
echo "  - cn=serviceuser,ou=svcaccts,${BASE_DN} (password: mysecret)"
echo ""
echo "Example query:"
echo "  ldapsearch -x -H ldap://${LDAP_HOST}:${LDAP_PORT} \\"
echo "    -b '${BASE_DN}' \\"
echo "    -D '${BIND_DN}' \\"
echo "    -w '${BIND_PW}' \\"
echo "    '(objectClass=*)'"

