#!/bin/bash
set -e

echo "⚙️ Creating Webmin users..."

# Passwords hashed using Webmin's crypt-compatible format
# You can generate your own with: perl -e 'print crypt("mypassword", "salt")'
ADMIN_PASS=$(perl -e 'print crypt("adminpass", "ab")')
LIMITED_PASS=$(perl -e 'print crypt("limitedpass", "cd")')
READONLY_PASS=$(perl -e 'print crypt("readonlypass", "ef")')

# Add users to miniserv.users (username: hashed-pass:real-name:0)
echo "adminuser:$ADMIN_PASS:Admin User:0" >> /etc/webmin/miniserv.users
echo "limiteduser:$LIMITED_PASS:Limited User:0" >> /etc/webmin/miniserv.users
echo "readonly:$READONLY_PASS:ReadOnly User:0" >> /etc/webmin/miniserv.users

# Configure ACLs
echo "adminuser: *" >> /etc/webmin/webmin.acl
echo "limiteduser: system file" >> /etc/webmin/webmin.acl
echo "readonly: file" >> /etc/webmin/webmin.acl

echo "✅ Webmin users created successfully"
