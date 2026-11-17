#!/bin/bash

verify_ip() {
    name="$1"
    ip="$2"
    dns_server="$3"

    dns_ip=$(nslookup "$name" "$dns_server" | awk '
        /^Name:/ { answer=1; next }
        answer && /^Address:/ { print $2 }
    ')

    if [ -n "$dns_ip" ] && ! echo "$dns_ip" | grep -qx "$ip"; then
        echo "Bogus IP for $name in /etc/hosts!"
    fi
}

cat /etc/hosts |
while read ip name
do
    if [ -z "$ip" ] || [[ "$ip" == \#* ]]; then
        continue
    fi

    verify_ip "$name" "$ip" "8.8.8.8"
done
