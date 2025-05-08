<h1 align="center">🔐 VPN L2TP/IPSec para MK-AUTH</h1>

<p align="center">
  Script de instalação automática para configurar uma VPN L2TP/IPSec (PSK) compatível com servidores Ubuntu utilizados pelo sistema <strong>MK-AUTH</strong>.
</p>

<p align="center">
  <a href="https://github.com/apoloravi/VPN-L2TP-Mk-auth"><img src="https://img.shields.io/github/repo-size/apoloravi/VPN-L2TP-Mk-auth?color=blue&style=flat-square" alt="Tamanho do repositório"></a>
  <a href="https://github.com/apoloravi/VPN-L2TP-Mk-auth/issues"><img src="https://img.shields.io/github/issues/apoloravi/VPN-L2TP-Mk-auth?style=flat-square" alt="Issues"></a>
  <a href="https://github.com/apoloravi/VPN-L2TP-Mk-auth/blob/main/LICENSE"><img src="https://img.shields.io/github/license/apoloravi/VPN-L2TP-Mk-auth?style=flat-square" alt="Licença"></a>
</p>

---

## 📦 O que este script faz

- ✅ Instala `strongSwan` (IPSec)
- ✅ Instala `xl2tpd` (L2TP)
- ✅ Configura `ppp` (autenticação)
- ✅ Habilita o roteamento IP
- ✅ Cria regras NAT com `iptables`
- ✅ Adiciona um usuário VPN de exemplo

---

## ⚙️ Requisitos

- Distribuição Ubuntu/Debian sem `systemd` (ex: utilizada pelo MK-AUTH)
- Acesso root ao servidor
- Portas abertas: **UDP 500**, **UDP 4500** e **UDP 1701**

---

## 🚀 Instalação

Siga os comandos abaixo para instalar:

```bash
git clone https://github.com/apoloravi/VPN-L2TP-Mk-auth.git
cd VPN-L2TP-Mk-auth
chmod +x vpn-l2tp-install.sh
sudo ./vpn-l2tp-install.sh
