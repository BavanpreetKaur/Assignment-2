#!/bin/bash

# Function to print formatted messages
print_msg() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Function to add users with specified configurations
add_users() {
    local users=("dennis" "aubrey" "captain" "snibbles" "brownie" "scooter" "sandy" "perrier" "cindy" "tiger" "yoda")
    for user in "${users[@]}"; do
        if ! id "$user" &>/dev/null; then
            print_msg "Adding user: $user"
            sudo adduser --disabled-password --gecos "" "$user"
            sudo usermod -s /bin/bash "$user"
            sudo mkdir -p /home/"$user"/.ssh
            sudo cp ~/.ssh/authorized_keys /home/"$user"/.ssh/
            sudo chown -R "$user":"$user" /home/"$user"/.ssh
        else
            print_msg "User $user already exists."
        fi
    done
}

# Function to configure network interface
configure_network() {
    local netplan_conf="/etc/netplan/01-network-manager-all.yaml"
    if grep -q "192.168.16.21/24" "$netplan_conf"; then
        print_msg "Network already configured."
    else
        print_msg "Configuring network interface..."
        sudo sed -i '/192.168.16.2/a \ \ \ \ nameservers:\n \ \ \ \ \ \ addresses: [192.168.16.2]\n \ \ \ \ search: [home.arpa, localdomain]' "$netplan_conf"
        sudo netplan apply
    fi
}

# Function to configure /etc/hosts file
configure_hosts() {
    local hosts_file="/etc/hosts"
    if grep -q "192.168.16.21.*server1" "$hosts_file"; then
        print_msg "/etc/hosts already configured."
    else
        print_msg "Configuring /etc/hosts file..."
        sudo sed -i 's/127.0.1.1.*/&\n192.168.16.21\tserver1/' "$hosts_file"
    fi
}

# Function to install and configure required software
install_configure_software() {
    print_msg "Installing required software..."
    sudo apt update
    sudo apt install -y apache2 squid ufw
    # Enable and configure apache2
    sudo systemctl enable apache2
    # Enable and configure squid
    sudo systemctl enable squid
    # Configure squid to allow connections from both interfaces
    sudo sed -i 's/http_access deny all/http_access allow all/' /etc/squid/squid.conf
}

# Function to configure firewall
configure_firewall() {
    print_msg "Configuring firewall..."
    sudo ufw allow in on eth0 to any port 22 proto tcp  # SSH on mgmt network
    sudo ufw allow in on eth0 to any port 80 proto tcp  # HTTP on mgmt network
    sudo ufw allow in on eth1 to any port 80 proto tcp  # HTTP on 192.168.16 network
    sudo ufw allow in on eth1 to any port 3128 proto tcp  # Squid proxy on 192.168.16 network
    sudo ufw --force enable
}

# Main function
main() {
    add_users
    configure_network
    configure_hosts
    install_configure_software
    configure_firewall
    print_msg "Configuration complete."
}

# Execute main function
main
