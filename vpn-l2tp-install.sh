#!/bin/bash

# VPN config
VPN_PSK="senhasecreta123"
VPN_USER="vpnuser"
VPN_PASS="vpnpass"
VPN_LOCAL_IP="192.168.100.1"
VPN_REMOTE_IP="192.168.100.10-192.168.100.100"
DNS1="8.8.8.8"
DNS2="1.1.1.1"

echo "Atualizando pacotes..."
apt update -y && apt install -y strongswan xl2tpd ppp iptables lsof

echo "Configurando IPSEC..."
cat > /etc/ipsec.conf <<EOF
config setup
    charondebug="ike 1, knl 1, cfg 0"
    uniqueids=no

conn l2tp-psk
    keyexchange=ikev1
    authby=secret
    type=transport
    left=%defaultroute
    leftprotoport=17/1701
    right=%any
    rightprotoport=17/1701
    auto=add
EOF

echo "$VPN_USER  %any  : PSK \"$VPN_PSK\"" > /etc/ipsec.secrets

echo "Configurando XL2TPD..."
cat > /etc/xl2tpd/xl2tpd.conf <<EOF
[global]
ipsec saref = yes

[lns default]
ip range = $VPN_REMOTE_IP
local ip = $VPN_LOCAL_IP
require chap = yes
refuse pap = yes
require authentication = yes
name = l2tp-vpn
ppp debug = yes
pppoptfile = /etc/ppp/options.xl2tpd
length bit = yes
EOF

echo "Configurando PPP options..."
cat > /etc/ppp/options.xl2tpd <<EOF
require-mschap-v2
ms-dns $DNS1
ms-dns $DNS2
asyncmap 0
auth
crtscts
lock
hide-password
modem
debug
name l2tp-vpn
proxyarp
lcp-echo-interval 30
lcp-echo-failure 4
mtu 1410
mru 1410
EOF

echo "$VPN_USER l2tp-vpn $VPN_PASS *" > /etc/ppp/chap-secrets

echo "Habilitando encaminhamento de IP..."
sysctl -w net.ipv4.ip_forward=1
sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.conf
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf

echo "Aplicando regras de NAT (iptables)..."
iptables -t nat -A POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE
iptables-save > /etc/iptables.rules

echo "Adicionando restauração do iptables no boot..."
cat > /etc/network/if-pre-up.d/iptables <<EOF
#!/bin/sh
iptables-restore < /etc/iptables.rules
EOF
chmod +x /etc/network/if-pre-up.d/iptables

echo "Reiniciando serviços..."
if command -v service &> /dev/null; then
    service strongswan restart || service ipsec restart
    service xl2tpd restart
else
    /etc/init.d/strongswan restart || /etc/init.d/ipsec restart
    /etc/init.d/xl2tpd restart
fi

echo "✅ VPN L2TP/IPSec instalada com sucesso!"
echo "Usuário: $VPN_USER"
echo "Senha: $VPN_PASS"
echo "PSK: $VPN_PSK"

