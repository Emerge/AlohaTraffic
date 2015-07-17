iptables -t nat -F
iptables -t nat -X
sysctl -w net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -j MASQUERADE -o eth0
