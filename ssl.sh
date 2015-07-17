sysctl -w net.ipv4.ip_forward=1
iptables -t nat -F
iptables -t nat -X
iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8088
iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-ports 8443
#iptables -t nat -A PREROUTING -p tcp --dport 587 -j REDIRECT --to-ports 8443
#iptables -t nat -A PREROUTING -p tcp --dport 465 -j REDIRECT --to-ports 8443
#iptables -t nat -A PREROUTING -p tcp --dport 993 -j REDIRECT --to-ports 8443
#iptables -t nat -A PREROUTING -p tcp --dport 995 -j REDIRECT --to-ports 8443
iptables -t nat -A POSTROUTING -j MASQUERADE -o eth0

./sslsplit/sslsplit -M /staging/cert/modify.lua -D  -k /staging/cert/cert.key   -c /staging/cert/cert.crt  https 0.0.0.0 8443 http 0.0.0.0 8088
