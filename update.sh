apt update -y
apt install htop vim lm-sensors sysbench stress-ng netperf postgresql -y
cp -f htoprc /root/.config/htop/
sensors-detected
