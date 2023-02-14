﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	КартинкаWhatsApp = ПолучитьКартинкуОбработки("ИконкаWhatsApp");
	КартинкаВыборАккаунта = ПолучитьКартинкуОбработки("ВыборАккаунта");
	КартинкаСканКода = ПолучитьКартинкуОбработки("СканQR");
	КартинкаДанныеАккаунта = ПолучитьКартинкуОбработки("ДанныеАккаунта");
	ИконкаФиниш = ПолучитьКартинкуОбработки("ИконкаФиниш");
	
	ЭтотОбъект.Заголовок = ОбработкаОбъект().ВерсияОбработки();
	
	Если Параметры.Свойство("IdInstance") Тогда
		Объект.IdInstance = Параметры.IdInstance;
	КонецЕсли;
	
	Если Параметры.Свойство("ApiToken") Тогда
		Объект.ApiToken = Параметры.ApiToken;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Устанавливаем текущую таблицу переходов.
	ТаблицаПереходовПоСценарию1();
	
	// Позиционируемся на первом шаге помощника.
	УстановитьПорядковыйНомерПерехода(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ТекстПредупреждения = НСтр("ru = 'Закрыть помощник?'");
	ПоказатьПодтверждениеЗакрытияПроизвольнойФормы(
		ЭтотОбъект, Отказ, ЗавершениеРаботы, ТекстПредупреждения, "ЗакрытьФормуБезусловно");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаДалее(Команда)
	
	ИзменитьПорядковыйНомерПерехода(+1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНазад(Команда)
	
	ИзменитьПорядковыйНомерПерехода(-1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаГотово(Команда)
	
	ЗакрытьФормуБезусловно = Истина;
	
	ОповеститьОВыборе(Новый Структура("ИмяФормы,IdInstance, ApiToken", "ПомощникПодключения", Объект.IdInstance, Объект.ApiToken));
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Поставляемая часть

&НаКлиенте
Процедура ИзменитьПорядковыйНомерПерехода(Итератор)
	
	ОчиститьСообщения();
	
	УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + Итератор);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПорядковыйНомерПерехода(Знач Значение)
	
	ЭтоПереходДалее = (Значение > ПорядковыйНомерПерехода);
	
	ПорядковыйНомерПерехода = Значение;
	
	Если ПорядковыйНомерПерехода < 0 Тогда
		
		ПорядковыйНомерПерехода = 0;
		
	КонецЕсли;
	
	ПорядковыйНомерПереходаПриИзменении(ЭтоПереходДалее);
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядковыйНомерПереходаПриИзменении(Знач ЭтоПереходДалее)
	
	// Выполняем обработчики событий перехода.
	ВыполнитьОбработчикиСобытийПерехода(ЭтоПереходДалее);
	
	// Устанавливаем отображение страниц.
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	Элементы.ПанельОсновная.ТекущаяСтраница  = Элементы[СтрокаПереходаТекущая.ИмяОсновнойСтраницы];
	Элементы.ПанельНавигации.ТекущаяСтраница = Элементы[СтрокаПереходаТекущая.ИмяСтраницыНавигации];
	
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяСтраницыДекорации) Тогда
		
		Элементы.ПанельДекорации.ТекущаяСтраница = Элементы[СтрокаПереходаТекущая.ИмяСтраницыДекорации];
		
	КонецЕсли;
	
	// Устанавливаем текущую кнопку по умолчанию.
	КнопкаДалее = ПолучитьКнопкуФормыПоИмениКоманды(Элементы.ПанельНавигации.ТекущаяСтраница, "КомандаДалее");
	
	Если КнопкаДалее <> Неопределено Тогда
		
		КнопкаДалее.КнопкаПоУмолчанию = Истина;
		
	Иначе
		
		КнопкаГотово = ПолучитьКнопкуФормыПоИмениКоманды(Элементы.ПанельНавигации.ТекущаяСтраница, "КомандаГотово");
		
		Если КнопкаГотово <> Неопределено Тогда
			
			КнопкаГотово.КнопкаПоУмолчанию = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтоПереходДалее И СтрокаПереходаТекущая.ДлительнаяОперация Тогда
		
		ПодключитьОбработчикОжидания("ВыполнитьОбработчикДлительнойОперации", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикиСобытийПерехода(Знач ЭтоПереходДалее)
	
	// Обработчики событий переходов.
	Если ЭтоПереходДалее Тогда
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода - 1));
		
		Если СтрокиПерехода.Количество() > 0 Тогда
			
			СтрокаПерехода = СтрокиПерехода[0];
			
			// Обработчик ПриПереходеДалее.
			Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеДалее)
				И Не СтрокаПерехода.ДлительнаяОперация Тогда
				
				ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
				ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеДалее);
				
				Отказ = Ложь;
				
				Результат = Вычислить(ИмяПроцедуры);
				
				Если Отказ Тогда
					
					ПорядковыйНомерПерехода = ПорядковыйНомерПерехода - 1;
					Возврат;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода + 1));
		
		Если СтрокиПерехода.Количество() > 0 Тогда
			
			СтрокаПерехода = СтрокиПерехода[0];
			
			// Обработчик ПриПереходеНазад.
			Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеНазад)
				И Не СтрокаПерехода.ДлительнаяОперация Тогда
				
				ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
				ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеНазад);
				
				Отказ = Ложь;
				
				Результат = Вычислить(ИмяПроцедуры);
				
				Если Отказ Тогда
					
					ПорядковыйНомерПерехода = ПорядковыйНомерПерехода + 1;
					Возврат;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	Если СтрокаПереходаТекущая.ДлительнаяОперация И Не ЭтоПереходДалее Тогда
		
		УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
		Возврат;
	КонецЕсли;
	
	// обработчик ПриОткрытии
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии) Тогда
		
		ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ, ПропуститьСтраницу, ЭтоПереходДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии);
		
		Отказ = Ложь;
		ПропуститьСтраницу = Ложь;
		
		Результат = Вычислить(ИмяПроцедуры);
		
		Если Отказ Тогда
			
			ПорядковыйНомерПерехода = ПорядковыйНомерПерехода - 1;
			Возврат;
			
		ИначеЕсли ПропуститьСтраницу Тогда
			
			Если ЭтоПереходДалее Тогда
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
				Возврат;
				
			Иначе
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикДлительнойОперации()
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	// Обработчик ОбработкаДлительнойОперации.
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаДлительнойОперации) Тогда
		
		ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ, ПерейтиДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаДлительнойОперации);
		
		Отказ = Ложь;
		ПерейтиДалее = Истина;
		
		Результат = Вычислить(ИмяПроцедуры);
		
		Если Отказ Тогда
			
			ПорядковыйНомерПерехода = ПорядковыйНомерПерехода - 1;
			Возврат;
			
		ИначеЕсли ПерейтиДалее Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
			Возврат;
			
		КонецЕсли;
		
	Иначе
		
		УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьКнопкуФормыПоИмениКоманды(ЭлементФормы, ИмяКоманды)
	
	Для Каждого Элемент Из ЭлементФормы.ПодчиненныеЭлементы Цикл
		
		Если ТипЗнч(Элемент) = Тип("ГруппаФормы") Тогда
			
			ЭлементФормыПоИмениКоманды = ПолучитьКнопкуФормыПоИмениКоманды(Элемент, ИмяКоманды);
			
			Если ЭлементФормыПоИмениКоманды <> Неопределено Тогда
				
				Возврат ЭлементФормыПоИмениКоманды;
				
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Элемент) = Тип("КнопкаФормы")
			И СтрНайти(Элемент.ИмяКоманды, ИмяКоманды) > 0 Тогда
			
			Возврат Элемент;
			
		Иначе
			
			Продолжить;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Переопределяемая часть - Обработчики событий переходов.

// Обработчик перехода далее (на следующую страницу) при уходе со страницы помощника "СтраницаДва".
//
// Параметры:
//   Отказ - Булево - флаг отказа от выполнения перехода далее;
//					если в обработчике поднять этот флаг, то переход на следующую страницу выполнен не будет.
//
&НаКлиенте
Функция Подключаемый_СтраницаДва_ПриПереходеДалее(Отказ)
	
	Если СУсловиямиОзнакомлен Тогда
		Сообщить(НСтр("ru = 'Выполняется обработчик ПриПереходеДалее страницы № 2'"));
	Иначе
		Сообщить(НСтр("ru = 'Необходимо сначала ознакомиться с условиями.'"));
		Отказ = Истина;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Функция Подключаемый_СтраницаПять_ПриПереходеДалее(Отказ)
	
	Если ЗначениеЗаполнено(Объект.IdInstance) И ЗначениеЗаполнено(Объект.ApiToken) Тогда
		
	Иначе
		Сообщить(НСтр("ru = 'Необходимо заполнить ID Instance и API Token'"));
		Отказ = Истина;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Функция Подключаемый_СтраницаВосемь_ПриПереходеДалее(Отказ)
	
	Если Не ИспользуйтеДляКлиентов Или Не ИспользуйтеДляСвоихКлиентоа Или Не ИспользуйтеДляЧатБотов
		Или Не СтарайтесьЧтобыОтвечали Или Не ПредоставьтеОтписку Тогда
		
		Отказ = Истина;
		ПоказатьПредупреждение(, "Требуется отметить все галочки, чтобы продолжить");
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Обработчик перехода назад (на предыдущую страницу) при уходе со страницы помощника "СтраницаДва".
//
// Параметры:
//   Отказ - Булево - флаг отказа от выполнения перехода назад;
//					если в обработчике поднять этот флаг, то переход на предыдущую страницу выполнен не будет.
//
&НаКлиенте
Функция Подключаемый_СтраницаДва_ПриПереходеНазад(Отказ)
	
	Сообщить(НСтр("ru = 'Выполняется обработчик ПриПереходеНазад страницы № 2'"));
	
	Возврат Неопределено;
	
КонецФункции

// Обработчик выполняется при открытии страницы помощника "СтраницаДва".
//
// Параметры:
//
//  Отказ - Булево - флаг отказа от открытия страницы;
//			если в обработчике поднять этот флаг, то переход на страницу выполнен не будет,
//			останется открытой предыдущая страница помощника согласно направлению перехода (вперед или назад).
//
//  ПропуститьСтраницу - Булево - если поднять этот флаг, то страница будет пропущена
//			и управление перейдет на следующую страницу помощника согласно направлению перехода (вперед или назад).
//
//  ЭтоПереходДалее (только чтение) - Булево - флаг определяет направление перехода.
//			Истина - выполняется переход далее; Ложь - выполняется переход назад.
//
&НаКлиенте
Функция Подключаемый_СтраницаДва_ПриОткрытии(Отказ, ПропуститьСтраницу, Знач ЭтоПереходДалее)
	
	Сообщить(НСтр("ru = 'Выполняется обработчик ПриОткрытии страницы № 2'"));
	
	Возврат Неопределено;
	
КонецФункции

// Обработчик перехода далее (на следующую страницу) при уходе со страницы помощника "СтраницаОжидания".
//
// Параметры:
//   Отказ - Булево - флаг отказа от выполнения перехода далее;
//					если в обработчике поднять этот флаг, то переход на следующую страницу выполнен не будет.
//
&НаКлиенте
Функция Подключаемый_СтраницаОжидания_ОбработкаДлительнойОперации(Отказ, ПерейтиДалее)
	
	ВыполнитьПродолжительноеДействиеНаСервере(Отказ);
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Функция Подключаемый_СтраницаСемь_ПриОткрытии(Отказ, ПропуститьСтраницу, Знач ЭтоПереходДалее)
	
	Если ЭтоПереходДалее Тогда
		Элементы.КомандаДалее1.Видимость = СтатусСервиса;
	Иначе
		ПропуститьСтраницу = Истина;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Функция Подключаемый_СтраницаСемь_ПриПереходеНазад(Отказ)
	
	Элементы.КомандаДалее1.Видимость = Истина;

	Возврат Неопределено;
	
КонецФункции


&НаСервере
Процедура ВыполнитьПродолжительноеДействиеНаСервере(Отказ)
	
	СтатусСервисаТекст = ОбработкаОбъект().ПолучитьСтатусСервиса(ТекстОшибкиПодключения);
	СтатусСервиса =  СтатусСервисаТекст <> "error";
	Если СтатусСервиса Тогда
		ОбработкаОбъект().УстановитьНастройкиСервисаПоДефолту();
	КонецЕсли;
	
	Элементы.ГруппаУспешноеПодключение.Видимость = СтатусСервиса;
	Элементы.ГруппаОшибкаПодключения.Видимость = Не СтатусСервиса;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Переопределяемая часть - Инициализация переходов помощника.

// Процедура определяет таблицу переходов по сценарию №1.
//
&НаКлиенте
Процедура ТаблицаПереходовПоСценарию1()
	
	ТаблицаПереходов.Очистить();
	
	Переход = ТаблицаПереходов.Добавить();
	Переход.ПорядковыйНомерПерехода = 1;
	Переход.ИмяОсновнойСтраницы     = "СтраницаОдин";
	Переход.ИмяСтраницыНавигации    = "СтраницаНавигацииНачало";
	Переход.ИмяСтраницыДекорации    = "СтраницаДекорацииНачало";
	
	Переход = ТаблицаПереходов.Добавить();
	Переход.ПорядковыйНомерПерехода = 2;
	Переход.ИмяОсновнойСтраницы     = "СтраницаДва";
	Переход.ИмяСтраницыНавигации    = "СтраницаНавигацииПродолжение";
	Переход.ИмяСтраницыДекорации    = "СтраницаДекорацииПродолжение";
	
	Переход = ТаблицаПереходов.Добавить();
	Переход.ПорядковыйНомерПерехода = 3;
	Переход.ИмяОсновнойСтраницы     = "СтраницаТри";
	Переход.ИмяСтраницыНавигации    = "СтраницаНавигацииПродолжение";
	Переход.ИмяСтраницыДекорации    = "СтраницаДекорацииПродолжение";
	
	Переход = ТаблицаПереходов.Добавить();
	Переход.ПорядковыйНомерПерехода = 4;
	Переход.ИмяОсновнойСтраницы     = "СтраницаЧетыре";
	Переход.ИмяСтраницыНавигации    = "СтраницаНавигацииПродолжение";
	Переход.ИмяСтраницыДекорации    = "СтраницаДекорацииПродолжение";
	
	Переход = ТаблицаПереходов.Добавить();
	Переход.ПорядковыйНомерПерехода = 5;
	Переход.ИмяОсновнойСтраницы     = "СтраницаПять";
	Переход.ИмяСтраницыНавигации    = "СтраницаНавигацииПродолжение";
	Переход.ИмяСтраницыДекорации    = "СтраницаДекорацииПродолжение";
	Переход.ИмяОбработчикаПриПереходеДалее = "СтраницаПять_ПриПереходеДалее";
	
	Переход = ТаблицаПереходов.Добавить();
	Переход.ПорядковыйНомерПерехода = 6;
	Переход.ИмяОсновнойСтраницы     = "СтраницаОжидания";
	Переход.ИмяСтраницыНавигации    = "СтраницаНавигацииОжидание";
	Переход.ИмяСтраницыДекорации    = "СтраницаДекорацииПродолжение";
	Переход.ДлительнаяОперация      = Истина;
	Переход.ИмяОбработчикаДлительнойОперации = "СтраницаОжидания_ОбработкаДлительнойОперации";
	
	Переход = ТаблицаПереходов.Добавить();
	Переход.ПорядковыйНомерПерехода = 7;
	Переход.ИмяОсновнойСтраницы     = "СтраницаСемь";
	Переход.ИмяСтраницыНавигации    = "СтраницаНавигацииПродолжение";
	Переход.ИмяСтраницыДекорации    = "СтраницаДекорацииПродолжение";
	Переход.ИмяОбработчикаПриОткрытии = "СтраницаСемь_ПриОткрытии";
	Переход.ИмяОбработчикаПриПереходеНазад = "СтраницаСемь_ПриПереходеНазад";
	
	Переход = ТаблицаПереходов.Добавить();
	Переход.ПорядковыйНомерПерехода = 8;
	Переход.ИмяОсновнойСтраницы     = "СтраницаВосемь";
	Переход.ИмяСтраницыНавигации    = "СтраницаНавигацииПродолжение";
	Переход.ИмяСтраницыДекорации    = "СтраницаДекорацииПродолжение";
	Переход.ИмяОбработчикаПриПереходеДалее = "СтраницаВосемь_ПриПереходеДалее";

	
	Переход = ТаблицаПереходов.Добавить();
	Переход.ПорядковыйНомерПерехода = 9;
	Переход.ИмяОсновнойСтраницы     = "СтраницаДевять";
	Переход.ИмяСтраницыНавигации    = "СтраницаНавигацииОкончание";
	Переход.ИмяСтраницыДекорации    = "СтраницаДекорацииОкончание";
	
КонецПроцедуры

#КонецОбласти

// Задает вопрос о продолжении действия, которое приведет к закрытию формы.
// Для использования в обработчиках события ПередЗакрытием модулей форм.
// Для отображения вопроса в форме, которая  возможно записать в информационную базу, используйте: 
//  см. процедуру ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы().
//
// Параметры:
//  Форма                        - ФормаКлиентскогоПриложения - форма, которая вызывает диалог предупреждения.
//  Отказ                        - Булево - возвращаемый параметр, признак отказа от выполняемого действия.
//  ЗавершениеРаботы             - Булево - признак завершения работы программы.
//  ТекстПредупреждения          - Строка - текст предупреждения, выводимый пользователю.
//  ИмяРеквизитаЗакрытьФормуБезПодтверждения - Строка - имя реквизита, содержащего в себе признак того, нужно
//                                 выводить предупреждение или нет.
//  ОписаниеОповещенияЗакрыть    - ОписаниеОповещения - содержит имя процедуры, вызываемой при нажатии на кнопку "Да".
//
// Пример: 
//  ТекстПредупреждения = НСтр("ru = 'Закрыть помощник?'");
//  ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияПроизвольнойФормы(
//      ЭтотОбъект, Отказ, ТекстПредупреждения, "ЗакрытьФормуБезПодтверждения");
//
&НаКлиенте
Процедура ПоказатьПодтверждениеЗакрытияПроизвольнойФормы(
		Знач Форма, 
		Отказ, 
		Знач ЗавершениеРаботы, 
		Знач ТекстПредупреждения, 
		Знач ИмяРеквизитаЗакрытьФормуБезПодтверждения, 
		Знач ОписаниеОповещенияЗакрыть = Неопределено) Экспорт
		
	Если Форма[ИмяРеквизитаЗакрытьФормуБезПодтверждения] Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ТекстПредупреждения", ТекстПредупреждения);
	ПараметрыФормы.Вставить("ИмяРеквизитаЗакрытьФормуБезПодтверждения", ИмяРеквизитаЗакрытьФормуБезПодтверждения);
	ПараметрыФормы.Вставить("ОписаниеОповещенияЗакрыть", ОписаниеОповещенияЗакрыть);
	
	ПодключитьОбработчикОжидания("ПодтвердитьЗакрытиеПроизвольнойФормыСейчасGR", 0.1, Истина);
	
КонецПроцедуры

// Задает вопрос о продолжении действия, ведущего к закрытию формы.
//
&НаКлиенте
Процедура ПодтвердитьЗакрытиеПроизвольнойФормыСейчасGR() Экспорт
	
	ПодтвердитьЗакрытиеПроизвольнойФормыGR();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтвердитьЗакрытиеПроизвольнойФормыGR() Экспорт
	
	РежимВопроса = РежимДиалогаВопрос.ДаНет;
	
	Оповещение = Новый ОписаниеОповещения("ПодтвердитьЗакрытиеПроизвольнойФормыЗавершениеПК", ЭтотОбъект, ПараметрыФормы);
	
	ПоказатьВопрос(Оповещение, ПараметрыФормы.ТекстПредупреждения, РежимВопроса);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьКартинкуОбработки(ИмяМакета)
	Об = РеквизитФормыВЗначение("Объект");
	Картинка = Новый Картинка(Об.ПолучитьМакет(ИмяМакета));
	Возврат ПоместитьВоВременноеХранилище(Картинка, УникальныйИдентификатор);
КонецФункции 

&НаСервере
Функция ОбработкаОбъект() 
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции

&НаКлиенте
Процедура ПодтвердитьЗакрытиеПроизвольнойФормыЗавершениеПК(Ответ, Параметры) Экспорт
	
	Форма = ЭтотОбъект;
	Если Ответ = КодВозвратаДиалога.Да
		Или Ответ = КодВозвратаДиалога.ОК Тогда
		Форма[Параметры.ИмяРеквизитаЗакрытьФормуБезПодтверждения] = Истина;
		Если Параметры.ОписаниеОповещенияЗакрыть <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(Параметры.ОписаниеОповещенияЗакрыть);
		КонецЕсли;
		Форма.Закрыть();
	Иначе
		Форма[Параметры.ИмяРеквизитаЗакрытьФормуБезПодтверждения] = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗарегистрироватьсяВBasisAPI(Команда)
	Оповещение = Новый ОписаниеОповещения("ЗавершитьЗапускПриложенияGR", ЭтотОбъект);
	НачатьЗапускПриложения(Оповещение, "https://cabinet.basis-api.com/");
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьЗапускПриложенияGR(КодВозврата, ДополнительныеПараметры) Экспорт
	
	// Действия не требуются
	
КонецПроцедуры
