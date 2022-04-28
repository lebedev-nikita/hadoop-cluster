1. Установить ansible
```bash
sudo apt install ansible
```
2. Установить плагины:
```bash
ansible-galaxy collection install ansible.posix community.docker
```
3. Настроить ssh-подключение ко всем хостам, где будут развернуты сервисы
4. Прописать хосты и соответствующие им переменные в [inventory.ini](./inventory.ini)
5. Запустить установку:
```bash
make init
```
