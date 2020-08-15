﻿

#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПодготовитьНастройки();
	УправлениеФормой(ЭтотОбъект)
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Попытка
		ОбновитьСтатусСервиса();
	Исключение
		Сообщить(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	УправлениеФормой(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРеквизитовКомандФормы

&НаКлиенте
Процедура IdInstanceПриИзменении(Элемент)
	УправлениеФормой(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ApiTokenПриИзменении(Элемент)
	УправлениеФормой(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтатус(Команда)
	
	ОбновитьСтатусСервиса();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключение(Команда)
	ОбновитьСтатусСервиса();
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьСообщение(Команда)
	
	Если Не ЗначениеЗаполнено(НомерТелефона) Тогда
		Сообщить("Номер телефона не заполнен");
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТекстСообщения) Тогда
		Сообщить("Текст сообщения не заполнен");
		Возврат;
	КонецЕсли;
	
	ОтправитьСообщениеWhatsApp(Хост, IdInstance, ApiToken, НомерТелефона, ТекстСообщения);
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСообщениеЧерезВебхук(Команда)
	ТекстПолученноеСообщение = "";
	ПОлученноеСообщение = ПолучитьСообщение(IdInstance, ApiToken);
	
	Если ПОлученноеСообщение = Неопределено Тогда
		Сообщить("Не сообщений для получения");
	Иначе
		ТекстПолученноеСообщение = ПОлученноеСообщение;
		УдалитьСообщение(IdInstance, ApiToken, receiptIdТекущий);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СканироватьQRКодКоманда(Команда)
	
	Если ЭтотОбъект.ПроверитьЗаполнение() Тогда

		ОтключитьОбработчикОжидания("Подключаемый_СканироватьQRКод");
		Подключаемый_СканироватьQRКод();
		ПодключитьОбработчикОжидания("Подключаемый_СканироватьQRКод", 5);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_СканироватьQRКод() Экспорт
	
	Элементы.QRКод.Видимость = Ложь;
	
	Ответ = СканироватьQRКод(Хост, IdInstance, ApiToken);
	
	Если Ответ = Неопределено Тогда
		Сообщить("Непредвиденная ошибка");
		Возврат;
	КонецЕсли;
	
	СтатусQRКода = Ответ.type;
	
	Если Ответ.type = "AlreadyLogged" Тогда
		ОтключитьОбработчикОжидания("Подключаемый_СканироватьQRКод");
		ОбновитьСтатусСервиса();
	ИначеЕсли Ответ.type = "qrCode" Тогда
		QRКод = ПолучитьТекстИзМакета("Test");
		QRКод = СтрЗаменить(QRКод, "%QR_DATA%", Ответ.message);
		Элементы.QRКод.Видимость = Истина;
	Иначе
		ОбновитьСтатусСервиса();
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ОбновитьСтатусСервиса()
	
	Если ЭтотОбъект.ПроверитьЗаполнение() Тогда
		СтатусСервиса = ПолучитьСтатусСервиса(Хост, IdInstance, ApiToken);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьНастройки()
	
	Хост = ХостПоУмолчанию();
	ТекстСообщения = "Hello world!";
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьПоказСсылки(КодВозврата, ДопПараметры) Экспорт
	// Логика не требуется
КонецПроцедуры

&НаСервере
Функция ПолучитьТекстИзМакета(ИмяМакета)
	Об = РеквизитФормыВЗначение("Объект");
	ОбластьМакета = Об.ПолучитьМакет("QRМакет");
	Возврат ОбластьМакета.ТекущаяОбласть.Текст;
КонецФункции

#КонецОбласти

#Область GreeAPI

&НаКлиентеНаСервереБезКонтекста
Функция ХостПоУмолчанию()
	Возврат "api.green-api.com";
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция URLСканированиеQRКода(Хост, Инстанс, Токен)
	Возврат СтрШаблон("https://%1/waInstance%2/%3", Хост, Инстанс, Токен);
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция URLМетодаСервиса(Инстанс, Токен, Метод)
	Возврат СтрШаблон("waInstance%1/%2/%3", Инстанс, Метод, Токен);
КонецФункции

&НаКлиенте
Функция СканироватьQRКод(Хост, Инстанс, Токен)
	
	Возврат ОтправитьGETЗапрос(Хост, URLМетодаСервиса(Инстанс, Токен, "qr"), Истина);
	
КонецФункции

&НаКлиенте
Функция ПолучитьСтатусСервиса(Хост, Инстанс, Токен)
	
	Ответ = ОтправитьGETЗапрос(Хост, URLМетодаСервиса(Инстанс, Токен, "getStateInstance"), Истина);
	Возврат НРег(Ответ.stateInstance) = "authorized";
	
КонецФункции

&НаКлиенте
Функция ОтправитьСообщениеWhatsApp(Хост, Инстанс, Токен, Телефон, Сообщение)
	
	Структура = Новый Структура;
	Структура.Вставить("chatId", "");
	Структура.Вставить("phoneNumber", Телефон);
	Структура.Вставить("message", Сообщение);
	Запись = Новый ЗаписьJSON();
	Запись.УстановитьСтроку();
	ЗаписатьJSON(Запись, Структура);
	Тело = Запись.Закрыть();
	
	Ответ = ОтправитьPOSTЗапрос(Хост, URLМетодаСервиса(Инстанс, Токен, "sendMessage"), Тело);
	Сообщить(СтрШаблон("Сообщение отправлено успешно. idMessage=%1", Ответ.idMessage));
	
КонецФункции

&НаКлиенте
Функция ПолучитьСообщение(Инстанс, Токен)
	
	Пока Истина Цикл
		Ответ = ОтправитьGETЗапрос(ХостПоУмолчанию(), URLМетодаСервиса(Инстанс, Токен, "receiveNotification"), Истина);
		Если Ответ <> Неопределено Тогда
			Если Ответ.body.typeWebhook = "incomingMessageReceived" Тогда
				receiptIdТекущий = Ответ.receiptId;
				Возврат Ответ.body.messageData.textMessageData.textMessage;
			Иначе
				УдалитьСообщение(Инстанс, Токен, Ответ.receiptId);
				// Другие вебхуки молча пропускаем;
			КонецЕсли;
		Иначе
			Возврат Неопределено;
		КонецЕсли;
	КонецЦикла;
	
КонецФункции

&НаКлиенте
Функция УдалитьСообщение(Инстанс, Токен, ТегСообщения)
	
	Адрес = URLМетодаСервиса(Инстанс, Токен, "deleteNotification") + "/" + Формат(ТегСообщения, "ЧГ=0");
	Ответ = ОтправитьDELETEЗапрос(ХостПоУмолчанию(), Адрес, Истина);
	Возврат Ответ.result;
	
КонецФункции

#КонецОбласти

#Область HttpКлиент

&НаКлиенте
Функция ОтправитьGETЗапрос(Хост, Адрес, Защищенное)
	
	Если Защищенное Тогда
		
		Сертификат = Новый ЗащищенноеСоединениеOpenSSL(
			Новый СертификатКлиентаWindows(СпособВыбораСертификатаWindows.Выбирать),
			Новый СертификатыУдостоверяющихЦентровWindows());
		
		Соединение = Новый HTTPСоединение(Хост,,,,,, Сертификат);
		
	Иначе
		
		Соединение = Новый HTTPСоединение(Хост);
		
	КонецЕсли;
	
	ВебЗапрос = Новый HTTPЗапрос(Адрес);
	Ответ = Соединение.Получить(ВебЗапрос);
	Если Ответ.КодСостояния = 200 Тогда
		ТелоОтвета = Ответ.ПолучитьТелоКакСтроку();
		Если Не ПустаяСтрока(ТелоОтвета) Тогда
			Чтение = Новый ЧтениеJSON();
			Чтение.УстановитьСтроку(ТелоОтвета);
			ПрочитанныйОтвет = ПрочитатьJSON(Чтение);
			Чтение.Закрыть();
			Возврат ПрочитанныйОтвет;
		Иначе
			Возврат Неопределено;
		КонецЕсли;
	Иначе
		ТекстОшибки = Ответ.ПолучитьТелоКакСтроку("UTF-8");
		ВызватьИсключение СтрШаблон("Сервер вернул статус %1. 
		|%2", Ответ.КодСостояния, ТекстОшибки);
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция ОтправитьPOSTЗапрос(Хост, Адрес, Тело)
	
	Сертификат = Новый ЗащищенноеСоединениеOpenSSL(
		Новый СертификатКлиентаWindows(СпособВыбораСертификатаWindows.Выбирать),
		Новый СертификатыУдостоверяющихЦентровWindows());
	
	Соединение = Новый HTTPСоединение(Хост,,,,,, Сертификат);
	
	ВебЗапрос = Новый HTTPЗапрос(Адрес);
	ВебЗапрос.Заголовки.Вставить("Content-Type", "application/json");
	
	ВебЗапрос.УстановитьТелоИзСтроки(Тело);
	Ответ = Соединение.ОтправитьДляОбработки(ВебЗапрос);
	Если Ответ.КодСостояния = 200 Тогда
		Чтение = Новый ЧтениеJSON();
		Чтение.УстановитьСтроку(Ответ.ПолучитьТелоКакСтроку());
		ПрочитанныйОтвет = ПрочитатьJSON(Чтение);
		Чтение.Закрыть();
		Возврат ПрочитанныйОтвет;
	Иначе
		ТекстОшибки = Ответ.ПолучитьТелоКакСтроку("UTF-8");
		ВызватьИсключение СтрШаблон("Сервер вернул статус %1. 
		|%2", Ответ.КодСостояния, ТекстОшибки);
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция ОтправитьDELETEЗапрос(Хост, Адрес, Защищенное)
	
	Если Защищенное Тогда
		
		Сертификат = Новый ЗащищенноеСоединениеOpenSSL(
			Новый СертификатКлиентаWindows(СпособВыбораСертификатаWindows.Выбирать),
			Новый СертификатыУдостоверяющихЦентровWindows());
		
		Соединение = Новый HTTPСоединение(Хост,,,,,, Сертификат);
		
	Иначе
		
		Соединение = Новый HTTPСоединение(Хост);
		
	КонецЕсли;
	
	ВебЗапрос = Новый HTTPЗапрос(Адрес);
	Ответ = Соединение.ВызватьHTTPМетод("DELETE", ВебЗапрос);
	Если Ответ.КодСостояния = 200 Тогда
		Чтение = Новый ЧтениеJSON();
		Чтение.УстановитьСтроку(Ответ.ПолучитьТелоКакСтроку());
		ПрочитанныйОтвет = ПрочитатьJSON(Чтение);
		Чтение.Закрыть();
		Возврат ПрочитанныйОтвет;
	Иначе
		ТекстОшибки = Ответ.ПолучитьТелоКакСтроку("UTF-8");
		ВызватьИсключение СтрШаблон("Сервер вернул статус %1. 
		|%2", Ответ.КодСостояния, ТекстОшибки);
	КонецЕсли;
	
КонецФункции

#КонецОбласти