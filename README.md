LDAP Lookup script
==================
Bash script to look up a user in LDAP. Includes an overridable config file. When this is populated, the script can be run with no additional parameters (defaults to looking yourself up).


Usage
-----
    ldap_lookup [[[[-u USERNAME] | [-v VALUE]] [-k KEY (default: uid)] [-f comma-delimited list of fields] [-lu LDAP_USERNAME] [-lp LDAP_PASSWORD] [-s LDAP_SERVER] [-i (insecure connection mode. must provide non-ssl port)] [-p LDAP_PORT (defaults to SSL port)] [-o OU] [-d DC]] | [-h]]"

basic:

    ldap_lookup -u jsmith

to convert ad-epoc to human time:

    gdate -d@$(( ( $(./ldap_lookup.sh -u jsmith -f  pwdLastSet | awk 'NR>1 {print $2}') / 10000000 ) - 11644473600 ))


Variables
---------
    -u (--username) USERNAME to look up
    -k (--key) KEY (default: uid)
    -v (--value) VALUE (overrides username. for looking up key/value pairs other than uid/username)
    -f (--fields) comma-delimited list of fields
    -lu (--ldap_username) LDAP_USERNAME
    -lp (--ldap_username) LDAP_PASSWORD
    -s (--ldap_server) LDAP_SERVER
    -i (--insecure) flag. insecure (non-SSL) connection mode. must provide non-SSL port
    -p (--ldap_port) LDAP_PORT (defaults to SSL port)
    -o (--ou) OU organizational unit
    -d (--dc) DC domain components
    -h (--help) flag. displays usage information and exits


Authors
-------
originally written by Farooq Sadiq (https://github.com/farooqsadiq)  
parameterized by Drew Heles (https://github.com/dheles)
