
#!/bin/bash

cat /etc/hosts |
while read ip name 
do
    if [ -z "$ip" ] || [[ "$ip" == \#* ]]; then
        continue
    fi
    dns_ip=$(nslookup "$name" 8.8.8.8 | awk '
        /^Name:/ { answer=1; next }
        answer && /^Address:/ { print $2 }
    ')

    if [ -n "$dns_ip" ] && ! echo "$dns_ip" | grep -qx "$ip"; then
        echo "Bogus IP for $name in /etc/hosts!"
    fi
done

