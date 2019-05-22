# LDAP examples: https://ldap.com/ldap-urls/

#fields can include: objectClass,cn,sn,c,ou,title,department,physicalDeliveryOfficeName,telephoneNumber,facsimileTelephoneNumber,givenName,distinguishedName,instanceType,whenCreated,whenChanged,displayName,uSNCreated,memberOf,pwdLastSet,sAMAccountName,sAMAccountType,mail,manager,lastLogonTimestamp

function usage
{
  echo "usage: ldap_lookup [[[[-u USERNAME] | [-v VALUE]] [-k KEY (default: uid)] [-f comma-delimited list of fields] [-lu LDAP_USERNAME] [-lp LDAP_PASSWORD] [-s LDAP_SERVER] [-i (insecure connection mode. must provide non-ssl port)] [-p LDAP_PORT (defaults to SSL port)] [-o OU] [-d DC]] | [-h]]"
}

# defaults
KEY="uid"
FIELDS="*"
PROTOCOL="ldaps"

# read our config file to get settings
if test -f ldap.config ; then
  . ldap.config
else
  echo "cannot read ldap.config file"
  exit 1
fi

# look yourself up by default
VALUE="$LDAP_USERNAME"

# process arguments:
while [ "$1" != "" ]; do
  case $1 in
    -u | --username )         shift
                              VALUE=$1
                              ;;
    -k | --key )              shift
                              KEY=$1
                              ;;
    -v | --value )            shift
                              VALUE=$1
                              ;;
    -f | --fields )           shift
                              FIELDS=$1
                              ;;
    -lu | --ldap_username )   shift
                              LDAP_USERNAME=$1
                              ;;
    -lp | --ldap_password )   shift
                              LDAP_PASSWORD=$1
                              ;;
    -s | --ldap_server )      shift
                              LDAP_SERVER=$1
                              ;;
    -i | --insecure )         shift
                              PROTOCOL="ldap"
                              ;;
    -p | --ldap_port )        shift
                              LDAP_PORT=$1
                              ;;
    -o | --ou )               shift
                              OU=$1
                              ;;
    -d | --dc )               shift
                              DC=$1
                              ;;
    -h | --help )             usage
                              exit
                              ;;
    * )                       usage
                              exit 1
  esac
  shift
done

LDAP_BASE="ou=$OU,$DC"
LDAP_USERNAME_DN="cn=$LDAP_USERNAME,$LDAP_BASE"

#TODO:
# disabled=${4}
# if [ "$disabled" ] ; then
#   ou="$ou-$disabled"
# fi

# NOTE: SSL works if you use -k to supress the ca_cert error
/usr/bin/curl -k -u $LDAP_USERNAME_DN:$LDAP_PASSWORD   \
	"$PROTOCOL://$LDAP_SERVER:$LDAP_PORT/$LDAP_BASE?$FIELDS?sub?($KEY=$VALUE)"
