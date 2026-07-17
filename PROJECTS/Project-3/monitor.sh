#!/bin/bash
set -euo pipefail

HTML_FILE="html/index.html"

echo "<!DOCTYPE html><html><head><meta charset='UTF-8'><title>Server Health</title><meta http-equiv='refresh' content='10'></head><body style='font-family: Arial; padding: 20px;'>" > $HTML_FILE
echo "<h2>Live Server Health Dashboard</h2>" >> $HTML_FILE
echo "<p><b>Hostname:</b> $(hostname)</p>" >> $HTML_FILE
echo "<p><b>Uptime:</b> $(uptime -p)</p>" >> $HTML_FILE
echo "<p><b>Memory Usage:</b> $(free -m | awk '/Mem:/ {print $3" MB used / "$2" MB total"}')</p>" >> $HTML_FILE
echo "<p><b>Root Disk:</b> $(df -h / | awk 'NR==2 {print $5}')</p>" >> $HTML_FILE
echo "<p><i>Last Updated: $(date)</i></p>" >> $HTML_FILE
echo "</body></html>" >> $HTML_FILE
