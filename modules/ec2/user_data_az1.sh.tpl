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

# Optional: Mount EFS if filesystem id is provided
if [ -n "${efs_file_system_id}" ] && [ "${efs_file_system_id}" != "" ]; then
  echo "[user-data] EFS file system id provided: ${efs_file_system_id}. Attempting to mount to ${efs_mount_point}" >> /var/log/user-data-efs.log
  MOUNT_POINT="${efs_mount_point}"
  mkdir -p "$MOUNT_POINT"

  # Install efs-utils when available, fall back to nfs client
  if command -v yum >/dev/null 2>&1; then
    if ! yum list installed -q amazon-efs-utils >/dev/null 2>&1; then
      yum install -y amazon-efs-utils || yum install -y nfs-utils
    fi
  elif command -v apt-get >/dev/null 2>&1; then
    apt-get update -y
    apt-get install -y amazon-efs-utils nfs-common || apt-get install -y nfs-common
  fi

  # Build fstab entry. Prefer access point if provided, use TLS when efs-utils present
  if [ -n "${efs_access_point_id}" ] && [ "${efs_access_point_id}" != "" ]; then
    # Use access point mount (requires efs-utils supporting accesspoint option)
    echo "${efs_file_system_id}:/ $MOUNT_POINT efs tls,accesspoint=${efs_access_point_id},_netdev 0 0" >> /etc/fstab
  else
    # Standard EFS mount
    echo "${efs_file_system_id}:/ $MOUNT_POINT efs defaults,_netdev 0 0" >> /etc/fstab
  fi

  # Try to mount (retry once if first attempt fails)
  mount -a || (sleep 5 && mount -a)
  if mountpoint -q "$MOUNT_POINT"; then
    echo "[user-data] EFS mounted at $MOUNT_POINT" >> /var/log/user-data-efs.log
  else
    echo "[user-data] Failed to mount EFS ${efs_file_system_id} at $MOUNT_POINT" >> /var/log/user-data-efs.log
  fi
fi
