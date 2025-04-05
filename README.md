# consul-ipsec-connector

`consul-ipsec-connector` is an example project that demonstrates how to design and automate IPSec tunnels between containers in dynamic environments. It leverages Consul for service discovery and certificate management, enabling secure, encrypted communication channels without manual configuration.

When two containers start, the connector provisions certificates using Consul, negotiates IPSec parameters, and establishes a secure tunnel between them — showcasing how to build a dynamic and automated IPSec infrastructure.

## Features:
- Automatic IPSec tunnel creation on container startup
- Certificate generation and rotation powered by Consul
- Dynamic service discovery using Consul agents
- Zero-touch configuration for secure communication
- Lightweight and container-friendly architecture
- Example code for educational and reference purposes

## Purpose:
This project is intended as a reference implementation or starting point for designing secure container-to-container communication using IPSec and Consul.  
It’s not production-ready but provides a clear example of the architecture, tooling, and automation involved.

## Architecture Overview:

This setup involves two containers that securely communicate with each other over an IPSec tunnel. The key components include:
1. **Consul**: Used for service discovery and certificate management.
2. **IPSec Tunnel**: Secure, encrypted communication between containers, managed dynamically.

### How It Works:
1. **Service Discovery**: Consul provides dynamic service discovery, ensuring that containers can securely locate each other and establish connections.
2. **Certificate Management**: Certificates are automatically generated, signed, and rotated by Consul, eliminating the need for manual certificate handling.
3. **Tunnel Negotiation**: IPSec parameters are automatically negotiated between containers upon startup, ensuring seamless connectivity.

## Technologies Used:
- **Consul**: Service discovery and certificate management
- **IPSec**: Encrypted communication
- **Docker**: Containerized environment for running services
- **Bash/Script**: Used for container startup logic


