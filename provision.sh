#!/bin/bash
 	
	USERNAME=$1
	PROJECT_NAME=$2
	WEB_ROOT_DIR="/var/www"
	PROJECT_DIR="${WEB_ROOT_DIR}/${PROJECT_NAME}"
	#  Check if  the  user provided the arguments
	if [ -z "$USERNAME" ] || [ -z "$PROJECT_NAME" ]; then
	echo "ERROR: Missing Aruguments."
	echo "USAGE: $0 <username> <project_name>"
	exit 1
fi

	echo "--- Starting provisioning for user \"$USERNAME\" and project \"$PROJECT_NAME\"---"

	echo "--> Creating user and group \"$USERNAME\"..."
	sudo groupadd $USERNAME
	sudo useradd --system --no-create-home -g $USERNAME $USERNAME
	echo "--> User and group created."

	echo "--> Create project directory: $PROJECT_DIR..."
	sudo mkdir -p $PROJECT_DIR
	sudo chown -R $USERNAME:$USERNAME $PROJECT_DIR
	sudo chmod  -R 750 $PROJECT_DIR
	echo "--> Directory created and permission set."

	echo "--> Installing and configuring Nginx..."
	sudo apt-get update > /dev/null 2>&1
	sudo apt-get install nginx -y > /dev/null 2>&1

	sudo cat <<EOF > ${PROJECT_DIR}/index.html
	<html>
	  <head> 
		<title>Welcome to ${PROJECT_NAME}</title>
	  </head>
	<body>
		<h1>Success!</h1>
		<p>The ${PROJECT_NAME} project enviroment for ${USERNAME} is ready.</p>
	</body>
	</html>
	<<EOF

    sudo cat <<EOF > /etc/nginx/sites-available/${PROJECT_NAME}
	listen 80;
	server_name ${PROJECT_NAME}.local;
	# We'll use curl to test this


	root ${PROJECT_DIR};
	index index.html;
	
	location / {
				try_files \$uri \$uri/ =404;
	}
}
EOF

	sudo systemctl enable nginx
	sudo systemctl restart nginx
	echo "--> Nginx configured and restarted."

	echo "---Provisioning complete ---"
	echo "You can test the site by running:"
	echo "curl -H \"Host:
	${PROJECT_NAME}.local\"
	http://127.0.0.1"	
