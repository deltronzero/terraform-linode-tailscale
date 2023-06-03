# set hostname
hostnamectl set-hostname $(cat /tmp/hostname)

# enable ip forwarding
echo 'net.ipv4.ip_forward = 1' | tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | tee -a /etc/sysctl.d/99-tailscale.conf
sysctl -p /etc/sysctl.d/99-tailscale.conf

# install tailscale
curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
apt update
apt install -y tailscale
sudo systemctl start tailscaled
sudo systemctl enable tailscaled
tailscale up --advertise-exit-node --authkey=$(cat /tmp/ts)
shred -u /tmp/ts

# disable password ssh auth
echo PasswordAuthentication=no > /etc/ssh/sshd_config.d/99-disablepassword.conf