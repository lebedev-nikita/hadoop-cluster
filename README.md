# Глоссарий

**Control Node** - Машина, на которой установлен и запускается Ansible.  
**Managed Nodes** - Машины, настройка которых осуществляется через Ansible.

> Contorl Node не обязан быть одним из Manged Nodes, но может им быть.

# Несколько кластеров

Данный проект поддерживает управление сразу несколькими кластерами. Например, **dev**, **prod** и **test**.
Переменные, специфичные для кластера **dev** (например, список узлов кластера), описаны в файлах <u>[inventory.dev](./inventory.dev)</u> и <u>inventory.dev.password</u>.

> В этом README описываются действия для **dev** кластера. Действия для **test** и **prod** полностью аналогичны, достаточно заменить слово **dev** на **test** или **prod** соответственно.

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

3. Прописать хосты и соответствующие им переменные в [inventory.dev](./inventory.dev)
4. Создать в корне проекта файл `inventory.dev.password` со следующим содержимым, заменив <BECOME_PASSWORD> на пароль пользователя, к которому происходит подключение по ssh

```ini
[all:vars]
ansible_become_password = <BECOME_PASSWORD>
```

## Переменные окружения

Меняя значение ANSIBLE_MODE, можно переключаться между управлением различными кластерами.

```bash
export ANSIBLE_MODE=dev
export ANSIBLE_INVENTORY=inventory.$ANSIBLE_MODE,inventory.$ANSIBLE_MODE.password
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
4. _[hdfs@hadoop-master]:_ `/opt/hadoop/sbin/start-dfs -upgrade`
5. Проверить, что HDFS работает корректно
6. _[hdfs@hadoop-master]:_ `/opt/hadoop/bin/hdfs dfsadmin -finalizeUpgrade`
7. `make start` - запустить остальные сервисы

## Добавить новую машину

1. Добавить в Kerberos недостающих пользователей ([инструкция](./doc/kerberos.md#создание-пользователей))
2. Добавить новый хост в inventory.dev
3. `make stop`
4. `make init`
5. Создать keytab-файл на новом хосте
6. `make start`

# Адреса UI

| Имя сервиса        | url                                   |
| :----------------- | :------------------------------------ |
| HDFS NameNode      | http://host1.consultant.ru:9870       |
| HDFS DataNode      | http://host2.consultant.ru:9864       |
| YARN UI            | http://host1.consultant.ru:8088       |
| YARN UI 2          | http://host1.consultant.ru:8088/ui2   |
| YARN Node          | http://host2.consultant.ru:8042       |
| Mapred History     | http://host1.consultant.ru:19888      |
| HBASE Master       | http://host1.consultant.ru:16010      |
| Spark History      | http://host1.consultant.ru:18080      |
| Hive Thrift Server | http://host1.consultant.ru:10000      |
| NiFi               | http://host1.consultant.ru:8443/nifi/ |

# Адреса API

| Имя сервиса         | url                               |
| :------------------ | :-------------------------------- |
| HDFS                | http://host1.consultant.ru:19000/ |
| YARN ResouceManager | http://host1.consultant.ru:8032/  |
| HiveServer2         | http://host1.consultant.ru:10002/ |
