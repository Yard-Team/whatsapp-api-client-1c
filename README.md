# Демо обработка для работы с WhatsApp из 1С
Репозиторий представляет собой исходники конфигурации в формате выгрузки xml файлов с одной обработкой. Из обработки можно отправить сообщение к себе на WhatsApp. Интеграция с WhatsApp сделана через REST сервис [basis-api.com](https://basis-api.com/)

## Требования
* Для запуска обработки нужна Платформа 1С не ниже версии 8.3.10.
* Для загрузки исходников нужно Платформа 1С не ниже версии 8.3.16.1063

## Сценарии работы


## Подключение к сервису basis-api
1. [Скачать обработку](https://github.com/basis-api/whatsapp-1c-example/releases/download/1.0/BasisAPI.epf) в формате epf
2. Подключиться к сервису через встроенный в обработку помощник или  самостоятельно через сайт [basis-api.com](https://basis-api.com/). Получить ``API Token`` и ``ID Instance``
3. Запустить в браузере или тонком клиенте и указать параметры подключения (``API Token`` и ``ID Instance``)
4. Сканировать QR код с мобильного телефона WhatsApp (Меню чаты -> Иконка всех функций -> WhatsApp Web)
6. В форме обработки нажать кнопку ``Проверить подключение / Сканировать QR Код``. Поле формы статус должно изменится на "Подключен"

![`Отправка сообщения`](media/Login.png)

## Отправка сообщения
![`Отправка сообщения`](media/Sending.png)
1. Подключиться к сервису (см. выше п.1)
2. Перейти на вкладку ``Отправка сообщений``
2. Указать телефон получателя и текст соообщения
7. Нажать кнопку ``Отправить текст``

## Получение сообщения
![`Получение сообщения`](media/Receiving.png)
1. Отправить тестовое сообщение (см. выше п.2)
2. Перейти на вкладку ``Получение сообщений``
3. Нажать на кнопку ``Получить сообщенние``. Если сообщение было отправлено, то поле ``Тело сообщения`` заполнится данными в формате JSON. Если нет отправленных сообщенимй - то обработка будет ждать 20 секунд для получения сообщения.

## Использование обработки в собственных конфигурациях

Обработка имеет программный интерфейс, оформленный в соответствии со [стандартами разработки 1С](https://its.1c.ru/db/v8std). Вы можете встроить ее в свою конфигурацию и вызывать АПИ на сервере через создание объекта. Пример использования:

### Отправка сообщения в чат

```bsl
АПИ = Обработки.BasisAPI.Создать();
АПИ.IdInstance = "ВАШ_ИНСТАНС";
АПИ.ApiToken = "ВАШ_ТОКЕН";
Ответ = АПИ.ОтправитьТекст("79001234567", "Hello"); 
```

### Отправка сообщения в группу 

```bsl
АПИ = Обработки.BasisAPI.Создать();
АПИ.IdInstance = "ВАШ_ИНСТАНС";
АПИ.ApiToken = "ВАШ_ТОКЕН";
Ответ = АПИ.ОтправитьТекстВГруппу("79001234567-1615394251@g.us", "Hello"); 
```


## Установка обработки из исходников

Исходники в репозитории - это xml выгрузка из конфигуратора 1С версии 8.3.16 в режиме совместимости с 8.3.10. Скачайте исходники с репозитория и загрузите в конфигуратор с помощью команды ``Конфигурация`` -> ``Загрузить конфигурацию из файлов``
