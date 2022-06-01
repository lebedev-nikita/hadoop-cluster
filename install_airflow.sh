export AIRFLOW_HOME=/opt/airflow

AIRFLOW_VERSION=2.3.2
PYTHON_VERSION="$(python3 --version | cut -d " " -f 2 | cut -d "." -f 1-2)"
CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"
pip3 install "apache-airflow==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"

pip3 uninstall "apache-airflow==${AIRFLOW_VERSION}"

airflow standalone

# Visit localhost:8081 in the browser and use the admin account details
# shown on the terminal to login.
# Enable the example_bash_operator dag in the home page

# /opt/airflow/airflow.cfg:
# web_server_port = 8081

wget https://repo.anaconda.com/archive/Anaconda3-2022.05-Linux-x86_64.sh

# pip install apache-airflow
# pip install --upgrade pip setuptools wheel
sudo apt install -y libcairo2-dev python3-dev
sudo apt-get install -y libpango1.0-dev
# sudo pip install gcp
