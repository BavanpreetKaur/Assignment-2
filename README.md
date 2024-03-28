# Assignment-2 Server Configuration Script

## Introduction
This repository contains a script (`assignment2.sh`) designed to automate the configuration of a server according to specific requirements outlined in an assignment. The script is intended to be run on an Ubuntu 22.04 server (tested on a container named server1), and it ensures that the server is configured with the necessary network settings, software packages, firewall rules, and user accounts.

## Prerequisites
Before running the script, ensure the following:

- You have access to an Ubuntu 22.04 server (tested on server1 container).
- You have sudo privileges on the server.
- The server has internet access to download necessary packages.

## Instructions
1. Clone this repository to your local machine or download the `assignment2.sh` script.
2. Copy the `assignment2.sh` script to your Ubuntu 22.04 server using SCP or any preferred method.
3. SSH into your server.
4. Ensure the script has execute permissions:
   ```bash
   chmod +x assignment2.sh

## Execute the script with sudo privileges:

- sudo ./assignment2.sh
- Follow any prompts or instructions provided by the script.
- Once the script completes, verify that the server is configured according to the assignment requirements.
 - What Does the Script Do?
### The assignment2.sh script performs the following tasks:

#### Adds specified user accounts with predefined configurations.
#### Configures the network interface according to the assignment requirements.
#### Updates the /etc/hosts file to include the required IP address and hostname.
#### Installs and configures necessary software packages (Apache2, Squid, UFW).
#### Configures the firewall (UFW) to allow specific incoming connections.
# Important Notes
#### This script assumes it is running on an Ubuntu 22.04 server and requires sudo privileges to execute.
#### Ensure that you have backed up any important data on your server before running the script, as it may make significant configuration changes.
#### The script is designed to be idempotent, meaning it can be run multiple times without adverse effects.
