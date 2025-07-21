# Nginx Environment Provisioner

This is a shell script created to automate the setup of a new developer environment on an Ubuntu/Debian server.

## What it Does

When run, the script automatically performs the following actions:
- Creates a new system user and group.
- Creates a dedicated web project directory under `/var/www/`.
- Sets secure ownership and permissions for the directory.
- Installs and configures the Nginx web server.
- Creates a custom Nginx server block for the new project.
- Enables the new site and restarts Nginx.

## How to Use

1.  Make the script executable: `chmod +x provision.sh`
2.  Run the script with sudo privileges, providing a username and a project name:
    `sudo ./provision.sh <username> <project_name>`
3.  Example: `sudo ./provision.sh dev1 my-first-app`
