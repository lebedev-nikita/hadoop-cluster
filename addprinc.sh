service=$1
echo -e "$service\n$service" | kadmin -w password -q "addprinc $service/host1.consultant.ru@CONSULTANT.RU"
echo -e "$service\n$service" | kadmin -w password -q "addprinc $service/host2.consultant.ru@CONSULTANT.RU"
echo -e "$service\n$service" | kadmin -w password -q "addprinc $service/host3.consultant.ru@CONSULTANT.RU"
echo -e "$service\n$service" | kadmin -w password -q "addprinc $service/host4.consultant.ru@CONSULTANT.RU"

# echo -e "airflow\nairflow" | kadmin -w password -q "addprinc airflow/host1.consultant.ru@CONSULTANT.RU"

kadmin:

kvno yarn/host1.consultant.ru@CONSULTANT.RU
kvno yarn/host2.consultant.ru@CONSULTANT.RU
kvno yarn/host3.consultant.ru@CONSULTANT.RU
kvno yarn/host4.consultant.ru@CONSULTANT.RU

kvno hdfs/host1.consultant.ru@CONSULTANT.RU
kvno yarn/host1.consultant.ru@CONSULTANT.RU
kvno mapred/host1.consultant.ru@CONSULTANT.RU
kvno hbase/host1.consultant.ru@CONSULTANT.RU
kvno spark/host1.consultant.ru@CONSULTANT.RU
kvno hive/host1.consultant.ru@CONSULTANT.RU
kvno airflow/host1.consultant.ru@CONSULTANT.RU

kvno hdfs/host1.consultant.ru@CONSULTANT.RU

sudo ktutil:
addent -password -p hdfs/host1.consultant.ru@CONSULTANT.RU -k 1 -e aes256-cts
addent -password -p yarn/host1.consultant.ru@CONSULTANT.RU -k 1 -e aes256-cts
addent -password -p mapred/host1.consultant.ru@CONSULTANT.RU -k 1 -e aes256-cts
addent -password -p hbase/host1.consultant.ru@CONSULTANT.RU -k 1 -e aes256-cts
addent -password -p HTTP/host1.consultant.ru@CONSULTANT.RU -k 1 -e aes256-cts

addent -password -p spark/host1.consultant.ru@CONSULTANT.RU -k 5 -e aes256-cts
addent -password -p hive/host1.consultant.ru@CONSULTANT.RU -k 6 -e aes256-cts
# addent -password -p airflow/host1.consultant.ru@CONSULTANT.RU -k 6 -e aes256-cts

wkt /etc/security/krb5.keytab

sudo chown hadoop:hadoop /etc/security/krb5.keytab
sudo chmod g+r /etc/security/krb5.keytab
