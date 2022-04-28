# Глоссарий
**Control Node** - Машина, на которой установлен и запускается Ansible.  
**Managed Nodes** - Машины, настройка которых осуществляется через Ansible.  
> Contorl Node не обязан быть одним из Manged Nodes, но может им быть.

# Первичная настройка Control Node
## Настройка SSH
1. [Убедиться](/doc/ubuntu_ssh.md), что Control Node имеет ssh-доступ Managed Nodes.  
2. Убедиться, что подключение к Managed Nodes по ssh происходит к одному и тому же ползьователю, и этот пользователь имеет один и тот же пароль. Это BECOME-password, его потребуется вводить при запуске скриптов.
3. Убедиться, что пользователь, к которому происходит подключение, имеет право выполнять команду `sudo`.
## Настройка Ansible
1. Установить ansible и make
```bash
sudo apt install ansible
sudo apt install make
```
2. Установить плагины:
```bash
ansible-galaxy collection install ansible.posix community.docker
```
3. Прописать хосты и соответствующие им переменные в [inventory.ini](./inventory.ini)

# Скрипты
`make init` - Инициализирвоать и запустить hadoop-кластер  
`make stop` - Остановить hadoop-кластер  
`make start` - Запустить hadoop-кластер  
`make clean` - Очистить машины  

# Сценарии использования
## Добавить новую машину
1. `make stop`
2. Добавить машину в [inventory.ini](./inventory.ini)
3. `make start` 

## Изменить конфиги
1. `make stop`
2. Изменить соответствующий файл с конфигами в этом проекте
3. `make start` 
4. Закоммитить и запушить изменения

# Адреса веб-сервисов
| Имя сервиса         |  url                               |
| :---                |  :---                              |
| HDFS                |  http://host1:19000/               |
| YARN ResouceManager |  http://host1:8032/                |

# Адреса веб-интерфейсов
| Имя сервиса    |  url                                |
| :---           |  :---                               |
| HDFS NameNode  |  http://host1:9870/                |
| HDFS DataNode  |  http://host2:9864/                |
| YARN Cluster   |  http://host1:8088/cluster         |
| YARN Node      |  http://host2:8042/node            |
| YARN History   |  http://host1:19888/jobhistory     |
| HBASE Master   |  http://host1:16010/master-status  |
| Spark History  |  http://host1:18080                |
| Airflow        |  http://host1:8081                 |
| Flower         |  http://host1:8082                 |

# Логин и пароль Airflow
airflow:airflow
