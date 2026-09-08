#!/bin/bash
# Rotate security reports - keep last 2 of each type
REPORT_DIR=".security-reports"

for prefix in trivy-report trivy-image gitleaks; do
    files=($(ls -t ${REPORT_DIR}/${prefix}*.json 2>/dev/null))
    count=${#files[@]}
    if [ $count -gt 2 ]; then
        for ((i=2; i<count; i++)); do
            rm -f "${files[$i]}"
            echo "Removed old report: ${files[$i]}"
        done
    fi
done

echo "Reports remaining:"
ls -1 ${REPORT_DIR}/*.json 2>/dev/null | wc -l