#!/bin/bash

CPU_LOAD=$(top -b -n 1 | grep "Cpu(s)" | awk '{print $2 + $4}')

RAM_TOTAL=$(free -m | awk 'NR==2{print $2}')
RAM_USED=$(free -m | awk 'NR==2{print $3}')
RAM_PERCENT=$(awk "BEGIN {printf \"%.2f\", (${RAM_USED}/${RAM_TOTAL})*100}")

DISK_TOTAL=$(df -h / | awk 'NR==2{print $2}')
DISK_USED=$(df -h / | awk 'NR==2{print $3}')
DISK_PERCENT=$(df -h / | awk 'NR==2{print $5}')

LOG_DIR="/root/dummy_logs"
DAYS=7

find "$LOG_DIR" -type f -name "*.log" -mtime +$DAYS -exec rm -f {} \;

cat <<EOF > index.html
<!DOCTYPE html>
<html>
<head>
<title>Server Health Dashboard</title>
<style>
    body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #1e1e2f; color: #ffffff; margin: 0; padding: 40px; }
    .header { text-align: center; margin-bottom: 40px; }
    h1 { color: #00d2ff; }
    .container { display: flex; justify-content: center; gap: 20px; flex-wrap: wrap; }
    .card { background: #2a2a40; padding: 25px; border-radius: 12px; width: 250px; box-shadow: 0 8px 16px rgba(0,0,0,0.3); text-align: center; }
    .card h2 { margin-top: 0; font-size: 1.2rem; color: #a9a9b3; }
    .value { font-size: 2.2rem; font-weight: bold; margin: 15px 0; color: #00ea8d; }
    .sub-text { font-size: 0.9rem; color: #8e8e9f; }
    .status-card { width: 100%; max-width: 810px; margin: 30px auto; background: #2a2a40; padding: 20px; border-radius: 12px; border-left: 5px solid #00ea8d; }
</style>
</head>
<body>
    <div class="header">
        <h1>System Resource Dashboard</h1>
        <p>Live hardware metrics and automation status</p>
    </div>
    <div class="container">
        <div class="card">
            <h2>CPU Usage</h2>
            <div class="value">${CPU_LOAD}%</div>
            <div class="sub-text">Current Load</div>
        </div>
        <div class="card">
            <h2>Memory (RAM)</h2>
            <div class="value">${RAM_PERCENT}%</div>
            <div class="sub-text">${RAM_USED} MB / ${RAM_TOTAL} MB</div>
        </div>
        <div class="card">
            <h2>Disk Space (/)</h2>
            <div class="value">${DISK_PERCENT}</div>
            <div class="sub-text">${DISK_USED} / ${DISK_TOTAL} Used</div>
        </div>
    </div>
    <div class="status-card">
        <h3>Automation Task Status</h3>
        <p>Log cleanup executed successfully. Files older than $DAYS days removed from $LOG_DIR.</p>
    </div>
</body>
</html>
EOF

python3 -m http.server 8080
