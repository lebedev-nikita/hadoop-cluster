FROM apache/airflow:2.2.5-python3.9

USER root
RUN apt-get update -y
RUN apt-get install -y libsasl2-dev libsasl2-2 libsasl2-modules-gssapi-mit build-essential

USER airflow
RUN pip install \
  airflow-code-editor \
  apache-airflow-providers-apache-hive \
  apache-airflow-providers-apache-spark \
  apache-airflow-providers-postgres
