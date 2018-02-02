# Install LIS
#rpm -e hyperv-daemons
#rpm -e hypervfcopyd
#rpm -e hypervkpd
#rpm -e hypervvssd
#rpm -e hyperv-daemons-license

# LIS 4.2 
# https://www.microsoft.com/en-us/download/details.aspx?id=55106
#
# TODO: Need to automate installation of LIS
# ./install.sh

#reboot

# Disable Swap
cat /proc/swaps
echo "disabling swap"
awk '/swap/{$0="#"$0} 1' /etc/fstab >/etc/fstab.tmp && mv /etc/fstab.tmp /etc/fstab
sudo swapoff -a
sudo sysctl vm.swappiness=0
cat /proc/swaps