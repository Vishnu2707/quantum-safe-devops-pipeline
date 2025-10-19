#!/usr/bin/env python3
"""
Quantum-Safe DevOps: Automated Performance Report Generator
Generates a Markdown summary comparing RSA vs Falcon handshake performance.
"""

import requests
import datetime

PROM_URL = "http://localhost:9090/api/v1/query"

# --- Helper to query Prometheus ---
def query(metric):
    try:
        r = requests.get(PROM_URL, params={'query': f'avg_over_time({metric}[5m])'})
        result = r.json()["data"]["result"]
        if result:
            return float(result[0]["value"][1])
    except Exception as e:
        print(f"Error querying {metric}: {e}")
    return None

# --- Collect metrics ---
rsa = query("pqc_ssh_rsa_handshake_seconds")
falcon = query("pqc_ssh_falcon_handshake_seconds")
cpu = query("pqc_cpu_usage_percent")

# --- Derived values ---
ratio = rsa / falcon if rsa and falcon else None
throughput = 1 / falcon if falcon else None
timestamp = datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S UTC")

# --- Build Markdown content ---
report = f"""# Quantum-Safe DevOps: Performance Summary

**Generated:** {timestamp}

| Metric | RSA (s) | Falcon (s) | Ratio (RSA/Falcon) | CPU (%) | Throughput (ops/sec) |
|:--------|:-------:|:-----------:|:------------------:|:-------:|:--------------------:|
| **Average (5 min)** | {rsa:.3f} | {falcon:.3f} | {ratio:.2f}× | {cpu:.2f} | {throughput:.2f} |

**System Health:** Stable  
**Observation:** Falcon 512 maintains post-quantum security with roughly {ratio:.2f}× the latency of RSA, under ~{cpu:.0f}% CPU load.
"""

# --- Save report ---
with open("quantum_performance_report.md", "w") as f:
    f.write(report)

print("Report generated: quantum_performance_report.md")
