#!/bin/bash
# This script automatically updates the Ansible host inventory

AWSBIN='/usr/local/bin/aws'
ANSIBLE_KNOWN_HOSTS='/etc/ansible/known_hosts'  # Set the Ansible known_hosts file location

awsDiscovery() {
    $AWSBIN ec2 describe-instances --filters Name=tag:aws:autoscaling:groupName,Values=petclinic-stage-asg \
        --query Reservations[*].Instances[*].NetworkInterfaces[*].{PrivateIpAddresses:PrivateIpAddress} > /etc/ansible/stage-ips.list
}

inventoryUpdate() {
    echo "[webservers]" > /etc/ansible/stage-hosts
    while IFS= read -r instance; do
        # Append the host key to the Ansible known_hosts file
        ssh-keyscan -H "$instance" >> "$ANSIBLE_KNOWN_HOSTS"
        echo "$instance ansible_user=ec2-user ansible_ssh_private_key_file=/etc/ansible/key.pem" >> /etc/ansible/stage-hosts
    done < /etc/ansible/stage-ips.list
}

instanceUpdate() {
    sleep 30
    ansible-playbook /etc/ansible/stage-trigger.yml --extra-vars ansible_python_interpreter=/usr/bin/python3.9
    sleep 30
}

awsDiscovery
inventoryUpdate
instanceUpdate