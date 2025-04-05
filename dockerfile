FROM ubuntu:latest

# Set Consul version
ENV CONSUL_VERSION=1.19.1-1

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    lsb-release \
    jq \
    strongswan

# Add HashiCorp GPG key
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -

# Add HashiCorp repo
RUN echo "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/hashicorp.list

# Install Consul
RUN apt-get update && apt-get install -y consul=${CONSUL_VERSION}

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy the script into the image
COPY setup_ipsec.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup_ipsec.sh

# Set the Consul HTTP address environment variable
ENV CONSUL_HTTP_ADDR=http://consul:8501
