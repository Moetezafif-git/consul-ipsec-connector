consul-ipsec-connector
consul-ipsec-connector is an example project that demonstrates how to design and automate IPSec tunnels between containers in dynamic environments.

It leverages Consul for service discovery and certificate management, enabling secure, encrypted communication channels without manual configuration.

When two containers start, the connector provisions certificates using Consul, negotiates IPSec parameters, and establishes a secure tunnel between them — showcasing how to build a dynamic and automated IPSec infrastructure.

Features:
Automatic IPSec tunnel creation on container startup

Certificate generation and rotation powered by Consul

Dynamic service discovery using Consul agents

Zero-touch configuration for secure communication

Lightweight and container-friendly architecture

Example code for educational and reference purposes

Purpose:
This project is intended as a reference implementation or starting point for designing secure container-to-container communication using IPSec and Consul.
It’s not production-ready but provides a clear example of the architecture, tooling, and automation involved.
