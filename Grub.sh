#!/bin/bash

sed -i "s/\(GRUB_DEFAULT *= *\).*/\1saved/" /etc/default/grub
sed -i "s/\(GRUB_TIMEOUT *= *\).*/\1-1/" /etc/default/grub

grep -q -F 'GRUB_SAVEDEFAULT=true' /etc/default/grub || echo 'GRUB_SAVEDEFAULT=true' >> /etc/default/grub

echo "File /etc/default/grub modified."

grep -q -F 'menuentry "Debian" {' /etc/grub.d/40_custom || cat << EOF >> /etc/grub.d/40_custom

menuentry "Debian" {
        chainloader (hd0,2)+1 # oppure msdos2
}
EOF

grep -q -F 'menuentry "Kali" {' /etc/grub.d/40_custom || cat << EOF >> /etc/grub.d/40_custom

menuentry "Kali" {
        chainloader (hd0,3)+1 # oppure msdos2
}
EOF

echo "File /etc/grub.d/40_custom modified."

chmod +x /etc/grub.d/00_header /etc/grub.d/05_debian_theme /etc/grub.d/40_custom
chmod -x /etc/grub.d/10_linux /etc/grub.d/20_linux_xen /etc/grub.d/30_os-prober /etc/grub.d/30_uefi-firmware /etc/grub.d/41_custom

mount /dev/sda1 /boot

grub-install /dev/sda
update-grub

umount /boot

chmod +x /etc/grub.d/00_header /etc/grub.d/05_debian_theme /etc/grub.d/10_linux /etc/grub.d/20_linux_xen /etc/grub.d/41_custom
chmod -x /etc/grub.d/30_os-prober /etc/grub.d/30_uefi-firmware /etc/grub.d/40_custom

# update-grub # not always needed
