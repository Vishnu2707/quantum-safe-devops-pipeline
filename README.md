# Quantum-Safe DevOps Pipeline (Full Pack)

End-to-end starter to practice *post-quantum* signing and DevOps integration using free tooling.
You can run entirely in **GitHub Actions** and **GitHub Codespaces** to avoid loading your Mac.
Includes:
- OpenSSL 3 + oqs-provider (Falcon/Dilithium/Kyber)
- PQC artifact signing + verification
- PQC-enabled OpenSSH (OQS fork) demo in Docker
- Docker image digest signing (OpenSSL Falcon) in CI
- Prometheus + Grafana (Docker Compose)
- Pushgateway metric publishing for build timing

## Quick Starts

### A) Cloud-first (recommended)
1. Create a new GitHub repo and push this folder.
2. Actions will run `Secure CI (PQC)` and `Docker Build + PQC Sign`.
3. Inspect logs under the **Actions** tab.

### B) Codespaces (hands-on, still cloud)
1. Open the repo in **Codespaces** (uses the included `.devcontainer`).
2. Run:
   ```bash
   bash scripts/pqc_verify_openssl.sh
   bash scripts/pqc_generate_keys.sh
   bash scripts/sign_artifact.sh ./README.md
   bash scripts/verify_artifact.sh ./README.md ./README.md.sig ./keys/pqc_cert.pem
   ```
3. If Docker is available: build and run the OQS-OpenSSH demo.
   ```bash
   docker build -t oqs-ssh:latest docker/openssh-oqs
   docker run --rm -it -p 2222:22 oqs-ssh:latest
   ```

### C) Local macOS (optional)
Run `bash scripts/setup_macos.sh` and follow the same steps as B).

## Monitoring Stack
Bring up Prometheus, Grafana, Node Exporter, cAdvisor, Pushgateway:
```bash
docker compose -f monitoring/docker-compose.monitoring.yml up -d
```
Push custom timing metrics from any script:
```bash
bash scripts/push_metrics.sh "build_duration_seconds" 12.34 "job=secure_ci,stage=sign"
```
The included Grafana dashboard JSON (`monitoring/grafana-dashboard.json`) gives a basic view.

## Repo Layout
See folders for scripts, CI, configs, monitoring, and Docker demos.
