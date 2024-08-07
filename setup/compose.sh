#!/bin/bash
. ../config.sh

# Introduced in 1-4.3
execute_with_spinner "sudo curl -L https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/bin/docker-compose"
execute_with_spinner "sudo chmod +x /usr/bin/docker-compose"