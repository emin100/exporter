#!/bin/bash

unset GCP_SERVICE_ACCOUNT_CONTENTS
INSTALL=false

function usage () {
   echo "This tools install exporters to vms."
   echo
   echo "Syntax: [-i|p|f|h|v|V]"
   echo "options:"
   echo "i     install"
   echo "p     install"
   echo "f     install"
   echo "h     Help."
   echo "v     Verbose mode."
   echo "V     Print software version and exit."
   echo
   copyrights
   echo

}

function copyrights () {
    echo "Copyrights MEK@2023"
} 



PARSED_ARGUMENTS=$(getopt -n "$0" -o "p,f:ihkv" --long "password,password_file:,install,help,key_file,version" -- "$@")
VALID_ARGUMENTS=$?
if [ "$VALID_ARGUMENTS" != "0" ] || [ -z "$1" ]; then
  usage
fi

eval set -- "$PARSED_ARGUMENTS"


while :
do
  case "$1" in
    -h | --help) 
        usage
        shift ;;
    -v | --version) 
        copyrights
        shift ;;
    -p | --password) 
        export GCP_SERVICE_ACCOUNT_CONTENTS=$(ansible-vault view execute/key.json --vault-password-file <(cat <<<"$2"))
        shift 2;;
    -f | --password_file) 
        export GCP_SERVICE_ACCOUNT_CONTENTS=$(ansible-vault view execute/key.json --vault-password-file $2)
        shift 2;;
    -k | --key_file) 
        export GCP_SERVICE_ACCOUNT_FILE="execute/key_open.json"
        shift ;;
    -i | --install) 
        INSTALL=true
        shift ;;
    --) shift; break ;;
    *) echo "Unexpected option: $1 - this should not happen."
       break ;;
  esac
done


if [ $INSTALL == true ];
then
    ansible-playbook execute/install.yml 
fi