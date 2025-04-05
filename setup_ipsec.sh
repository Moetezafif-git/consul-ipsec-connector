#!/bin/bash

# Set the log file
LOG_FILE="/var/log/ipsec_setup.log"

# Debugging function for certificates
log_cert_debug() {
    echo "===== DEBUG: $1 =====" | tee -a $LOG_FILE
    local file_path=$2
    
    # Basic file checks
    ls -l $file_path | tee -a $LOG_FILE
    file $file_path | tee -a $LOG_FILE
    
    # Show certificate fingerprints if available
    if [[ $file_path == *.crt ]]; then
        openssl x509 -noout -fingerprint -sha256 -in $file_path | tee -a $LOG_FILE
        openssl x509 -noout -subject -issuer -dates -in $file_path | tee -a $LOG_FILE
    fi
    
    # For private keys
    if [[ $file_path == *.key ]]; then
        openssl pkey -noout -text_pub -in $file_path 2>/dev/null | head -n 10 | tee -a $LOG_FILE
        echo "Key checksum: $(sha256sum $file_path)" | tee -a $LOG_FILE
    fi
    
    # Show first/last lines of file
    echo "--- File content excerpt ---" | tee -a $LOG_FILE
    head -n 3 $file_path | tee -a $LOG_FILE
    echo "... [truncated] ..." | tee -a $LOG_FILE
    tail -n 3 $file_path | tee -a $LOG_FILE
    echo "============================" | tee -a $LOG_FILE
}

# Check if the CONSUL_HTTP_ADDR environment variable is set
if [ -z "$CONSUL_HTTP_ADDR" ]; then
  echo "ERROR: CONSUL_HTTP_ADDR environment variable is not set"
  echo "$(date) - ERROR: CONSUL_HTTP_ADDR environment variable is not set" >> $LOG_FILE
  exit 1
fi

# Check if the service name argument is provided
if [ -z "$1" ]; then
  echo "ERROR: Please provide the service name as an argument"
  echo "$(date) - ERROR: Please provide the service name as an argument" >> $LOG_FILE
  exit 1
fi

# Set the service name
SERVICE_NAME=$1

# Log the start of the script
echo "Starting IPSEC setup for $SERVICE_NAME"
echo "$(date) - INFO: Starting IPSEC setup for $SERVICE_NAME" >> $LOG_FILE

# Set the URL for the CA leaf certificate
URL="${CONSUL_HTTP_ADDR}/v1/agent/connect/ca/leaf/${SERVICE_NAME}"

# Log the URL
echo "Fetching CA leaf certificate from $URL"
echo "$(date) - INFO: Fetching CA leaf certificate from $URL" >> $LOG_FILE

# Get the CA leaf certificate and save it to a temporary file
curl -s "$URL" > temp.json
echo "Fetched CA leaf certificate"
echo "$(date) - INFO: Fetched CA leaf certificate" >> $LOG_FILE

# Extract and log certificate
jq -r '.CertPEM' temp.json > /etc/ipsec.d/certs/${SERVICE_NAME}_certificate.crt
log_cert_debug "Service Certificate" /etc/ipsec.d/certs/${SERVICE_NAME}_certificate.crt

# Extract and log private key
jq -r '.PrivateKeyPEM' temp.json > /etc/ipsec.d/private/${SERVICE_NAME}_private_key.key
chmod 600 /etc/ipsec.d/private/${SERVICE_NAME}_private_key.key
log_cert_debug "Private Key" /etc/ipsec.d/private/${SERVICE_NAME}_private_key.key

# Configure secrets
echo ":   ECDSA ${SERVICE_NAME}_private_key.key" > /etc/ipsec.secrets
echo "Configured ipsec secrets"
echo "$(date) - INFO: Configured ipsec secrets" >> $LOG_FILE

# Remove temporary file
rm temp.json
echo "Removed temporary file"
echo "$(date) - INFO: Removed temporary file" >> $LOG_FILE

# Get CA Roots
CA_URL="${CONSUL_HTTP_ADDR}/v1/connect/ca/roots"
echo "Fetching CA roots from $CA_URL"
echo "$(date) - INFO: Fetching CA roots from $CA_URL" >> $LOG_FILE

curl -s "$CA_URL" > roots.json
echo "Fetched CA roots"
echo "$(date) - INFO: Fetched CA roots" >> $LOG_FILE

# Extract and log CA certificate
jq -r '.Roots[0].RootCert' roots.json > /etc/ipsec.d/cacerts/ca.crt
log_cert_debug "CA Certificate" /etc/ipsec.d/cacerts/ca.crt

rm roots.json
echo "Removed temporary file"
echo "$(date) - INFO: Removed temporary file" >> $LOG_FILE

# Restart ipsec
ipsec restart
echo "Restarted ipsec"
echo "$(date) - INFO: Restarted ipsec" >> $LOG_FILE

# IPSec status checks
echo "===== IPSec Debug Info =====" | tee -a $LOG_FILE
ipsec listcerts | tee -a $LOG_FILE
ipsec status | tee -a $LOG_FILE
ipsec verify | tee -a $LOG_FILE
echo "============================" | tee -a $LOG_FILE

# Log the end of the script
echo "IPSEC setup complete for $SERVICE_NAME"
echo "$(date) - INFO: IPSEC setup complete for $SERVICE_NAME" >> $LOG_FILE
echo "Current IPsec policies:"
ip xfrm policy