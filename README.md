# Глоссарий

**Control Node** - Машина, на которой установлен и запускается Ansible.  
**Managed Nodes** - Машины, настройка которых осуществляется через Ansible.

> Contorl Node не обязан быть одним из Manged Nodes, но может им быть.

# Несколько кластеров

Данный проект поддерживает управление сразу несколькими кластерами. Например, **dev1**, **prod** и **test**.
Переменные, специфичные для кластера **dev1** (например, список узлов кластера), описаны в файлах <u>[inventory.dev1](./inventory.dev1)</u> и <u>inventory.dev1.password</u>.

> В этом README описываются действия для **dev1** кластера. Действия для **test** и **prod** полностью аналогичны, достаточно заменить слово **dev1** на **test** или **prod** соответственно.

# Первичная настройка Control Node

## Настройка SSH

1. [Убедиться](/doc/ubuntu_ssh.md), что Control Node имеет ssh-доступ Managed Nodes.
2. Убедиться, что подключение к Managed Nodes по ssh происходит к одному и тому же пользователю, и этот пользователь имеет один и тот же пароль. Это BECOME_PASSWORD, его нужно будет использовать в разделе "Настройка Ansible".
3. Убедиться, что пользователь, к которому происходит подключение, имеет право выполнять команду `sudo`.

## Настройка Ansible

1. Установить ansible и make

```bash
sudo apt install -y ansible make
```

2. Установить плагины:

```bash
ansible-galaxy collection install ansible.posix
```

3. Прописать хосты и соответствующие им переменные в [inventory.dev1](./inventory.dev1)
4. Создать в корне проекта файл `inventory.dev1.password` со следующим содержимым, заменив <BECOME_PASSWORD> на пароль пользователя, к которому происходит подключение по ssh

```ini
[all:vars]
ansible_become_password = <BECOME_PASSWORD>

kerberos_password_hdfs = <password>
kerberos_password_yarn = <password>
kerberos_password_mapred = <password>
kerberos_password_hbase = <password>
kerberos_password_spark = <password>
kerberos_password_hive = <password>
kerberos_password_HTTP = <password>
```

## Переменные окружения

Меняя значение ANSIBLE_MODE, можно переключаться между управлением различными кластерами.

```bash
export ANSIBLE_MODE=dev1
export ANSIBLE_INVENTORY=inventory.$ANSIBLE_MODE,inventory.$ANSIBLE_MODE.ports,inventory.$ANSIBLE_MODE.password
```

# Первичная настройка Managed Nodes

```bash
sudo apt install -y python python3
```

# Первичная настройка Kerberos

Этот Ansible-проект не настраивает Kerberos. Инструкция по настройке Kerberos доступна [по ссылке](./doc/kerberos.md#настройка-kdc)

# Переменные

Некоторые плейбуки принимают переменные:

- `services` - список сервисов, к которым будет применяться плейбук. Допустимые элементы списка: "hadoop", "hbase", "spark", "hive". Если переменная не указана, плейбук применится ко всем сервисам.
- `need_format` - флаг, используемый только один раз, при первичной инициализации кластера. Использование этого флага на уже запущенном кластере может привести к потере данных. Значение по умолчанию: false.

# Плейбуки

Не рекомендуется запускать плейбуки вручную. Лучше запускать их, вызывая один из таргетов, описанных в Makefile. Если в Makefile отсутствует подходящий таргет, следует его добавить.

```bash
# Плейбуки запускаются следующей командой:
ansible-playbook <playbook_name>

# В плейбуки можно передавать переменные в формате JSON:
ansible-playbook <playbook_name> -e '{ "services": ["hadoop", "hive", "spark"], "need_format": false }'
```

# Makefile

Таргеты в [Makefile](./Makefile) объединяют несколько последовательных вызовов плейбуков, соответствующих типичному сценарию взаимодействия с кластером.

- `make init` - Инициализировать и запустить hadoop-кластер. Следует использовать при добавлении в кластер новых узлов или других достаточно серьезных изменениях. Перед вызовом скрипта кластер должен быть остановлен.
- `make DANGROUS_start_with_formatting` - Запустить hadoop-кластер с форматированием NameNode. Следует использовать только для первичной установки кластера.
- `make stop` - Остановить hadoop-кластер.
- `make start` - Запустить hadoop-кластер.

Полный список таргетов доступен в [Makefile](./Makefile).

# Сценарии использования

## Установка на пустой кластер

1. `make init`
2. Создать keytab-файлы на каждом хосте ([инструкция](./doc/kerberos.md#создание-keytab-ов))
3. `make DANGROUS_start_with_formatting`

## Апгрейд кластера: Hadoop 2 -> Hadoop 3

1. Остановить кластер Hadoop 2
2. `make init`
3. Создать keytab-файлы на каждом хосте ([инструкция](./doc/kerberos.md#создание-keytab-ов))
4. _[hdfs@hadoop-master]:_ `/opt/dev1/hadoop/sbin/start-dfs -upgrade`
5. Проверить, что HDFS работает корректно
6. _[hdfs@hadoop-master]:_ `/opt/dev1/hadoop/bin/hdfs dfsadmin -finalizeUpgrade`
7. `make start` - запустить остальные сервисы

## Добавить новую машину

1. Добавить в Kerberos недостающих пользователей ([инструкция](./doc/kerberos.md#создание-пользователей))
2. Добавить новый хост в inventory.dev1
3. `make stop`
4. `make init`
5. Создать keytab-файл на новом хосте
6. `make start`

## Копирование данных со старого кластера на новый

Пусть:

- Новый кластер защищен Kerberos и его `core_default_fs_port = 8103`.
- Старый кластер не защищен Kerberos и его `core_default_fs_port = 8203`.
- hdfs-dev1 - пользователь, от имени которого запущен hdfs нового кластера.
- Команды выполняются от имени пользователя hdfs-dev1, расположенного на мастер-хосте кластера.
- В PATH пользователя hdfs-dev1 добавлена директория hadoop/bin нового кластера.

Тогда:

```bash
# Логинимся в Kerberos, если не сделали этого раньше
kinit $(whoami)/$(hostname -f) -kt /etc/security/krb5-dev1.keytab
# Копируем данные
hadoop distcp hdfs://$(hostname -f):8203/file.txt hdfs://$(hostname -f):8103/file.txt
```

# Адреса UI

| Имя сервиса        | url                                                                |
| :----------------- | :----------------------------------------------------------------- |
| HDFS NameNode      | http://host1.consultant.ru:${dfs_namenode_http_port}               |
| YARN UI            | http://host1.consultant.ru:${yarn_resourcemanager_webapp_port}     |
| YARN UI 2          | http://host1.consultant.ru:${yarn_resourcemanager_webapp_port}/ui2 |
| Mapred History     | http://host1.consultant.ru:${mapreduce_jobhistory_webapp_port}     |
| HBASE Master       | http://host1.consultant.ru:${hbase_master_info_port}               |
| Spark History      | http://host1.consultant.ru:${spark_history_ui_port}                |
| Hive Thrift Server | http://host1.consultant.ru:${hive_server2_webui_port}              |

# Адреса API

| Имя сервиса         | url                                                      |
| :------------------ | :------------------------------------------------------- |
| HDFS                | http://host1.consultant.ru:${core_default_fs_port}/      |
| YARN ResouceManager | http://host1.consultant.ru:${yarn_resourcemanager_port}/ |
| HiveServer2         | http://host1.consultant.ru:${hive_server2_thrift_port}/  |
