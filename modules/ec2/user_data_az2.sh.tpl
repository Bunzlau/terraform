#!/bin/bash
# Install Python3/Flask/boto3 and run a Flask app that displays AWS Secrets Manager + SSM params
set -e

APP_DIR="/opt/aws-data-app"
APP_FILE="$APP_DIR/app.py"
SERVICE_FILE="/etc/systemd/system/aws-data-app.service"

# -- Install Python3 + pip ---------------------------------------------------
if command -v yum >/dev/null 2>&1; then
  yum update -y
  yum install -y python3 python3-pip
elif command -v apt-get >/dev/null 2>&1; then
  apt-get update -y
  apt-get install -y python3 python3-pip
fi

mkdir -p "$APP_DIR"

# -- Write Flask app ---------------------------------------------------------
# NOTE: heredoc is unquoted so Terraform templatefile() substitutes $${var} -> var value.
# Python f-string braces are doubled {{}} so Terraform does NOT interpret them.
cat > "$APP_FILE" <<PYEOF
import boto3
from flask import Flask
from botocore.exceptions import ClientError
import socket
import urllib.request

app = Flask(__name__)

REGION         = "${region}"
PROJECT_NAME   = "${project_name}"
ENVIRONMENT    = "${environment}"
AZ             = "${az}"
HTTP_PORT      = "${http_port}"
SECRET_NAME    = "secrert-manager-test"
PARAMETER_NAME = "test-parameter"
INSTANCE_COLOR = "#2e7d32"  # green for AZ2
INSTANCE_LABEL = "INSTANCE 2 - AZ2"

def get_instance_id():
    try:
        req = urllib.request.Request(
            "http://169.254.169.254/latest/meta-data/instance-id",
            headers={"X-aws-ec2-metadata-token-ttl-seconds": "21600"}
        )
        return urllib.request.urlopen(req, timeout=2).read().decode()
    except Exception:
        return "unavailable"

def get_secret():
    client = boto3.client("secretsmanager", region_name=REGION)
    try:
        response = client.get_secret_value(SecretId=SECRET_NAME)
        return response.get("SecretString", "(SecretString is empty)")
    except ClientError as e:
        return "Error fetching secret: " + str(e)

def get_parameter():
    client = boto3.client("ssm", region_name=REGION)
    try:
        response = client.get_parameter(Name=PARAMETER_NAME)
        return response["Parameter"]["Value"]
    except ClientError as e:
        return "Error fetching parameter: " + str(e)

@app.route("/")
def index():
    secret      = get_secret()
    parameter   = get_parameter()
    hostname    = socket.gethostname()
    instance_id = get_instance_id()
    html = """
    <!doctype html>
    <html>
      <head>
        <meta charset="utf-8">
        <title>${project_name} - ${environment} - ${az}</title>
        <style>
          body { font-family: Arial, sans-serif; margin: 0; padding: 0; }
          .banner { background: """ + INSTANCE_COLOR + """; color: white; padding: 20px 30px; font-size: 1.4em; font-weight: bold; letter-spacing: 1px; }
          .content { padding: 20px 30px; }
          ul { line-height: 2; }
        </style>
      </head>
      <body>
        <div class="banner">""" + INSTANCE_LABEL + """ &nbsp;|&nbsp; ${project_name} - ${environment}</div>
        <div class="content">
          <h2>Instance info</h2>
          <ul>
            <li><b>Instance ID:</b>  """ + instance_id + """</li>
            <li><b>Hostname:</b>     """ + hostname + """</li>
            <li><b>AZ:</b>           ${az}</li>
            <li><b>Region:</b>       ${region}</li>
            <li><b>Environment:</b>  ${environment}</li>
            <li><b>Project:</b>      ${project_name}</li>
            <li><b>HTTP port:</b>    ${http_port}</li>
          </ul>
          <h2>AWS parameters</h2>
          <p><b>Secret from Secrets Manager:</b> """ + secret + """</p>
          <p><b>Parameter from SSM:</b>          """ + parameter + """</p>
        </div>
      </body>
    </html>
    """
    return html

@app.route("/health")
def health():
    return "ok", 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(HTTP_PORT))
PYEOF

# -- Install Python libs -----------------------------------------------------
python3 -m pip install --upgrade pip --quiet
python3 -m pip install flask boto3 botocore --quiet

# -- systemd service ---------------------------------------------------------
cat > "$SERVICE_FILE" <<SVCEOF
[Unit]
Description=AWS Data Flask App
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
WorkingDirectory=/opt/aws-data-app
ExecStart=/usr/bin/python3 /opt/aws-data-app/app.py
Restart=always
RestartSec=3
User=root
Environment=PYTHONUNBUFFERED=1

[Install]
WantedBy=multi-user.target
SVCEOF

systemctl daemon-reload
systemctl enable aws-data-app
systemctl restart aws-data-app

# -- Optional: Mount EFS if filesystem id is provided -----------------------
if [ -n "${efs_file_system_id}" ] && [ "${efs_file_system_id}" != "" ]; then
  echo "[user-data] EFS file system id provided: ${efs_file_system_id}. Attempting to mount to ${efs_mount_point}" >> /var/log/user-data-efs.log
  MOUNT_POINT="${efs_mount_point}"
  mkdir -p "$MOUNT_POINT"

  if command -v yum >/dev/null 2>&1; then
    if ! yum list installed -q amazon-efs-utils >/dev/null 2>&1; then
      yum install -y amazon-efs-utils || yum install -y nfs-utils
    fi
  elif command -v apt-get >/dev/null 2>&1; then
    apt-get update -y
    apt-get install -y amazon-efs-utils nfs-common || apt-get install -y nfs-common
  fi

  if [ -n "${efs_access_point_id}" ] && [ "${efs_access_point_id}" != "" ]; then
    echo "${efs_file_system_id}:/ $MOUNT_POINT efs tls,accesspoint=${efs_access_point_id},_netdev 0 0" >> /etc/fstab
  else
    echo "${efs_file_system_id}:/ $MOUNT_POINT efs defaults,_netdev 0 0" >> /etc/fstab
  fi

  mount -a || (sleep 5 && mount -a)
  if mountpoint -q "$MOUNT_POINT"; then
    echo "[user-data] EFS mounted at $MOUNT_POINT" >> /var/log/user-data-efs.log
  else
    echo "[user-data] Failed to mount EFS ${efs_file_system_id} at $MOUNT_POINT" >> /var/log/user-data-efs.log
  fi
fi
