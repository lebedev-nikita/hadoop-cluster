# Глоссарий

**Control Node** - Машина, на которой установлен и запускается Ansible.  
**Managed Nodes** - Машины, настройка которых осуществляется через Ansible.

> Contorl Node не обязан быть одним из Manged Nodes, но может им быть.

# Первичная настройка Control Node

## Переменные окружения

```bash
export ANSIBLE_MODE=dev
export INVENTORY="-i inventory.$ANSIBLE_MODE -i inventory.$ANSIBLE_MODE.password"
```

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

3. Прописать хосты и соответствующие им переменные в [inventory.ini](./inventory.ini)
4. Создать в корне проекта файл `inventory.password.ini` со следующим содержимым, заменив <BECOME_PASSWORD> на пароль пользователя, к которому происходит подключение по ssh

```ini
[all:vars]
ansible_become_password = <BECOME_PASSWORD>
hive_db_password = hive
```

# Первичная настройка Managed Nodes

```bash
  sudo apt install -y python python3
```

# Переменные

Некоторые плейбуки принимают переменные:

- `services` - список сервисов, к которым будет применяться плейбук. Допустимые элементы списка: "hadoop", "hbase", "spark", "hive". Если переменная не указана, плейбук применится ко всем сервисам.
- `need_format` - флаг, используемый только один раз, при первичной инициализации кластера. Форматирует NameNode. Допустимые значения true, false. Значение по умолчанию: false.

# Плейбуки

```bash
# Плейбуки запускаются следующей командой:
ansible-playbook <playbook_name>

# В плейбуки можно передавать переменные в формате JSON:
ansible-playbook <playbook_name> -e '{ "services": ["hadoop", "hive", "spark"], "need_format": false }'
```

## `_init_hosts`

Плейбук `_init_hosts` подготваливает Managed Nodes к последующей установке сервисов. Также он устанавливает Zookeeper на Managed Nodes из группы zk_hosts (см. [inventory.ini](./inventory.ini)).

## `_download`

Плейбук `download` скачивает и разархивирует дистрибутивы сервисов на каждый Managed Node в директорию /opt.

**Принимает переменные:**

- `services`

## `_configure`

Плейбук `_configure` настраивает скачанные дистрибутивы сервисов, помещая в них файлы файлы конфигурации. Файлы конфигурации генерируются из шаблонов, лежащих в `<service_name>/configure/templates`, путем подстановки переменных, определенных в [inventory.ini](./inventory.ini) и [group_vars](./group_vars/all.yml).

**Принимает переменные:**

- `services`

## `_start`

Плейбук `_start` запускает сервисы.

**Принимает переменные:**

- `services`
- `need_format`

## `_stop`

Плейбук `_stop` останавливает сервисы.

**Принимает переменные:**

- `services`

## `_refresh_queues`

Плейбук `_refresh_queues` позволяет yarn подтянуть очереди из `/opt/hadoop/etc/hadoop/yarn-site.xml` без перезапуска всего кластера.

## `_dangerous_clean`

Плейбук `_dangerous_clean` полностью удаляет все сервисы и данные с кластера. Использовать эту команду в продакшене не рекомендуется.

# Скрипты

Скрипты объединяют несколько последовательных вызовов плейбуков, соответствующих типичному сценарию взаимодействия с кластером. Для более тонкой работы с кластером рекомендуется запускать плейбуки напрямую, как это показано в предыдущем разделе.

- `make dangerous_init_with_formatting` - Инициализировать и запустить hadoop-кластер с форматированием NameNode. Следует использовать только для первичной установки кластера.
- `make init` - Инициализировать и запустить hadoop-кластер. Следует использовать при добавлении в кластер новых узлов или других достаточно серьезных изменениях. Перед вызовом скрипта кластер должен быть остановлен.
- `make stop` - Остановить hadoop-кластер.
- `make start` - Запустить hadoop-кластер.
- `make dangerous_clean` - Очистить машины.

# Сценарии использования

## Добавить новую машину

1. `make stop`
2. Добавить машину в [inventory.ini](./inventory.ini)
3. `make init`

## Изменить конфиги

1. `make stop`
2. Изменить соответствующий файл с конфигами в этом проекте
3. `ansible-playbook _configure.yml`
4. `make start`
5. Закоммитить и запушить изменения

# Адреса UI

| Имя сервиса        | url                |
| :----------------- | :----------------- |
| HDFS NameNode      | http://host1:9870  |
| HDFS DataNode      | http://host2:9864  |
| YARN Cluster       | http://host1:8088  |
| YARN Node          | http://host2:8042  |
| Mapred History     | http://host1:19888 |
| HBASE Master       | http://host1:16010 |
| Spark History      | http://host1:18080 |
| Hive Thrift Server | http://host1:10000 |

# Адреса API

| Имя сервиса         | url                 |
| :------------------ | :------------------ |
| HDFS                | http://host1:19000/ |
| YARN ResouceManager | http://host1:8032/  |
| HiveServer2         | http://host1:10002/ |
