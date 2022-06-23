local realm=$1
local service=@$2
echo addprinc $service/hadoop-master.consultant.ru
echo addprinc $service/hadoop-slave1.consultant.ru
echo addprinc $service/hadoop-slave2.consultant.ru
echo addprinc $service/hadoop-slave3.consultant.ru

kadmin:

sudo ktutil:
addent -password -p hdfs/hadoop-slave1.consultant.ru -k 1 -e aes256-cts
addent -password -p yarn/hadoop-slave1.consultant.ru -k 1 -e aes256-cts
addent -password -p mapred/hadoop-slave1.consultant.ru -k 1 -e aes256-cts
addent -password -p hbase/hadoop-slave1.consultant.ru -k 1 -e aes256-cts

addent -password -p HTTP/hadoop-master.consultant.ru -k 1 -e aes256-cts
addent -password -p spark/hadoop-master.consultant.ru -k 5 -e aes256-cts
addent -password -p hive/hadoop-master.consultant.ru -k 6 -e aes256-cts

wkt /etc/security/krb5.keytab

sudo chown hadoop:hadoop /etc/security/krb5.keytab
sudo chmod g+r /etc/security/krb5.keytab
ll /etc/security/krb5.keytab

kinit hdfs/$(hostname -f) -kt /etc/security/krb5.keytab
