#!/bin/bash

# GLAuth Test Script
# This script tests connectivity to the GLAuth LDAP server

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

LDAP_HOST="${LDAP_HOST:-localhost}"
LDAP_PORT="${LDAP_PORT:-3893}"
LDAPS_PORT="${LDAPS_PORT:-3894}"
BASE_DN="${BASE_DN:-dc=glauth,dc=com}"
BIND_DN="${BIND_DN:-cn=serviceuser,ou=svcaccts,dc=glauth,dc=com}"
BIND_PW="${BIND_PW:-mysecret}"

echo -e "${BOLD}${CYAN}GLAuth LDAP Connection Test${NC}"
echo -e "${CYAN}============================${NC}"
echo ""

# Check if ldapsearch is available
if ! command -v ldapsearch &> /dev/null; then
    echo -e "${RED}Error: ldapsearch command not found.${NC}"
    echo -e "${YELLOW}Please install OpenLDAP client tools:${NC}"
    echo "  - macOS: brew install openldap"
    echo "  - Ubuntu/Debian: apt-get install ldap-utils"
    echo "  - RHEL/CentOS: yum install openldap-clients"
    exit 1
fi

# Test LDAP (non-TLS)
echo -e "${BLUE}Testing LDAP connection (port ${LDAP_PORT})...${NC}"
if ldapsearch -x -H "ldap://${LDAP_HOST}:${LDAP_PORT}" \
    -b "${BASE_DN}" \
    -D "${BIND_DN}" \
    -w "${BIND_PW}" \
    -LLL "(objectClass=*)" dn 2>&1 | grep -q "dn:"; then
    echo -e "${GREEN}✓ LDAP connection successful${NC}"
    echo ""
    echo -e "${CYAN}Sample query:${NC}"
    ldapsearch -x -H "ldap://${LDAP_HOST}:${LDAP_PORT}" \
        -b "${BASE_DN}" \
        -D "${BIND_DN}" \
        -w "${BIND_PW}" \
        -LLL "(cn=johndoe)" | head -20
else
    echo -e "${RED}✗ LDAP connection failed${NC}"
    echo -e "${YELLOW}Make sure the container is running: make up${NC}"
fi

echo ""
echo -e "${CYAN}============================${NC}"
echo ""

# Test LDAPS (TLS)
echo -e "${BLUE}Testing LDAPS connection (port ${LDAPS_PORT})...${NC}"
if LDAPTLS_REQCERT=never ldapsearch -x -H "ldaps://${LDAP_HOST}:${LDAPS_PORT}" \
    -b "${BASE_DN}" \
    -D "${BIND_DN}" \
    -w "${BIND_PW}" \
    -LLL "(objectClass=*)" dn 2>&1 | grep -q "dn:"; then
    echo -e "${GREEN}✓ LDAPS connection successful${NC}"
else
    echo -e "${RED}✗ LDAPS connection failed${NC}"
    echo -e "${YELLOW}Make sure the container is running: make up${NC}"
fi

echo ""
echo -e "${CYAN}============================${NC}"
echo ""
echo -e "${BOLD}Test users:${NC}"
echo -e "  ${GREEN}•${NC} cn=johndoe,ou=superheros,${BASE_DN} ${YELLOW}(password: dogood)${NC}"
echo -e "  ${GREEN}•${NC} cn=serviceuser,ou=svcaccts,${BASE_DN} ${YELLOW}(password: mysecret)${NC}"
echo ""
echo -e "${BOLD}Example query:${NC}"
echo -e "  ${CYAN}ldapsearch -x -H ldap://${LDAP_HOST}:${LDAP_PORT} \\${NC}"
echo -e "    ${CYAN}-b '${BASE_DN}' \\${NC}"
echo -e "    ${CYAN}-D '${BIND_DN}' \\${NC}"
echo -e "    ${CYAN}-w '${BIND_PW}' \\${NC}"
echo -e "    ${CYAN}'(objectClass=*)'${NC}"

