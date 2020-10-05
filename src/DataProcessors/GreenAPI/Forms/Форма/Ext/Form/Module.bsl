﻿
#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПодготовитьНастройки();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Попытка
		ОбновитьСтатусСервиса();
	Исключение
		Сообщить(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРеквизитовКомандФормы

&НаКлиенте
Процедура ПроверитьПодключение(Команда)
	ОбновитьСтатусСервиса();
	Элементы.СтатусПроверки.Видимость = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПолучатьВходящиеУведомленияПриИзменении(Элемент)
	ПолучатьВходящиеУведомленияПриИзмененииСервер();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтатус(Команда)
	
	ОбновитьСтатусСервиса();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтандартныеНастройки(Команда)
	Оповещение = Новый ОписаниеОповещения("ЗавершитьПоказСтандартныхНастроек", ЭтотОбъект);
	ТекстВопроса = "Будут установлены стандартные настройки. Получение входящих уведомлений на текущий адрес " + webhookUrl + " будет отключено.";
	КнопкиВопроса = Новый СписокЗначений;
	КнопкиВопроса.Добавить("Отмена");
	КнопкиВопроса.Добавить("Установить стандартные настройки");
	ПоказатьВопрос(Оповещение, ТекстВопроса, КнопкиВопроса);
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
	
	ОтправитьСообщениеWhatsApp();
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСообщениеЧерезВебхук(Команда)
	Элементы.СтатусПолучениеСообщения.Видимость = Истина;
	ПодключитьОбработчикОжидания("Подключаемый_ПолучитьСообщениеЧерезВебхук", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПолучатьВходящиеСообщенияИФайлыПриИзменении(Элемент)
	ПолучатьВходящиеСообщенияИФайлыПриИзмененииСервер();
КонецПроцедуры

&НаКлиенте
Процедура ПолучатьСтатусыОтправленныхСообщенийПриИзменении(Элемент)
	ПолучатьСтатусыОтправленныхСообщенийПриИзмененииСервер();
КонецПроцедуры

&НаКлиенте
Процедура ПолучатьУведомленииОСостоянииТелефонаПриИзменении(Элемент)
	ПолучатьУведомленииОСостоянииТелефонаПриИзмененииСервер();
КонецПроцедуры

&НаКлиенте
Процедура ПолучатьУведомленияОСостоянииАккаунтаПриИзменении(Элемент)
	ПолучатьУведомленияОСостоянииАккаунтаПриИзмененииСервер();
КонецПроцедуры

&НаКлиенте
Процедура ОтмечатьВходящиеСообщенияПрочитаннымиПриИзменении(Элемент)
	ОтмечатьВходящиеСообщенияПрочитаннымиПриИзмененииСервер();
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалОтправкиСообщенийПриИзменении(Элемент)
	ИнтервалОтправкиСообщенийПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьФайл(Команда)
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Оповещение = Новый ОписаниеОповещения("ВыбратьФайлДляОтправки", ЭтотОбъект);
	Диалог.Показать(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьФайлПоСсылке(Команда)
	Оповещение = Новый ОписаниеОповещения("ВыбратьСсылкуДляОтправки", ЭтотОбъект);
	ПоказатьВводСтроки(Оповещение, "", "Введите url с ссылкой на файл",, Ложь); 
КонецПроцедуры

&НаКлиенте
Процедура СсылкаОтправитьТекстНажатие(Элемент)
	Оповещение = Новый ОписаниеОповещения("ЗавершитьЗапускПриложения", ЭтотОбъект);
	НачатьЗапускПриложения(Оповещение, "https://green-api.com/docs/api/sending/SendMessage/");
КонецПроцедуры

&НаКлиенте
Процедура СсылкаОтправитьФайлНажатие(Элемент)
	Оповещение = Новый ОписаниеОповещения("ЗавершитьЗапускПриложения", ЭтотОбъект);	
	НачатьЗапускПриложения(Оповещение, "https://green-api.com/docs/api/sending/SendFileByUpload/");
КонецПроцедуры

&НаКлиенте
Процедура СсылкаОтправитьФайлПоСсылкеНажатие(Элемент)
	Оповещение = Новый ОписаниеОповещения("ЗавершитьЗапускПриложения", ЭтотОбъект);	
	НачатьЗапускПриложения(Оповещение, "https://green-api.com/docs/api/sending/SendFileByUrl/");
КонецПроцедуры

&НаКлиенте
Процедура КнопкаПомощник(Команда)
	
	ОткрытьФорму("Обработка.GreenAPI.Форма.ПомощникПодключения",, ЭтотОбъект,,,,, 
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗавершитьЗапускПриложения(КодВозврата, ДополнительныеПараметры) Экспорт
	
	// Действия не требуются
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолучитьСообщениеЧерезВебхук() Экспорт
	ПолучитьСообщениеЧерезВебхукСервер();
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСсылкуДляОтправки(Строка, ДополнительныеПараметры) Экспорт
	
	Если Строка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВыбратьСсылкуДляОтправкиСервер(Строка);
	
КонецПроцедуры

&НаСервере
Процедура ВыбратьСсылкуДляОтправкиСервер(Строка)
	
	ЧастиУРЛ = СтрРазделить(Строка, "/");
	ИмяФайла = ЧастиУРЛ[ЧастиУРЛ.Количество() - 1] + ".png";
	
	Ответ = ОбработкаОбъект().ОтправитьФайлПоСсылке(НомерТелефона, Строка, ИмяФайла, ТекстСообщения);
	Сообщить("Файл отправлен успешно. idMessage=" + Ответ.idMessage);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФайлДляОтправки(ВыбранныеФайлы, ДопПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Или ВыбранныеФайлы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ВыбратьФайлДляОтправкиСервер(ВыбранныеФайлы[0]);
	
КонецПроцедуры

&НаСервере
Процедура ВыбратьФайлДляОтправкиСервер(ИмяФайла)
	
	Ответ = ОбработкаОбъект().ОтправитьФайлСДиска(НомерТелефона, ИмяФайла, ТекстСообщения);
	Сообщить("Файл отправлен успешно. idMessage=" + Ответ.idMessage);
	
КонецПроцедуры


&НаСервере
Процедура ПолучатьВходящиеУведомленияПриИзмененииСервер()
	
	Если ПолучатьВходящиеУведомления Тогда
		webhookUrl = ОбработкаОбъект().ХостВебхуковПоУмолчанию();
		Элементы.ДеталиНастройкиУведомлений.Доступность = Истина;
	Иначе
		webhookUrl = "";
		Элементы.ДеталиНастройкиУведомлений.Доступность = Ложь;
	КонецЕсли;
	
	НастройкиСохранены = ОбработкаОбъект().УстановитьНастройкуСервиса("webhookUrl", webhookUrl);
	ОбновитьСтатусСервиса();
	
КонецПроцедуры

&НаСервере
Процедура ОтправитьСообщениеWhatsApp()
	Ответ = ОбработкаОбъект().ОтправитьСообщение(НомерТелефона, ТекстСообщения);
	Сообщить("Сообщение отправлено успешно. idMessage=" + Ответ.idMessage);
КонецПроцедуры

&НаСервере
Процедура ОбновитьСтатусСервиса()
	
	Если Не ЭтотОбъект.ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СтатусСервиса = ОбработкаОбъект().ПолучитьСтатусСервиса();
	
	Если СтатусСервиса Тогда
		НастройкиСервиса = ОбработкаОбъект().ПолучитьНастройкиСервиса();
		ПолучатьВходящиеУведомления = ЗначениеЗаполнено(НастройкиСервиса.webhookUrl);
		webhookUrl = НастройкиСервиса.webhookUrl;
		ПолучатьВходящиеСообщенияИФайлы = НастройкиСервиса.incomingWebhook = "yes";
		ПолучатьСтатусыОтправленныхСообщений = НастройкиСервиса.outgoingWebhook = "yes";
		ПолучатьУведомленииОСостоянииТелефона = НастройкиСервиса.deviceWebhook = "yes";
		ПолучатьУведомленияОСостоянииАккаунта = НастройкиСервиса.stateWebhook = "yes";
		ОтмечатьВходящиеСообщенияПрочитанными = НастройкиСервиса.markIncomingMessagesReaded = "yes";
		ИнтервалОтправкиСообщений = НастройкиСервиса.delaySendMessagesMilliseconds;
		
		ЕстьНестадантныенастройки = Не ЗначениеЗаполнено(НастройкиСервиса.webhookUrl);
		Элементы.ДеталиПредупреждениеСтандартныеНастройки.Видимость = ЕстьНестадантныенастройки;
		Элементы.ГруппаПояснение1.Видимость = ЕстьНестадантныенастройки Или Не ЗначениеЗаполнено(НастройкиСервиса.webhookUrl);
		Элементы.ГруппаПолучениеСообщений.Видимость = Не ЕстьНестадантныенастройки И ЗначениеЗаполнено(НастройкиСервиса.webhookUrl);
		Элементы.ПолучатьВходящиеУведомления.Видимость = Не ЕстьНестадантныенастройки;
		Элементы.ДеталиНастройкиУведомлений.Видимость = Не ЕстьНестадантныенастройки;
	Иначе
		Элементы.ПолучатьВходящиеУведомления.Видимость = Ложь;
		Элементы.ДеталиНастройкиУведомлений.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьПоказСтандартныхНастроек(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = "Установить стандартные настройки" Тогда
		УстановитьНастройкуСервисаСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьНастройки()
	
	ТекстСообщения = "Hello world!";
	ЭтотОбъект.Заголовок = ОбработкаОбъект().ВерсияОбработки();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТекстИзМакета(ИмяМакета)
	Об = ОбработкаОбъект();
	ОбластьМакета = Об.ПолучитьМакет(ИмяМакета);
	Возврат ОбластьМакета.ТекущаяОбласть.Текст;
КонецФункции

&НаСервере
Функция ОбработкаОбъект() 
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции

&НаСервере
Процедура ПолучатьВходящиеСообщенияИФайлыПриИзмененииСервер()
	
	НастройкиСохранены = ОбработкаОбъект().УстановитьНастройкуСервиса("incomingWebhook", 
		? (ПолучатьВходящиеСообщенияИФайлы, "yes", "no"));
	
КонецПроцедуры

&НаСервере
Процедура ПолучатьСтатусыОтправленныхСообщенийПриИзмененииСервер()
	
	НастройкиСохранены = ОбработкаОбъект().УстановитьНастройкуСервиса("outgoingWebhook", 
		? (ПолучатьВходящиеСообщенияИФайлы, "yes", "no"));
	
КонецПроцедуры

&НаСервере
Процедура ПолучатьУведомленииОСостоянииТелефонаПриИзмененииСервер()
	
	НастройкиСохранены = ОбработкаОбъект().УстановитьНастройкуСервиса("deviceWebhook", 
		? (ПолучатьВходящиеСообщенияИФайлы, "yes", "no"));
	
КонецПроцедуры

&НаСервере
Процедура ПолучатьУведомленияОСостоянииАккаунтаПриИзмененииСервер()
	
	НастройкиСохранены = ОбработкаОбъект().УстановитьНастройкуСервиса("stateWebhook", 
		? (ПолучатьВходящиеСообщенияИФайлы, "yes", "no"));
	
КонецПроцедуры

&НаСервере
Процедура ОтмечатьВходящиеСообщенияПрочитаннымиПриИзмененииСервер()
	
	НастройкиСохранены = ОбработкаОбъект().УстановитьНастройкуСервиса("markIncomingMessagesReaded", 
		? (ОтмечатьВходящиеСообщенияПрочитанными, "yes", "no"));
	
КонецПроцедуры

&НаСервере
Процедура ИнтервалОтправкиСообщенийПриИзмененииСервер()
	
	НастройкиСохранены = ОбработкаОбъект().УстановитьНастройкуСервиса("delaySendMessagesMilliseconds", ИнтервалОтправкиСообщений);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСообщениеЧерезВебхукСервер()
	
	Объект.ТекстПолученноеСообщение = "";
	Объект.ПолученФайл = "";
	Элементы.СтатусПолучениеСообщения.Видимость = Истина;
	ОбработкаОбъект = ОбработкаОбъект();
	ОбработкаОбъект.ПолучитьСообщение();
	ЗначениеВРеквизитФормы(ОбработкаОбъект, "Объект");
	Элементы.СтатусПолучениеСообщения.Видимость = Ложь;
	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНастройкуСервисаСервер()
	
	НастройкиСохранены = ОбработкаОбъект().УстановитьНастройкуСервиса("webhookUrl", ОбработкаОбъект().ХостВебхуковПоУмолчанию());
	ОбновитьСтатусСервиса();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолученФайлОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(Объект.ПолученФайл) Тогда
		Оповещение = Новый ОписаниеОповещения("ЗавершитьЗапускПриложения", ЭтотОбъект);	
		НачатьЗапускПриложения(Оповещение, Объект.ПолученФайл);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СсылкаФорматВходящихУведомленийНажатие(Элемент)
	Оповещение = Новый ОписаниеОповещения("ЗавершитьЗапускПриложения", ЭтотОбъект);	
	НачатьЗапускПриложения(Оповещение, "https://green-api.com/docs/index.html");
КонецПроцедуры

&НаКлиенте
Процедура СсылкаПолучитьУведомлениеНажатие(Элемент)
	Оповещение = Новый ОписаниеОповещения("ЗавершитьЗапускПриложения", ЭтотОбъект);	
	НачатьЗапускПриложения(Оповещение, "https://green-api.com/docs/api/receiving/technology-http-api/ReceiveNotification/");
КонецПроцедуры

&НаКлиенте
Процедура СсылкаУдалитьУведомлениеНажатие(Элемент)
	Оповещение = Новый ОписаниеОповещения("ЗавершитьЗапускПриложения", ЭтотОбъект);	
	НачатьЗапускПриложения(Оповещение, "https://green-api.com/docs/api/receiving/technology-http-api/DeleteNotification/");
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Объект.IdInstance = ВыбранноеЗначение.IdInstance;
		Объект.ApiToken = ВыбранноеЗначение.ApiToken;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
