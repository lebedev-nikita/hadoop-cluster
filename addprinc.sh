service=$1
echo addprinc $service/hadoop-master.consultant.ru@HADOOP.CONSULTANT.RU
echo addprinc $service/hadoop-slave1.consultant.ru@HADOOP.CONSULTANT.RU
echo addprinc $service/hadoop-slave2.consultant.ru@HADOOP.CONSULTANT.RU
echo addprinc $service/hadoop-slave3.consultant.ru@HADOOP.CONSULTANT.RU

# echo -e "airflow\nairflow" | kadmin -w password -q "addprinc airflow/host1.consultant.ru@HADOOP.CONSULTANT.RU"

kadmin:

kvno yarn/hadoop-master.consultant.ru@HADOOP.CONSULTANT.RU
kvno yarn/hadoop-slave1.consultant.ru@HADOOP.CONSULTANT.RU
kvno yarn/hadoop-slave2.consultant.ru@HADOOP.CONSULTANT.RU
kvno yarn/hadoop-slave3.consultant.ru@HADOOP.CONSULTANT.RU

kvno hdfs/host1.consultant.ru@HADOOP.CONSULTANT.RU
kvno yarn/host1.consultant.ru@HADOOP.CONSULTANT.RU
kvno mapred/host1.consultant.ru@HADOOP.CONSULTANT.RU
kvno hbase/host1.consultant.ru@HADOOP.CONSULTANT.RU
kvno spark/host1.consultant.ru@HADOOP.CONSULTANT.RU
kvno hive/host1.consultant.ru@HADOOP.CONSULTANT.RU
kvno airflow/host1.consultant.ru@HADOOP.CONSULTANT.RU

kvno hdfs/host1.consultant.ru@HADOOP.CONSULTANT.RU

sudo ktutil:
addent -password -p hdfs/hadoop-slave1.consultant.ru@HADOOP.CONSULTANT.RU -k 1 -e aes256-cts
addent -password -p yarn/hadoop-slave1.consultant.ru@HADOOP.CONSULTANT.RU -k 1 -e aes256-cts
addent -password -p mapred/hadoop-slave1.consultant.ru@HADOOP.CONSULTANT.RU -k 1 -e aes256-cts
addent -password -p hbase/hadoop-slave1.consultant.ru@HADOOP.CONSULTANT.RU -k 1 -e aes256-cts

addent -password -p HTTP/hadoop-master.consultant.ru@HADOOP.CONSULTANT.RU -k 1 -e aes256-cts
addent -password -p spark/hadoop-master.consultant.ru@HADOOP.CONSULTANT.RU -k 5 -e aes256-cts
addent -password -p hive/hadoop-master.consultant.ru@HADOOP.CONSULTANT.RU -k 6 -e aes256-cts
# addent -password -p airflow/hadoop-master.consultant.ru@HADOOP.CONSULTANT.RU -k 6 -e aes256-cts

wkt /etc/security/krb5.keytab

sudo chown hadoop:hadoop /etc/security/krb5.keytab
sudo chmod g+r /etc/security/krb5.keytab
ll /etc/security/krb5.keytab

kinit hdfs/$(hostname -f)@HADOOP.CONSULTANT.RU -kt /etc/security/krb5.keytab
