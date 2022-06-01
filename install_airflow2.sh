wget https://repo.anaconda.com/archive/Anaconda3-2022.05-Linux-x86_64.sh
sudo chmod +x Anaconda3-2022.05-Linux-x86_64.sh
sudo ./Anaconda3-2022.05-Linux-x86_64.sh
mkdir /opt/airflow
cd /opt/airflow
conda create --name airflow-environment python=3.9
conda activate airflow-environment
export AIRFLOW_HOME=/opt/airflow
cd $AIRFLOW_HOME

sudo apt update &&
sudo apt install -y python-setuptools python3-pip python-dev libffi-dev libssl-dev zip wget
sudo apt install -y gcc python3-dev libcairo2-dev libpango1.0-dev
pip install --upgrade pip setuptools wheel
pip install apache-airflow
sudo pip install gcp
pip install statsd
sudo apt install -y pkg-config libxml2-dev libxmlsec1-dev libxmlsec1-openssl
sudo pip install sentry==2.1.2
pip install cryptography pyspark

airflow users create --role Admin --username admin --email admin --firstname admin --lastname admin --password p234Hbn%%!

# Должно работать:
airflow version
airflow db init
