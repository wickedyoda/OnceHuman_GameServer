#!/bin/bash
set -euo pipefail

# Security report rotation: keep last 2 of each report type
REPORT_DIR="."
KEEP=2

rotate() {
  local pattern="$1"
  ls -1t ${pattern} 2>/dev/null | tail -n +$((KEEP+1)) | xargs -r rm -f || true
}

rotate "trivy-report-*.json"
rotate "trivy-image-report-*.json"
rotate "gitleaks-report-*.json"
rotate "trivy-report-*.sarif"
