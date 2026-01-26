#!/bin/bash
# Install and start httpd, write a simple index.html for AZ1
set -e

# Ensure package metadata is up-to-date and install httpd
if command -v yum >/dev/null 2>&1; then
  yum update -y
  yum install -y httpd
  systemctl enable httpd
  systemctl start httpd
elif command -v apt-get >/dev/null 2>&1; then
  apt-get update -y
  apt-get install -y apache2
  systemctl enable apache2
  systemctl start apache2
fi

cat > /var/www/html/index.html <<'EOF'
<!doctype html>
<html>
  <head><meta charset="utf-8"><title>${project_name} - ${environment} - ${az}</title></head>
  <body>
    <h1>${project_name} - ${environment} (${az})</h1>
    <p>Provisioned by Terraform (user-data file: AZ1)</p>
    <p>HTTP port: ${http_port}</p>
    <p>Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>
    <p>Availability zone: $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</p>
  </body>
</html>
EOF

