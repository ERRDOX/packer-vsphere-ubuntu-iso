#!/bin/bash

echo '> Cleaning all audit logs ...'
if [ -f /var/log/audit/audit.log ]; then
cat /dev/null > /var/log/audit/audit.log
fi
if [ -f /var/log/wtmp ]; then
cat /dev/null > /var/log/wtmp
fi
if [ -f /var/log/lastlog ]; then
cat /dev/null > /var/log/lastlog
fi
# Cleans SSH keys.
echo '> Cleaning SSH keys ...'
rm -f /etc/ssh/ssh_host_*

#hostnamectl set-hostname localhost
# Cleans apt-get.
echo '> Cleaning apt-get ...'
apt-get clean
# Cleans the machine-id.
echo '> Cleaning the machine-id ...'
truncate -s 0 /etc/machine-id
rm /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id
ssh-keygen -A

# Disable swap disk 
# swapoff -a
sed -Ei '/swap/{s/^#//;t;s/^/#/}' /etc/fstab

# Sets hostname to localhost.
echo '> Setting hostname ...'
cat /dev/null > /etc/hostname

# Function to generate a random uppercase alphabet character
generate_random_alphabet() {
    alphabet="ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
    random_string=""
    for ((i = 0; i < 6; i++)); do
        random_char=${alphabet:$((RANDOM % 26)):1}
        random_string="${random_string}${random_char}"
    done
    echo "$random_string"
}

# Function to get the total number of CPU cores
get_total_cores() {
    total_cores=$(nproc)
    echo "$total_cores"
}
# Function to set the new hostname
set_hostname() {
    new_hostname="$1"
    echo "Setting hostname to: $new_hostname"
    hostnamectl set-hostname "$new_hostname"
}

# Main script
random_alphabet=$(generate_random_alphabet)
total_cores=$(get_total_cores)

if [ -n "$random_alphabet" ] && [ -n "$total_cores" ]; then
    new_hostname="Bitex-VM-C$total_cores-$random_alphabet"
    set_hostname "$new_hostname"
fi


# optional: cleaning cloud-init
# echo '> Cleaning cloud-init'
# rm -rf /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg
# rm -rf /etc/cloud/cloud.cfg.d/99-installer.cfg
# echo 'datasource_list: [ VMware, NoCloud, ConfigDrive ]' | tee /etc/cloud/cloud.cfg.d/90_dpkg.cfg
# /usr/bin/cloud-init clean
cat <<EOT > /etc/issue.net
------------------------------------------------------------------------------
* WARNING.................... Dear Hacker ................................   *
* You are accessing a secured system and your actions will be logged along   *
* with identifying information. Disconnect immediately if you are not an     *
* authorized user of this system.                                            *
------------------------------------------------------------------------------
EOT
# cat <<EOT >> /etc/sysctl.conf
# # Decrease TIME_WAIT seconds
# net.ipv4.tcp_fin_timeout = 30
 
# # Recycle and Reuse TIME_WAIT sockets faster
# net.ipv4.tcp_tw_recycle = 1
# net.ipv4.tcp_tw_reuse = 1

# # Decrease ESTABLISHED seconds
# net.netfilter.nf_conntrack_tcp_timeout_established=3600

# # Maximum Number Of Open Files
# fs.file-max = 500000

# # 
# vm.max_map_count=262144

# net.ipv4.ip_nonlocal_bind = 1
# net.bridge.bridge-nf-call-iptables = 1
# net.bridge.bridge-nf-call-ip6tables = 1
# net.ipv4.ip_forward = 1

# #Kernel Hardening
# fs.suid_dumpable = 0
# kernel.core_uses_pid = 1
# kernel.dmesg_restrict = 1
# kernel.kptr_restrict = 2
# kernel.sysrq = 0 
# net.ipv4.conf.all.log_martians = 1
# net.ipv6.conf.all.accept_redirects = 0
# net.ipv6.conf.default.accept_redirects = 0

# #New Kernel Hardening
# net.ipv4.conf.all.forwarding = 1
# net.ipv4.conf.all.send_redirects = 0
# net.ipv4.conf.default.accept_redirects = 0
# net.ipv4.conf.default.accept_source_route = 0
# net.ipv4.conf.default.log_martians = 1
# net.ipv4.conf.all.accept_redirects = 0

# # Disable Ipv6
# net.ipv6.conf.all.disable_ipv6=1
# net.ipv6.conf.default.disable_ipv6=1
# net.ipv6.conf.lo.disable_ipv6=1
# net.ipv4.conf.all.rp_filter=1
# kernel.yama.ptrace_scope=1
# EOT
echo "root soft nofile 65535" >  /etc/security/limits.conf
echo "root hard nofile 65535" >> /etc/security/limits.conf
echo "root soft nproc 65535"  >> /etc/security/limits.conf
echo "root hard nproc 65535"  >> /etc/security/limits.conf

echo "* soft nofile 2048" >  /etc/security/limits.conf
echo "* hard nofile 2048" >> /etc/security/limits.conf
echo "* soft nproc  2048" >> /etc/security/limits.conf
echo "* hard nproc  2048" >> /etc/security/limits.conf