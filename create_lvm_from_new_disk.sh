ls /sys/class/scsi_host/ > hosts.txt
for line in $(cat hosts.txt)
do
echo "- - -">/sys/class/scsi_host/$line/scan
done
fdisk -l
read -p "Input Diskname: " diskname 
(echo p; echo n; echo p; echo ""; echo "";  echo ""; echo p; echo w) | fdisk /dev/$diskname
partprobe
diskname1="${diskname}1"
pvcreate /dev/$diskname1
pvdisplay
read -p "Input Virtual Group Name: " vgname
vgcreate $vgname /dev/$diskname1
read -p "Input Logical Volume Name: " lvname
read -p "Input Size of Logical Volume: " disksize
lvcreate -n $lvname -L +$disksize $vgname
echo Input which filesystem to use
read filesystem
mkfs.$filesystem /dev/$vgname/$lvname
