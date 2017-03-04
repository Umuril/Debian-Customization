#!/bin/bash
grub-install --force /dev/sda3

sed -i "s/\(GRUB_DEFAULT *= *\).*/\1saved/" /etc/default/grub
sed -i "s/\(GRUB_TIMEOUT *= *\).*/\1-1/" /etc/default/grub

grep -q -F 'GRUB_SAVEDEFAULT=true' /etc/default/grub || echo 'GRUB_SAVEDEFAULT=true' >> /etc/default/grub

echo "File /etc/default/grub modified."

cat > /etc/grub.d/40_custom << 'EOF'
#!/bin/sh
exec tail -n +3 $0
# This file provides an easy way to add custom menu entries.  Simply type the
# menu entries you want to add after this comment.  Be careful not to change
# the 'exec tail' line above.

menuentry "Debian" {
	set root=(hd0,msdos3)
        chainloader +1
}

menuentry "Kali" {
	set root=(hd0,msdos4)
        chainloader +1
}
EOF

echo "File /etc/grub.d/40_custom modified."

sync

chmod +x /etc/grub.d/00_header /etc/grub.d/05_debian_theme /etc/grub.d/40_custom
chmod -x /etc/grub.d/10_linux /etc/grub.d/20_linux_xen /etc/grub.d/30_os-prober /etc/grub.d/30_uefi-firmware /etc/grub.d/41_custom

mount /dev/sda1 /boot

grub-install /dev/sda
grub-install --recheck /dev/sda
update-grub

umount /boot

chmod +x /etc/grub.d/00_header /etc/grub.d/05_debian_theme /etc/grub.d/10_linux /etc/grub.d/20_linux_xen /etc/grub.d/41_custom
chmod -x /etc/grub.d/30_os-prober /etc/grub.d/30_uefi-firmware /etc/grub.d/40_custom

sed -i "s/\(GRUB_TIMEOUT *= *\).*/\13/" /etc/default/grub

update-grub

sync
