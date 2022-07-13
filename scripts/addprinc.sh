#!/bin/bash
# usage: ./addprinc.sh host1 host2 host3 host4

hosts=$@

read -p "admin password: " admin_password

while :
do
  read -p "Service: "  service
  read -p "Password: " password
  for host in $hosts
  do
    printf "$admin_password\n$password\n$password" | 
      kadmin -q "addprinc $service/$host"
  done
done
