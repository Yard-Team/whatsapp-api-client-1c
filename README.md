# Демо обработка для работы с WhatsApp из 1С
Репозиторий представляет собой исходники конфигурации в формате выгрузки xml файлов с одной обработкой. Из обработки можно отправить сообщение к себе на WhatsApp. Интеграция с WhatsApp сделана через REST сервис [green-api.com](https://green-api.com/)

Интерфейс обработки

![`Основное окно`](media/main.png)

## Требования
* Платформа 1С не ниже версии 8.3.10
* ``API Token`` и ``ID Instance``, полученные через сервис [green-api.com](https://green-api.com/)

## Сценарий работы

1. Подключиться к сервису [green-api.com](https://green-api.com/) и получить ``API Token`` и ``ID Instance``
1. [Скачать обработку](https://github.com/green-api/whatsapp-1c-example/releases/download/1.0/WhatsApp1cExample.epf) в формате epf
3. Запустить в браузере или тонком клиенте и указать параметры подключения (``API Token`` и ``ID Instance``)
4. Перейти по ссылке генерации QR кода и авторизовать аккаунт
5. Нажать кнопку ``Проверить подключение``
6. Указать телефон получателя и текст соообщения
7. Нажать кнопку ``Отправить``


