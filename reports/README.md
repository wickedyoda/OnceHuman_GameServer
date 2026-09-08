# Security scan reports (kept here but .gitignored as they change)
# Run: trivy fs . --format json --output trivy-report.json
# Run: trivy image --format json --output trivy-image-report.json once-human:ci
# Run: gitleaks detect --source . --report-path ./gitleaks-report.json --redact