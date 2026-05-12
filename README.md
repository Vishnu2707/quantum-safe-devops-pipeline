# Quantum-Safe DevOps Pipeline

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.20137072.svg)](https://doi.org/10.5281/zenodo.20137072)
[![Conference](https://img.shields.io/badge/Presented%20At-QAHE%20Global%20Connect%202026-blue)](https://doi.org/10.5281/zenodo.20137072)
[![License: CC BY 4.0](https://img.shields.io/badge/License-CC--BY--4.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)
[![Open Quantum Safe](https://img.shields.io/badge/Open%20Quantum%20Safe-OQS-success)](https://openquantumsafe.org/)
[![CI](https://img.shields.io/badge/CI-GitHub%20Actions-black)](https://github.com/Vishnu2707/quantum-safe-devops-pipeline/actions)

---

## Research Publication

**Design and Evaluation of a Post-Quantum Secure DevOps Pipeline Using Falcon, Dilithium, and Kyber**

Presented at:
**QAHE Global Connect Conference 2026**
Birmingham, United Kingdom

Open Access Preprint:
https://doi.org/10.5281/zenodo.20137072

---

## Overview

This repository demonstrates how secure DevOps environments can be prepared for the post-quantum era using open-source tools and reproducible workflows.

It implements a complete pipeline that integrates **post-quantum cryptography (PQC)** algorithms — particularly **Falcon** and **Dilithium** — into modern DevOps, CI/CD, and monitoring systems.

The project runs fully within **GitHub Actions** and **Codespaces**, eliminating the need for high local resources and ensuring a portable, cloud-based research environment.

---

# 1. Objective

To design and validate a **quantum-resistant DevOps workflow** that:

- Replaces classical RSA/ECDSA encryption with PQC algorithms (Falcon512, Dilithium)
- Integrates quantum-safe signing and verification into real automation pipelines
- Measures and visualizes handshake latency, CPU utilization, and performance trends
- Demonstrates how PQC can coexist with current infrastructure and monitoring tools

---

# 2. System Architecture

## High-Level Workflow

```text
Developer Commit ──► GitHub Actions (PQC Signing)
                           │
                           ▼
Docker Build ──► Falcon-Enabled OpenSSL / SSH
                           │
                           ▼
Prometheus Exporter ──► Metrics Collection
                           │
                           ▼
Grafana Dashboards ──► Live Visualization
                           │
                           ▼
Python Report Generator ──► Markdown + PDF Reports
```

## Architecture Diagram

![System Architecture](docs/pqc_devops_diagram.png)

The architecture shows how PQC algorithms are applied throughout the pipeline — from code commits and Docker image signing to performance monitoring and reporting.

---

# 3. Core Components

| Component | Function |
|------------|-----------|
| **OpenSSL + oqs-provider** | Integrates Falcon and Dilithium algorithms for signing and verification |
| **OQS-OpenSSH (Docker)** | Demonstrates quantum-safe SSH key generation and authentication |
| **Prometheus Exporter** | Collects PQC handshake latency, CPU metrics, and system health |
| **Grafana Dashboard** | Visualizes real-time PQC vs RSA performance and efficiency |
| **GitHub Actions** | Automates signing, verification, and reporting in CI/CD |
| **Python Reporter** | Generates Markdown and PDF reports summarizing metrics |

---

# 4. Key Features

- Post-Quantum Secure Signing (Falcon512, Dilithium)
- Quantum-Safe SSH Communication via Dockerized OQS-OpenSSH
- Real-Time Performance Monitoring (Prometheus + Grafana)
- CI/CD Artifact Signing and Verification
- Automated Reporting and Benchmarking
- Works entirely on free GitHub Actions and Codespaces environments

---

# 5. Monitoring Stack

The monitoring system visualizes live data from the PQC pipeline using Prometheus and Grafana.

## Metrics Monitored

- RSA and Falcon handshake latency
- CPU usage percentage
- Efficiency and latency ratio (RSA/Falcon)
- PQC throughput (operations per second)

## Grafana Dashboards

- `monitoring/grafana-dashboard.json`
- `monitoring/quantum-comparative-dashboard.json`

## Example Dashboards

![Grafana PQC Dashboard](docs/dashboard_main.png)

![Comparative Performance Dashboard](docs/dashboard_comparative.png)

---

# 6. Quick Start Guide

## A) GitHub Actions (Cloud First)

1. Fork or clone the repository to your GitHub account
2. Push any code change — the **Secure CI (PQC)** and **Performance Report** workflows will run automatically
3. View results under the **Actions** tab

---

## B) GitHub Codespaces (Hands-on)

1. Open the repository in Codespaces

2. Run:

```bash
bash scripts/pqc_verify_openssl.sh
bash scripts/pqc_generate_keys.sh
bash scripts/sign_artifact.sh ./README.md
bash scripts/verify_artifact.sh ./README.md ./signatures/README.md.sig ./keys/pqc_cert.pem
```

3. Optional: Build and test PQC SSH

```bash
docker build -t oqs-ssh:latest docker/openssh-oqs
docker run --rm -it -p 2222:22 oqs-ssh:latest
```

---

## C) Local macOS

```bash
bash scripts/setup_macos.sh
```

---

# 7. Monitoring Setup

Bring up the complete monitoring stack:

```bash
cd monitoring
docker compose up -d
```

## Access

Prometheus:
http://localhost:9090

Grafana:
http://localhost:3000

## Default Credentials

```text
Username: admin
Password: admin
```

---

# 8. Automated Reporting

A Python-based script fetches live Prometheus metrics and generates a Markdown summary.

## Generate Report

```bash
python3 monitoring/reports/report_generator.py
```

## Output

```text
monitoring/reports/quantum_performance_report.md
```

## Convert to PDF

```bash
pandoc monitoring/reports/quantum_performance_report.md -o docs/performance_summary.pdf
```

## Example Report

![Performance Summary](docs/performance_summary.png)

---

# 9. Results Snapshot

| Metric | RSA (s) | Falcon (s) | Ratio | CPU (%) |
|--------|----------|-------------|--------|----------|
| Avg (5 min) | 1.49 | 2.50 | 0.60× | 48.5 |

Falcon512 demonstrates slightly higher latency compared to RSA but remains within acceptable performance limits for CI/CD and infrastructure automation, proving that post-quantum algorithms can be practically integrated into production pipelines.

---

# 10. Repository Layout

```text
quantum-safe-devops-pipeline/
├── scripts/                # PQC signing, verification, CI utilities
├── docker/                 # PQC OpenSSH container
├── monitoring/             # Prometheus, Grafana, Exporters, Reports
├── .github/workflows/      # Secure CI and Report pipelines
├── keys/                   # PQC key pairs and certs
├── configs/                # OpenSSL and SSHD configurations
├── docs/                   # Architecture diagrams and dashboard screenshots
└── README.md
```

---

# 11. Research Insight

This project demonstrates that **quantum-safe cryptography can be embedded directly into operational DevOps systems today**.

By combining containerization, automated workflows, and observability, the project provides a realistic path for organizations to adopt post-quantum security within CI/CD environments.

It also offers reproducible metrics and dashboards, helping bridge the gap between:

- Academic PQC research
- Practical enterprise deployment
- DevSecOps automation
- Quantum-safe infrastructure engineering

---

# Conference Presentation

Presented at:
**QAHE Global Connect Conference 2026**
Birmingham, United Kingdom

Research Focus:
- Post-Quantum Cryptography
- DevSecOps
- CI/CD Security
- Quantum-Safe Infrastructure
- Open Quantum Safe (OQS)

---

# References

- Open Quantum Safe Project – https://openquantumsafe.org
- NIST Post-Quantum Cryptography Standardization Project
- Grafana Documentation
- Prometheus Documentation
- OpenSSH OQS Integration

---

# Citation

```bibtex
@misc{ajith2026pqcdevops,
  author       = {Vishnu Ajith and Muhammad Ibrahim and Muhammad Sihan Haroon},
  title        = {Design and Evaluation of a Post-Quantum Secure DevOps Pipeline Using Falcon, Dilithium, and Kyber},
  year         = {2026},
  publisher    = {Zenodo},
  doi          = {10.5281/zenodo.20137072},
  url          = {https://doi.org/10.5281/zenodo.20137072}
}
```

---

# Authors

## Vishnu Ajith
Research and Development Engineer – Post-Quantum Security  
Lecturer in Computing  
London, United Kingdom

GitHub:
https://github.com/Vishnu2707

ORCID:
https://orcid.org/0009-0008-6011-9245

---

## Muhammad Ibrahim
Research Engineer – Post-Quantum Security & Cloud Architecture

---

## Muhammad Sihan Haroon
Research Contributor – Quantum-Safe Infrastructure & DevSecOps
