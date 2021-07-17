#!/bin/bash

# Set MLFS root
echo "[Configuration Files]"

echo "Input MLFS Root: " 
	read MLFS_ROOT
echo "Setting up MLFS Root"

echo "Creating /etc/passwd..."
cat > ${MLFS_ROOT}/etc/passwd << "EOF"
root::0:0:root:/root:/bin/ash
EOF
echo "Creating /etc/group..."
cat > ${MLFS_ROOT}/etc/group << "EOF"
root:x:0:
bin:x:1:
sys:x:2:
kmem:x:3:
tty:x:4:
daemon:x:6:
disk:x:8:
dialout:x:10:
video:x:12:
utmp:x:13:
usb:x:14:
EOF
