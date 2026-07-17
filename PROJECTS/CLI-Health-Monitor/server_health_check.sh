#!/usr/bin/env bash

set -euo pipefail

LOG_FILE=$(mktemp /tmp/server_health.XXXXXX)
readonly LOG_FILE

log_info() {
echo "[INFO] $1" | tee -a "$LOG_FILE"
}

log_error() {
echo "[ERROR] $1" | tee -a "$LOG_FILE">&2
}

print_usage() {
echo "Usage: $0 -f <server_list_file> -u <remote_user>"
echo "	-f: path to a file containing a list of servers (one per line)"
echo "	-u: the remote SSH user to connect as"
echo "	-h: display this help message"
}

cleanup() {
echo "Cleaning up temporary log file: $LOG_FILE"
rm -f "$LOG_FILE"
}

check_server() {
	local server="$1"
	local user="$2"
	log_info "--- Checking server: $server ---"
	
	ssh -o ConnectTimeout=5 "${user}@${server}" << 'INNER_EOF'
echo " --- System Uptime ---"
uptime

echo " --- Disk Usage (Root /) ---"
df -h / | awk 'NR==2 {print "Used: " $5 " (" $3 "/" $2 ")"}'

echo " --- Memory Usage ---"
free -m | awk 'NR==2 { printf "Used: %sMB / Total: %sMB (%.2f%%)\n", $3, $2, ($3/$2)*100}'

echo "--- Security (SSH) ---"
AUTH_LOG="/var/log/secure"
if [[ -f "$AUTH_LOG" ]]; then
count=$(sudo grep -c "Failed password" "$AUTH_LOG")
echo "Failed SSH Attempts: $count"
else
echo "Failed SSH Attempts: auth log not found"
fi
INNER_EOF
log_info "--- Finished Check: $server ---"
}

main() {
local server_file=""
local remote_user=""

while getopts ":f:u:h" opt; do
	case "$opt" in
		f) server_file="$OPTARG" ;;
		u) remote_user="$OPTARG" ;;
		h) print_usage; exit 0 ;;
		/?) log_error "Invalid option: $OPTARG"; print_usage; exit 1 ;;
		:) log_error "Option -$OPTARG requires an argument"; print_usage; exit 1 ;;
	esac
done

if [[ -z "$server_file" || -z "$remote_user" ]]; then
	log_error "Missing required arguments"
	print_usage
	exit 1
fi

if [[ ! -f "$server_file" ]]; then
	log_error "Server file not found: $server_file"
	exit 1
fi

declare -a servers=()

while IFS= read -r line; do
	if [[ -z "$line" || "$line" == \#* ]]; then
		continue
	fi
	servers+=("$line")
done <"$server_file"
	
if [[ ${#servers[@]} -eq 0 ]]; then
	log_error "No servers found in $server_file. Exiting..."
	exit 1
fi
	
log_info "Configuration valid. Starting health checks..."
log_info "Found ${#servers[@]} servers to check. Starting..."

for server_host in "${servers[@]}"; do
	check_server "$server_host" "$remote_user"
done

log_info "All checks completed"
}

main "$@"

