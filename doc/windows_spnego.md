1. Получить логин и пароль от Kerberos.
2. Скачать и установить Kerberos Ticket Manager: [ссылка](https://web.mit.edu/kerberos/dist/kfw/4.1/kfw-4.1-amd64.msi).
3. Создать файл `C:\ProgramData\MIT\Kerberos\krb5.ini` со следующим содержимым:

```ini
[libdefaults]
  default_realm = HADOOP.CONSULTANT.RU

[realms]
  HADOOP.CONSULTANT.RU = {
    admin_server = hadoop-master.consultant.ru
    kdc = hadoop-master.consultant.ru
  }
```

4. Скачать и установить браузер Firefox.
5. Открыть Firefox. Прописать в адресной строке `about:config`.
6. Установить следующие значения для параметров:

```
network.negotiate-auth.delegation-uris  =  http://hadoop-master.consultant.ru
network.negotiate-auth.trusted-uris     =  http://hadoop-master.consultant.ru
network.auth.use-sspi                   =  false
```

7. Перезагрузить компьютер.
8. Запустить Kerberos Ticket Manager. Нажать **Get Ticket**. Ввести логин и пароль от Kerberos. Нажать **OK**.
9. Убедиться, что всё работает, открыв [hadoop-master.consultant.ru:9870](hadoop-master.consultant.ru:9870).
