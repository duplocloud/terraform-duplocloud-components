#!/usr/bin/env bash

SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
OUTFILE="$SCRIPTPATH/cidr.txt"

# Function to convert IP address from dotted-decimal to integer
ip_to_int() {
  local a b c d
  IFS=. read -r a b c d <<< "$1"
  echo "$((a << 24 | b << 16 | c << 8 | d))"
}

# Function to convert integer back to dotted-decimal IP address
int_to_ip() {
  local num=$1
  echo "$((num >> 24 & 255)).$((num >> 16 & 255)).$((num >> 8 & 255)).$((num & 255))"
}

# Function to extract the IP part from a CIDR
extract_ip_from_cidr() {
  echo "${1%/*}"
}

# Initialize variables
max_ip_int=0
largest_cidr=""

# Iterate over each CIDR in the list
for cidr in "$@"; do
  current_ip=$(extract_ip_from_cidr "$cidr")
  current_ip_int=$(ip_to_int "$current_ip")

  if (( current_ip_int > max_ip_int )); then
    max_ip_int=$current_ip_int
    largest_cidr=$cidr
  fi
done

# Original CIDR block
original_cidr="$largest_cidr"
ip="${original_cidr%/*}"
prefix="${original_cidr#*/}"

# Calculate total number of IPs in the block
total_ips=$((1 << (32 - prefix)))

# Convert original IP to integer
ip_int=$(ip_to_int "$ip")

# Increment IP to get the next CIDR block's starting IP
next_ip_int=$((ip_int + total_ips))

# Convert the incremented integer back to an IP address
next_ip=$(int_to_ip "$next_ip_int")

# Output the next valid CIDR block
next_cidr="${next_ip}/${prefix}"

cat <<EOF
{
  "largest": "$largest_cidr",
  "next": "$next_cidr"
}
EOF

# echo "$next_cidr" >> "$OUTFILE"
